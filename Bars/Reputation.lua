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

local addonName, _ = ...
local ascensionBars = LibStub("AceAddon-3.0"):GetAddon(addonName)
local Locales = LibStub("AceLocale-3.0"):GetLocale("AscensionBars")

-- Helper to normalize faction data from Blizzard API
function ascensionBars:getFactionData(factionID)
    if not factionID then return nil end

    local data = {
        id = factionID,
        currentValue = 0,
        maxValue = 1,
        levelName = "",
        isMaxLevel = false,
        reaction = 0,
        type = "STANDARD"
    }

    -- 1. Check for Major Faction (Renown)
    if C_Reputation.IsMajorFaction(factionID) then
        local majorData = C_MajorFactions.GetMajorFactionData(factionID)
        if majorData then
            data.type = "RENOWN"
            data.reaction = 11 -- #4169E1
            data.currentValue = majorData.renownReputationEarned or 0
            data.maxValue = majorData.renownLevelThreshold or 2500
            data.levelName = string.format(Locales["RENOWN_LEVEL"], majorData.renownLevel)
            data.isMaxLevel = C_MajorFactions.HasMaximumRenown(factionID)
        end

    -- 2. Check for Friendship (Gossip API)
    elseif C_GossipInfo.GetFriendshipReputation(factionID) then
        local friendData = C_GossipInfo.GetFriendshipReputation(factionID)
        ---@cast friendData any
        ---@cast friendData AB_FriendshipData

        if friendData and friendData.friendshipFactionID > 0 then
            data.type = "FRIENDSHIP"
            data.reaction = 5 -- #FFFF00
            data.currentValue = friendData.standing or 0
            data.maxValue = friendData.maxStanding or 1
            data.levelName = friendData.reaction
            data.isMaxLevel = (friendData.nextThreshold == nil)
        end

    -- 3. Standard Reputation
    else
        local repData = C_Reputation.GetFactionDataByID(factionID)
        if repData then
            data.reaction = repData.reaction
            data.currentValue = repData.currentStanding
            data.maxValue = repData.nextReactionThreshold
            data.levelName = _G["FACTION_STANDING_LABEL" .. repData.reaction] or Locales["UNKNOWN_STANDING"]
            data.isMaxLevel = (repData.reaction == 8)
        end
    end

    -- 4. Check for Paragon override
    if C_Reputation.IsFactionParagon(factionID) then
        local currentValue, threshold = C_Reputation.GetFactionParagonInfo(factionID)
        if currentValue then
            data.currentValue = currentValue % threshold
            data.maxValue = threshold
            data.levelName = Locales["PARAGON"]
            data.reaction = 9 -- #DAA520
            data.isMaxLevel = false
        end
    end

    return data
end

---Scans for paragon rewards and updates the global cache
function ascensionBars:scanParagonRewards()
    local characterKey = UnitName("player") .. "-" .. GetRealmName()
    
    -- Ensure global table exists
    self.db.global.paragonRewards = self.db.global.paragonRewards or {}
    
    -- Reset current character's entry to ensure data freshness
    self.db.global.paragonRewards[characterKey] = nil

    -- Use C_Reputation.GetNumFactions() or the new iteration method
    local numFactions = C_Reputation.GetNumFactions()
    for i = 1, numFactions do
        local factionData = C_Reputation.GetFactionDataByIndex(i)
        if factionData and factionData.factionID then
            local factionID = factionData.factionID
            if C_Reputation.IsFactionParagon(factionID) then
                local _, _, _, hasReward = C_Reputation.GetFactionParagonInfo(factionID)
                if hasReward then
                    -- Initialize sub-table if needed
                    self.db.global.paragonRewards[characterKey] = self.db.global.paragonRewards[characterKey] or {}
                    -- Store faction name for tooltips or detail (optional)
                    self.db.global.paragonRewards[characterKey][factionID] = factionData.name
                end
            end
        end
    end
end

---Generates the display text for paragon rewards
---@return string
function ascensionBars:getParagonNotifyText()
    local characterKey = UnitName("player") .. "-" .. GetRealmName()
    local Locales = LibStub("AceLocale-3.0"):GetLocale("AscensionBars")
    
    -- Check if current character has rewards first
    if self.db.global.paragonRewards[characterKey] then
        return Locales["REWARD_AVAILABLE"] or "Reward available to be collected"
    end
    
    -- Check if any other character has rewards
    for charKey, factions in pairs(self.db.global.paragonRewards) do
        if charKey ~= characterKey and next(factions) then
            -- Extract name from "Name-Realm"
            local name = string.match(charKey, "(.+)-") or charKey
            return string.format(Locales["REWARD_ON_CHAR"] or "Reward available on %s", name)
        end
    end
    
    return ""
end

function ascensionBars:renderReputation()
    local db = self.db
    if not db then return nil end
    local profile = db.profile
    if not profile then return nil end
    
    -- Check if Bar is enabled
    local repConfig = profile.bars and profile.bars["Rep"]
    if not repConfig or not repConfig.enabled then
        if self.rep then
            if self.rep.bar then self.rep.bar:Hide() end
            if self.rep.txFrame then self.rep.txFrame:Hide() end
        end
        return nil
    end

    local name, reaction, minVal, maxVal, value, standingLabel
    local state = self.state
    local pending = state and state.cachedPendingParagons

    -- Priority: Paragon Rewards Pending
    if pending and #pending > 0 then
        local paragonColor = profile.paragonPendingColor or { r = 0, g = 1, b = 0 } -- #00FF00
        local hex = string.format("|cff%02x%02x%02x",
            math.floor((paragonColor.r or 0) * 255),
            math.floor((paragonColor.g or 1) * 255),
            math.floor((paragonColor.b or 0) * 255)
        )
        
        -- Generate pending rewards text
        local text = ""
        local names = {}
        for _, info in ipairs(pending) do
            table.insert(names, string.upper(info.name))
        end
        
        local factionStr = ""
        if #names == 1 then
            factionStr = names[1]
        else
            local last = table.remove(names)
            factionStr = table.concat(names, ", ") .. Locales["AND"] .. last
        end

        text = hex .. factionStr .. (#pending > 1 and Locales["REWARD_PENDING_PLURAL"] or Locales["REWARD_PENDING_SINGLE"]) .. "|r"
        
        local pSize = profile.paragonTextSize or 18
        self.paragonText:SetFont(self.fontToUse, pSize, "THICKOUTLINE")
        self.paragonText:SetText(text)
        self.paragonText:Show()
        
        name = pending[1].name
        reaction = 9
        minVal, maxVal, value = 0, 1, 1
        standingLabel = Locales["REWARD_PENDING_STATUS"]
    else
        if self.paragonText then self.paragonText:Hide() end
        local watchedData = C_Reputation.GetWatchedFactionData()
        if watchedData then
            local normalized = self:getFactionData(watchedData.factionID)
            if normalized then
                name = watchedData.name
                reaction = normalized.reaction
                minVal = (normalized.type == "STANDARD") and watchedData.currentReactionThreshold or 0
                maxVal = normalized.maxValue
                value = normalized.currentValue
                standingLabel = normalized.levelName
            end
        end
    end

    -- Render Bar if we have a name
    if name then
        self.rep.bar:Show()
        self.rep.txFrame:Show()
        
        local useReaction = profile.useReactionColorRep
        local repColors = profile.repColors
        local rBarColor = profile.repBarColor or { r = 0, g = 1, b = 0 } -- #00FF00
        local color = useReaction and repColors and repColors[reaction] or rBarColor
        
        self:setupBar(self.rep, minVal, maxVal, value, color)
        
        -- Text Display Logic
        local percentage = (maxVal > minVal) and ((value - minVal) / (maxVal - minVal) * 100) or 0
        local valueStr = BreakUpLargeNumbers(value - minVal)
        local maxStr = BreakUpLargeNumbers(maxVal - minVal)
        
        local textFormat = "%s (%s)"
        if profile.showAbsoluteValues and profile.showPercentage then
            textFormat = "%s (%s) %s/%s (%.1f%%)"
            self.rep.text:SetText(string.format(textFormat, name, standingLabel, valueStr, maxStr, percentage))
        elseif profile.showAbsoluteValues then
            textFormat = "%s (%s) %s/%s"
            self.rep.text:SetText(string.format(textFormat, name, standingLabel, valueStr, maxStr))
        elseif profile.showPercentage then
            textFormat = "%s (%s) %.1f%%"
            self.rep.text:SetText(string.format(textFormat, name, standingLabel, percentage))
        else
            self.rep.text:SetText(string.format(textFormat, name, standingLabel))
        end

        local textColor = profile.textColor or { r = 1, g = 1, b = 1, a = 1 } -- #FFFFFF
        self.rep.text:SetTextColor(textColor.r, textColor.g, textColor.b, textColor.a)
    else
        self.rep.bar:Hide()
        self.rep.txFrame:Hide()
    end
    
    return name
end

function ascensionBars:configReputation(profile, bars, textColor)
    self.rep.bar:Show()
    self.rep.txFrame:Show()
    local repColors = profile.repColors
    local repColor = profile.useReactionColorRep and repColors and repColors[9] or profile.repBarColor or
        { r = 0, g = 1, b = 0 } -- #00FF00
    self:setupBar(self.rep, 0, 100, 50, repColor)
    self.rep.text:SetText(Locales["REP_BAR_DATA"])
    self.rep.text:SetTextColor(textColor.r or 1, textColor.g or 1, textColor.b or 1, 1) -- #FFFFFF

    -- Paragon Config
    local paragonPendingColor = profile.paragonPendingColor
    if paragonPendingColor then
        local hex = string.format("|cff%02x%02x%02x",
            math.floor((paragonPendingColor.r or 0) * 255),
            math.floor((paragonPendingColor.g or 1) * 255),
            math.floor((paragonPendingColor.b or 0) * 255)
        )
        local pSize = profile.paragonTextSize or 18
        self.paragonText:SetFont(self.fontToUse, pSize, "THICKOUTLINE")
        local split = profile.splitParagonText
        if split then
            self.paragonText:SetText(hex .. (Locales["CONFIG_FACTION_A_REWARD"] or "Faction A") ..
                "|r\n" .. hex .. (Locales["CONFIG_FACTION_B_REWARD"] or "Faction B") .. "|r")
        else
            self.paragonText:SetText(hex .. (Locales["CONFIG_MULTIPLE_REWARDS"] or "Multiple Rewards Pending") .. "|r")
        end
    end
    self.paragonText:Show()
    self.paragonText:ClearAllPoints()
    local pY = profile.paragonTextYOffset or -100
    if profile.paragonOnTop then
        self.paragonText:SetPoint("TOP", UIParent, "TOP", 0, pY)
    else
        local barAnchor = profile.barAnchor
        if barAnchor == "BOTTOM" then
            self.paragonText:SetPoint("BOTTOM", self.textHolder, "TOP", 0, -(pY))
        else
            self.paragonText:SetPoint("TOP", self.textHolder, "BOTTOM", 0, pY)
        end
    end
end