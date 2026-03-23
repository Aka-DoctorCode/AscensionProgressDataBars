-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
-- Author: Aka-DoctorCode
-- File: Bars/Reputation.lua
-- Version: @project-version@
-------------------------------------------------------------------------------
-- Copyright (c) 2025-2026 Aka-DoctorCode. All Rights Reserved.
--
-- This software and its source code are the exclusive property of the author.
-- No part of this file may be copied, modified, redistributed, or used in
-- derivative works without express written permission.
-------------------------------------------------------------------------------

local addonName, addonTable = ...
---@type AscensionBars
local core = addonTable.main or LibStub("AceAddon-3.0"):GetAddon(addonName)
---@cast core AscensionBars
local Locales  = LibStub("AceLocale-3.0"):GetLocale("AscensionBars")
local dataText = addonTable.dataText

-------------------------------------------------------------------------------
-- MODULE DEFINITION
-------------------------------------------------------------------------------

local ReputationModule = core:NewModule("Reputation", "AceEvent-3.0")
ReputationModule.core  = core

-------------------------------------------------------------------------------
-- MODULE LIFECYCLE
-------------------------------------------------------------------------------

function ReputationModule:OnEnable()
    self:RegisterEvent("UPDATE_FACTION", "onUpdateFaction")
end

function ReputationModule:OnDisable()
    self:UnregisterAllEvents()
end

-------------------------------------------------------------------------------
-- EVENT HANDLERS
-------------------------------------------------------------------------------

function ReputationModule:onUpdateFaction()
    if self.core.scanParagonRewards then self.core:scanParagonRewards() end

    local state  = self.core.state
    if not state then return end

    if not (C_Reputation and C_Reputation.GetNumFactions and C_Reputation.GetFactionDataByIndex) then
        self.core:updateDisplay()
        return
    end

    local numFactions = C_Reputation.GetNumFactions()
    if not numFactions then
        self.core:updateDisplay()
        return
    end

    for i = 1, numFactions do
        local factionData = C_Reputation.GetFactionDataByIndex(i)
        if factionData and factionData.factionID then
            local id      = factionData.factionID
            local current = factionData.currentStanding
            local last    = state.lastReputation[id]

            if last and current and current > last then
                local gained = current - last
                if self.core.pushCarouselEvent then
                    self.core:pushCarouselEvent("REP", id, factionData.name, gained)
                end
            end

            state.lastReputation[id] = current
        end
    end

    self.core:updateDisplay()
end

-------------------------------------------------------------------------------
-- RENDER DISPATCH
-------------------------------------------------------------------------------

function ReputationModule:UpdateRender(isConfig, shouldHideXP)
    if isConfig then
        self:renderConfig()
    else
        self:renderLive()
    end
end

-------------------------------------------------------------------------------
-- FACTION DATA NORMALIZER
-------------------------------------------------------------------------------

--- Normalizes a faction ID into a unified data table regardless of type.
-- Handles Major Factions (Renown), Friendship Factions, and Standard reputation.
-- @param factionId number The faction ID to query.
-- @return table|nil Normalized data table.
function ReputationModule:getFactionData(factionId)
    if not factionId then return nil end
    if not (C_Reputation and C_Reputation.IsFactionParagon) then return nil end

    local data = {
        id           = factionId,
        currentValue = 0,
        maxValue     = 1,
        levelName    = "",
        isMaxLevel   = false,
        hasParagon   = C_Reputation.IsFactionParagon(factionId),
        type         = "STANDARD",
        reaction     = 0,
    }

    local isHandled = false

    -- 1. Major Faction (Renown)
    if C_Reputation.IsMajorFaction and C_Reputation.IsMajorFaction(factionId) then
        isHandled = true
        if C_MajorFactions and C_MajorFactions.GetMajorFactionData then
            local majorData = C_MajorFactions.GetMajorFactionData(factionId)
            if majorData then
                data.type         = "RENOWN"
                data.reaction     = 11
                data.currentValue = majorData.renownReputationEarned or 0
                data.maxValue     = majorData.renownLevelThreshold   or 2500
                data.isMaxLevel   = (majorData.renownLevel >= majorData.maxLevel)
                data.levelName    = string.format("%s %d", Locales["RENOWN_LEVEL"], majorData.renownLevel)

                if data.isMaxLevel and not data.hasParagon then
                    data.currentValue, data.maxValue = 1, 1
                    data.reaction = 10
                end
            end
        end
    end

    -- 2. Friendship Factions (only if not already handled as Major)
    if not isHandled and C_GossipInfo and C_GossipInfo.GetFriendshipReputation then
        local friendData = C_GossipInfo.GetFriendshipReputation(factionId)
        if friendData and friendData.friendshipFactionID and friendData.friendshipFactionID > 0 then
            isHandled         = true
            data.type         = "FRIENDSHIP"
            data.reaction     = 5
            data.levelName    = friendData.reaction or ""
            data.currentValue = (friendData.standing or 0) - (friendData.reactionThreshold or 0)
            data.maxValue     = friendData.nextThreshold
                and (friendData.nextThreshold - friendData.reactionThreshold) or 1
            data.isMaxLevel   = (friendData.nextThreshold == nil)

            if data.isMaxLevel and not data.hasParagon then
                data.currentValue, data.maxValue = 1, 1
                data.reaction = 10
            end
        end
    end

    -- 3. Standard Reputation (fallback for all non-Major, non-Friendship factions)
    if not isHandled and C_Reputation.GetFactionDataByID then
        local factionData = C_Reputation.GetFactionDataByID(factionId)
        if factionData then
            local reactionIndex = factionData.reaction or 0
            data.reaction     = reactionIndex
            data.levelName    = _G["FACTION_STANDING_LABEL" .. reactionIndex] or reactionIndex
            data.currentValue = factionData.currentStanding - factionData.currentReactionThreshold
            data.maxValue     = factionData.nextReactionThreshold - factionData.currentReactionThreshold
            data.isMaxLevel   = (reactionIndex == 8)

            if data.isMaxLevel and not data.hasParagon then
                data.currentValue, data.maxValue = 1, 1
                data.reaction = 10
            end
        end
    end

    -- 4. Paragon Override
    if data.hasParagon and data.isMaxLevel and C_Reputation.GetFactionParagonInfo then
        local currentValue, threshold = C_Reputation.GetFactionParagonInfo(factionId)
        if currentValue and threshold and threshold > 0 then
            data.currentValue = currentValue % threshold
            data.maxValue     = threshold
            data.levelName    = Locales["PARAGON"]
            data.reaction     = 9
            data.isMaxLevel   = false
        end
    end

    return data
end

-------------------------------------------------------------------------------
-- LIVE RENDER
-------------------------------------------------------------------------------

function ReputationModule:renderLive()
    local profile = self.core.db and self.core.db.profile
    if not profile then return end

    local repObj = self.core.rep
    if not repObj then return end

    local repConfig = profile.bars and profile.bars["Rep"]
    if not repConfig or not repConfig.enabled then
        if repObj.bar     then repObj.bar:Hide()     end
        if repObj.txFrame then repObj.txFrame:Hide() end
        return
    end

    local name, reaction, curVal, maxVal, standingLabel
    local isMaxLevel, hasParagon = false, false
    local characterKey = UnitName("player") .. "-" .. GetRealmName()

    -- Paragon rewards cache check
    local currentPending = {}
    if self.core.db.global.paragonRewards and self.core.db.global.paragonRewards[characterKey] then
        for fId, fName in pairs(self.core.db.global.paragonRewards[characterKey]) do
            table.insert(currentPending, { id = fId, name = fName })
        end
    end

    local otherCharWithReward = nil
    if #currentPending == 0 and self.core.db.global.paragonRewards then
        for charKey, rewards in pairs(self.core.db.global.paragonRewards) do
            if charKey ~= characterKey and next(rewards) then
                otherCharWithReward = string.match(charKey, "(.+)-") or charKey
                break
            end
        end
    end

    -- Paragon Alert Rendering
    if (#currentPending > 0 or otherCharWithReward) and self.core.paragonText then
        -- Default Paragon Pending Green: #00FF00
        local pColor = profile.paragonPendingColor or { r = 0, g = 1, b = 0, a = 1 }
        local hex    = string.format("|cff%02x%02x%02x",
            math.floor(pColor.r * 255),
            math.floor(pColor.g * 255),
            math.floor(pColor.b * 255))

        local alertText = ""
        if #currentPending > 0 then
            local names = {}
            for _, info in ipairs(currentPending) do
                table.insert(names, string.upper(info.name))
            end
            local factionStr = names[1]
            if #names > 1 then
                local last = table.remove(names)
                factionStr = table.concat(names, ", ") .. Locales["AND"] .. last
            end
            local suffix = (#currentPending > 1) and Locales["REWARD_PENDING_PLURAL"] or Locales["REWARD_PENDING_SINGLE"]
            alertText  = hex .. factionStr .. suffix .. "|r"

            name         = currentPending[1] and currentPending[1].name or ""
            reaction     = 9
            curVal       = 1
            maxVal       = 1
            standingLabel = Locales["REWARD_PENDING_STATUS"]
            isMaxLevel   = false
            hasParagon   = true
        else
            local charName = string.upper(tostring(otherCharWithReward or "Unknown"))
            alertText = hex .. string.format(Locales["REWARD_ON_CHAR"] or "%s", charName) .. "|r"
        end

        local pt = self.core.paragonText
        pt:SetFont(self.core.fontToUse, profile.paragonTextSize or 18, "OUTLINE")
        pt:SetText(alertText)
        pt:ClearAllPoints()

        local pY = profile.paragonTextYOffset or -100
        if profile.paragonOnTop then
            pt:SetPoint("TOP", _G.UIParent, "TOP", 0, pY)
        elseif profile.barAnchor == "BOTTOM" then
            pt:SetPoint("BOTTOM", self.core.textHolder, "TOP", 0, -pY)
        else
            pt:SetPoint("TOP", self.core.textHolder, "BOTTOM", 0, pY)
        end
        pt:Show()
    elseif self.core.paragonText then
        self.core.paragonText:Hide()
    end

    -- Get watched faction if no reward alert is active
    if not name then
        if C_Reputation and C_Reputation.GetWatchedFactionData then
            local watchedData = C_Reputation.GetWatchedFactionData()
            if watchedData then
                local normalized = self:getFactionData(watchedData.factionID)
                if normalized then
                    name         = watchedData.name
                    reaction     = normalized.reaction
                    curVal       = normalized.currentValue
                    maxVal       = normalized.maxValue
                    standingLabel = normalized.levelName
                    isMaxLevel   = normalized.isMaxLevel
                    hasParagon   = normalized.hasParagon
                end
            end
        end
    end

    -- Final bar setup
    if name and repObj then
        if repObj.bar     then repObj.bar:Show()     end
        if repObj.txFrame then repObj.txFrame:Show() end

        local cur  = math.max(0, curVal or 0)
        local max  = math.max(1, maxVal or 1)
        if cur > max then cur = max end
        local percentage = (cur / max) * 100

        local useReaction = profile.useReactionColorRep
        local repColors   = profile.repColors
        -- Default Reputation Green: #00FF00
        local rBarColor   = profile.repBarColor or { r = 0, g = 1, b = 0, a = 1 }
        local color       = (useReaction and repColors and repColors[reaction]) or rBarColor

        self.core:setupBar(repObj, 0, max, cur, color)

        repObj.current    = cur
        repObj.max        = max
        repObj.percentage = percentage
        repObj.displayName = name
        repObj.standing   = standingLabel
        repObj.color      = color

        if dataText and repObj.centerText then
            local result = dataText:formatReputation(name, standingLabel, cur, max, isMaxLevel, hasParagon)
            repObj.centerText:SetText(result)
            if repObj.leftText  then repObj.leftText:SetText("")  end
            if repObj.rightText then repObj.rightText:SetText("") end
        end
    elseif repObj then
        if repObj.bar     then repObj.bar:Hide()     end
        if repObj.txFrame then repObj.txFrame:Hide() end
    end
end

-------------------------------------------------------------------------------
-- CONFIG PREVIEW RENDER
-------------------------------------------------------------------------------

function ReputationModule:renderConfig()
    local profile = self.core.db and self.core.db.profile
    if not profile then return end

    local repObj = self.core.rep
    if not repObj then return end

    local repConfig = profile.bars and profile.bars["Rep"]
    if not repConfig or not repConfig.enabled then
        if repObj.bar     then repObj.bar:Hide()     end
        if repObj.txFrame then repObj.txFrame:Hide() end
        return
    end

    if repObj.bar     then repObj.bar:Show()     end
    if repObj.txFrame then repObj.txFrame:Show() end

    -- Default Reputation Green: #00FF00
    local repColor = profile.repBarColor or { r = 0, g = 1, b = 0, a = 1 }
    self.core:setupBar(repObj, 0, 100, 50, repColor)

    repObj.current     = 1500
    repObj.max         = 3000
    repObj.percentage  = 50
    repObj.displayName = Locales["REPUTATION"] or "Reputation"
    repObj.standing    = Locales["FRIENDLY"]   or "Friendly"
    repObj.color       = repColor

    if repObj.centerText then
        repObj.centerText:SetText(Locales["REP_BAR_DATA"])
    end
end

-- Backward-compat shims: allow core and config panel to call the old method names
function core:getFactionData(factionId)
    local mod = self:GetModule("Reputation", true)
    if mod then return mod:getFactionData(factionId) end
    return nil
end

function core:renderReputation()
    local mod = self:GetModule("Reputation", true)
    if mod then mod:renderLive() end
end

function core:configReputation(profile, bars, textColor)
    local mod = self:GetModule("Reputation", true)
    if mod then mod:renderConfig() end
end