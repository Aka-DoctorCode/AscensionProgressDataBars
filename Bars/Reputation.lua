-------------------------------------------------------------------------------
-- Project: AscensionBars
-- Author: Aka-DoctorCode
-- File: Reputation.lua
-- Version: @project-version@
-------------------------------------------------------------------------------
-- Copyright (c) 2025–2026 Aka-DoctorCode. All Rights Reserved.
--
-- This software and its source code are the exclusive property of the author.
-- No part of this file may be copied, modified, redistributed, or used in
-- derivative works without express written permission.
-------------------------------------------------------------------------------

local addonName, addonTable = ...
local ascensionBars = addonTable.main or LibStub("AceAddon-3.0"):GetAddon(addonName)
local Locales = LibStub("AceLocale-3.0"):GetLocale("AscensionBars")

--- Normalizes faction data from various Blizzard APIs
-- @param factionId number The faction ID to query
-- @return table|nil Normalized data table
function ascensionBars:getFactionData(factionId)
    if not factionId then return nil end

    local data = {
        id = factionId,
        currentValue = 0,
        maxValue = 1,
        levelName = "",
        isMaxLevel = false,
        hasParagon = C_Reputation.IsFactionParagon(factionId),
        type = "STANDARD",
        reaction = 0
    }

    -- 1. Major Faction (Renown)
    if C_Reputation.IsMajorFaction(factionId) then
        local majorData = C_MajorFactions.GetMajorFactionData(factionId)
        if majorData then
            data.type = "RENOWN"
            data.reaction = 11 -- Royal Blue: #4169E1
            -- Updated fields for Retail 11.0+
            data.currentValue = majorData.renownReputationEarned or 0
            data.maxValue = majorData.renownLevelThreshold or 2500
            data.isMaxLevel = (majorData.renownLevel >= majorData.maxLevel)
            data.levelName = string.format("%s %d", Locales["RENOWN_LEVEL"], majorData.renownLevel)

            -- Force full bar and Exalted color (10) if max level and no paragon
            if data.isMaxLevel and not data.hasParagon then
                data.currentValue, data.maxValue = 1, 1
                data.reaction = 10 -- Purple/Exalted: #A335EE
            end
        end
    -- 2. Friendship Factions
    elseif C_GossipInfo.GetFriendshipReputation(factionId) and C_GossipInfo.GetFriendshipReputation(factionId).friendshipFactionID > 0 then
        local friendData = C_GossipInfo.GetFriendshipReputation(factionId)
        data.type = "FRIENDSHIP"
        data.reaction = 5 -- Green: #00FF00
        data.levelName = friendData.reaction or ""
        data.currentValue = (friendData.standing or 0) - (friendData.reactionThreshold or 0)
        data.maxValue = (friendData.nextThreshold) and (friendData.nextThreshold - friendData.reactionThreshold) or 1
        data.isMaxLevel = (friendData.nextThreshold == nil)

        -- Force full bar and Exalted color (10) if max level and no paragon
        if data.isMaxLevel and not data.hasParagon then
            data.currentValue, data.maxValue = 1, 1
            data.reaction = 10 -- Purple/Exalted: #A335EE
        end
    -- 3. Standard Reputation
    else
        local factionData = C_Reputation.GetFactionDataByID(factionId)
        if factionData then
            local reactionIndex = factionData.reaction or 0
            data.reaction = reactionIndex
            data.levelName = GetText("FACTION_STANDING_LABEL" .. reactionIndex, UnitSex("player"))
            data.currentValue = factionData.currentStanding - factionData.currentReactionThreshold
            data.maxValue = factionData.nextReactionThreshold - factionData.currentReactionThreshold
            data.isMaxLevel = (reactionIndex == 8)

            -- Force full bar and Exalted color (10) if Exalted and no paragon
            if data.isMaxLevel and not data.hasParagon then
                data.currentValue, data.maxValue = 1, 1
                data.reaction = 10 -- Purple/Exalted: #A335EE
            end
        end
    end

    -- 4. Paragon Override
    -- Only apply paragon logic if the faction is actually at max level
    if data.hasParagon and data.isMaxLevel then
        local currentValue, threshold = C_Reputation.GetFactionParagonInfo(factionId)
        if currentValue then
            data.currentValue = currentValue % threshold
            data.maxValue = threshold
            data.levelName = Locales["PARAGON"]
            data.reaction = 9 -- Goldenrod: #DAA520
            data.isMaxLevel = false 
        end
    end

    return data
end


--- Scans for paragon rewards and updates character cache
function ascensionBars:scanParagonRewards()
    if not self.db or not self.db.global then return end
    
    local characterKey = UnitName("player") .. "-" .. GetRealmName()
    self.db.global.paragonRewards = self.db.global.paragonRewards or {}
    
    local currentRewards = {}
    local foundAny = false
    local numFactions = C_Reputation.GetNumFactions()

    for i = 1, numFactions do
        local factionData = C_Reputation.GetFactionDataByIndex(i)
        if factionData and factionData.factionID then
            if C_Reputation.IsFactionParagon(factionData.factionID) then
                local _, _, _, hasReward = C_Reputation.GetFactionParagonInfo(factionData.factionID)
                if hasReward then
                    currentRewards[factionData.factionID] = factionData.name
                    foundAny = true
                end
            end
        end
    end

    if foundAny then
        self.db.global.paragonRewards[characterKey] = currentRewards
    else
        self.db.global.paragonRewards[characterKey] = nil
    end
end

--- Renders the Reputation bar and Paragon alerts
function ascensionBars:renderReputation()
    if not self.db or not self.db.profile then return end
    local profile = self.db.profile
    
    local repConfig = profile.bars and profile.bars["Rep"]
    if not repConfig or not repConfig.enabled then
        if self.rep then
            self.rep.bar:Hide()
            self.rep.txFrame:Hide()
        end
        return
    end

    local name, reaction, curVal, maxVal, standingLabel
    local isMaxLevel, hasParagon = false, false
    local characterKey = UnitName("player") .. "-" .. GetRealmName()
    
    -- Check for rewards
    local currentPending = {}
    if self.db.global.paragonRewards and self.db.global.paragonRewards[characterKey] then
        for fId, fName in pairs(self.db.global.paragonRewards[characterKey]) do
            table.insert(currentPending, { id = fId, name = fName })
        end
    end

    local otherCharWithReward = nil
    if #currentPending == 0 and self.db.global.paragonRewards then
        for charKey, rewards in pairs(self.db.global.paragonRewards) do
            if charKey ~= characterKey and next(rewards) then
                otherCharWithReward = string.match(charKey, "(.+)-") or charKey
                break
            end
        end
    end

    -- Paragon Alert Rendering
    if (#currentPending > 0 or otherCharWithReward) and self.paragonText then
        local pColor = profile.paragonPendingColor or { r = 0, g = 1, b = 0, a = 1 } -- #00FF00
        local hex = string.format("|cff%02x%02x%02x",
            math.floor(pColor.r * 255), math.floor(pColor.g * 255), math.floor(pColor.b * 255))
        
        local alertText = ""
        if #currentPending > 0 then
            local names = {}
            for _, info in ipairs(currentPending) do table.insert(names, string.upper(info.name)) end
            local factionStr = names[1]
            if #names > 1 then
                local last = table.remove(names)
                factionStr = table.concat(names, ", ") .. Locales["AND"] .. last
            end
            
            local suffix = (#currentPending > 1) and Locales["REWARD_PENDING_PLURAL"] or Locales["REWARD_PENDING_SINGLE"]
            alertText = hex .. factionStr .. suffix .. "|r"
            
            -- Set bar data to reward status
            name, reaction, curVal, maxVal = currentPending[1].name, 9, 1, 1
            standingLabel, isMaxLevel, hasParagon = Locales["REWARD_PENDING_STATUS"], false, true
        else
            local charName = string.upper(otherCharWithReward)
            alertText = hex .. string.format(Locales["REWARD_ON_CHAR"], charName) .. "|r"
        end
        
        self.paragonText:SetFont(self.fontToUse, profile.paragonTextSize or 18, "THICKOUTLINE")
        self.paragonText:SetText(alertText)
        self.paragonText:ClearAllPoints()
        
        local pY = profile.paragonTextYOffset or -100
        if profile.paragonOnTop then
            self.paragonText:SetPoint("TOP", UIParent, "TOP", 0, pY)
        else
            if profile.barAnchor == "BOTTOM" then
                self.paragonText:SetPoint("BOTTOM", self.textHolder, "TOP", 0, -pY)
            else
                self.paragonText:SetPoint("TOP", self.textHolder, "BOTTOM", 0, pY)
            end
        end
        self.paragonText:Show()
    elseif self.paragonText then
        self.paragonText:Hide()
    end

    -- Get Watched Faction if no reward alert is active
    if not name then
        local watchedData = C_Reputation.GetWatchedFactionData()
        if watchedData then
            local normalized = self:getFactionData(watchedData.factionID)
            if normalized then
                name = watchedData.name
                reaction = normalized.reaction
                curVal = normalized.currentValue
                maxVal = normalized.maxValue
                standingLabel = normalized.levelName
                isMaxLevel = normalized.isMaxLevel
                hasParagon = normalized.hasParagon
            end
        end
    end

    -- Final Bar Setup
    if name and self.rep then
        self.rep.bar:Show()
        self.rep.txFrame:Show()
        
        local cur = math.max(0, curVal)
        local max = math.max(1, maxVal)
        if cur > max then cur = max end
        local percentage = (cur / max) * 100

        local useReaction = profile.useReactionColorRep
        local repColors = profile.repColors
        local rBarColor = profile.repBarColor or { r = 0, g = 1, b = 0, a = 1 } -- #00FF00
        local color = (useReaction and repColors and repColors[reaction]) or rBarColor
        
        self:setupBar(self.rep, 0, max, cur, color)
        
        local labelPart = string.format(Locales["REP_LABEL_FORMAT"], name, standingLabel)
        local valuePart = ""

        if isMaxLevel and not hasParagon then
            valuePart = string.format(Locales["REP_VALUE_FORMAT_PCT"], 100.0)
        else
            valuePart = string.format(Locales["REP_VALUE_FORMAT_FULL"], 
                BreakUpLargeNumbers(cur), 
                BreakUpLargeNumbers(max), 
                percentage
            )
        end

        self.rep.text:SetText(labelPart .. " | " .. valuePart)
        local textColor = profile.textColor
        if textColor then
            self.rep.text:SetTextColor(textColor.r or 1, textColor.g or 1, textColor.b or 1, 1)
        end
    elseif self.rep then
        self.rep.bar:Hide()
        self.rep.txFrame:Hide()
    end
end

--- Configuration mode for Reputation
function ascensionBars:configReputation(profile, bars, textColor)
    if not self.rep then return end
    
    self.rep.bar:Show()
    self.rep.txFrame:Show()
    
    -- #00FF00
    local repColor = profile.repBarColor or { r = 0, g = 1, b = 0, a = 1 }
    self:setupBar(self.rep, 0, 100, 50, repColor)
    
    self.rep.text:SetText(Locales["REP_BAR_DATA"])
    self.rep.text:SetTextColor(textColor.r or 1, textColor.g or 1, textColor.b or 1, 1)

    if self.paragonText then
        local pColor = profile.paragonPendingColor or { r = 0, g = 1, b = 0, a = 1 }
        local hex = string.format("|cff%02x%02x%02x",
            math.floor(pColor.r * 255),
            math.floor(pColor.g * 255),
            math.floor(pColor.b * 255)
        )
        self.paragonText:SetFont(self.fontToUse, profile.paragonTextSize or 18, "THICKOUTLINE")
        
        if profile.splitParagonText then
            self.paragonText:SetText(hex .. Locales["CONFIG_FACTION_A_REWARD"] .. "|r\n" .. hex .. Locales["CONFIG_FACTION_B_REWARD"] .. "|r")
        else
            self.paragonText:SetText(hex .. Locales["CONFIG_MULTIPLE_REWARDS"] .. "|r")
        end
        
        self.paragonText:Show()
        self.paragonText:ClearAllPoints()
        local pY = profile.paragonTextYOffset or -100
        
        if profile.paragonOnTop then
            self.paragonText:SetPoint("TOP", UIParent, "TOP", 0, pY)
        else
            if profile.barAnchor == "BOTTOM" then
                self.paragonText:SetPoint("BOTTOM", self.textHolder, "TOP", 0, -pY)
            else
                self.paragonText:SetPoint("TOP", self.textHolder, "BOTTOM", 0, pY)
            end
        end
    end
end