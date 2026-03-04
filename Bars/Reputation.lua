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
local ascensionBars = LibStub("AceAddon-3.0"):GetAddon(addonName)
---@cast ascensionBars AscensionBars
local Locales = LibStub("AceLocale-3.0"):GetLocale("AscensionBars")

function ascensionBars:scanParagonRewards()
    if not self.state then self.state = { cachedPendingParagons = {} } end
    local pending = {}
    if C_Reputation then
        local numFactions = C_Reputation.GetNumFactions()
        if numFactions and numFactions > 0 then
            for i = 1, numFactions do
                local factionData = C_Reputation.GetFactionDataByIndex(i)
                if factionData and factionData.factionID and C_Reputation.IsFactionParagon(factionData.factionID) then
                    local _, _, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionData.factionID)
                    if hasRewardPending then
                        table.insert(pending, { name = factionData.name or Locales["UNKNOWN_FACTION"] })
                    end
                end
            end
        end
    end
    self.state.cachedPendingParagons = pending
    self:updateDisplay()
end

function ascensionBars:renderReputation()
    local db = self.db
    if not db then return nil end
    local profile = db.profile
    if not profile then return nil end
    local bars = profile.bars
    if not bars then return nil end
    local repConfig = bars["Rep"]
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

    if pending and #pending > 0 then
        local paragonColor = profile and profile.paragonPendingColor or { r = 0, g = 1, b = 0 }
        local hex = string.format("|cff%02x%02x%02x",
            math.floor((paragonColor.r or 0) * 255),
            math.floor((paragonColor.g or 1) * 255),
            math.floor((paragonColor.b or 0) * 255)
        )
        local text = ""
        local split = profile and profile.splitParagonText
        if split then
            local lines = {}
            for _, info in ipairs(pending) do
                table.insert(lines, hex .. string.upper(info.name) .. Locales["REWARD_PENDING_SINGLE"] .. "|r")
            end
            text = table.concat(lines, "\n")
        else
            local names = {}
            for _, info in ipairs(pending) do
                table.insert(names, string.upper(info.name))
            end
            local factionStr = ""
            if #names == 1 then
                factionStr = names[1]
            elseif #names == 2 then
                factionStr = names[1] .. Locales["AND"] .. names[2]
            else
                local last = table.remove(names)
                factionStr = table.concat(names, ", ") .. Locales["AND"] .. last
            end
            text = hex ..
                factionStr ..
                (#pending > 1 and Locales["REWARD_PENDING_PLURAL"] or Locales["REWARD_PENDING_SINGLE"]) .. "|r"
        end
        local paragonSize = profile and profile.paragonTextSize or 18
        self.paragonText:SetFont(self.fontToUse, paragonSize, "THICKOUTLINE")
        self.paragonText:SetText(text)
        self.paragonText:Show()
        self.paragonText:ClearAllPoints()
        local paragonOnTop = profile and profile.paragonOnTop
        local paragonY = profile and profile.paragonTextYOffset or -100
        if paragonOnTop then
            self.paragonText:SetPoint("TOP", UIParent, "TOP", 0, paragonY)
        else
            local barAnchor = profile and profile.barAnchor
            if barAnchor == "BOTTOM" then
                self.paragonText:SetPoint("BOTTOM", self.textHolder, "TOP", 0, -(paragonY))
            else
                self.paragonText:SetPoint("TOP", self.textHolder, "BOTTOM", 0, paragonY)
            end
        end
        name, reaction, minVal, maxVal, value, standingLabel = pending[1].name, 9, 0, 1, 1,
            Locales["REWARD_PENDING_STATUS"]
    else
        self.paragonText:Hide()
        local data = C_Reputation.GetWatchedFactionData()
        if data then
            name, reaction, minVal, maxVal, value = data.name, data.reaction, data.currentReactionThreshold,
                data.nextReactionThreshold, data.currentStanding
            if C_Reputation.IsFactionParagon(data.factionID) then
                local currentVal, threshold = C_Reputation.GetFactionParagonInfo(data.factionID)
                minVal, maxVal, value, standingLabel, reaction = 0, threshold, currentVal % threshold, Locales
                    ["PARAGON"], 9
            elseif C_Reputation.IsMajorFaction(data.factionID) then
                local majorData = C_MajorFactions.GetMajorFactionData(data.factionID)
                if majorData then
                    minVal, maxVal, value, standingLabel, reaction = 0, majorData.renownLevelThreshold,
                        majorData.renownReputationEarned,
                        string.format(Locales["RENOWN_LEVEL"], majorData.renownLevel), 11
                else
                    standingLabel = _G["FACTION_STANDING_LABEL" .. reaction] or Locales["UNKNOWN_STANDING"]
                end
            else
                standingLabel = _G["FACTION_STANDING_LABEL" .. reaction] or Locales["UNKNOWN_STANDING"]
            end
        end
    end

    if name then
        self.rep.bar:Show()
        self.rep.txFrame:Show()
        local useReaction = profile and profile.useReactionColorRep
        local repColors = profile and profile.repColors
        local rBarColor = profile and profile.repBarColor
        local color = useReaction and repColors and repColors[reaction] or rBarColor or { r = 0, g = 1, b = 0 }
        self:setupBar(self.rep, minVal, maxVal, value, color)

        local percentage = (maxVal > minVal) and ((value - minVal) / (maxVal - minVal) * 100) or 0
        local valueStr = BreakUpLargeNumbers(value - minVal)
        local maxStr = BreakUpLargeNumbers(maxVal - minVal)

        local showAbs = profile and profile.showAbsoluteValues
        local showPct = profile and profile.showPercentage
        if showAbs and showPct then
            self.rep.text:SetText(string.format("%s (%s) %s/%s (%.1f%%)", name, standingLabel, valueStr, maxStr,
                percentage))
        elseif showAbs then
            self.rep.text:SetText(string.format("%s (%s) %s/%s", name, standingLabel, valueStr, maxStr))
        elseif showPct then
            self.rep.text:SetText(string.format("%s (%s) %.1f%%", name, standingLabel, percentage))
        else
            self.rep.text:SetText(string.format("%s (%s)", name, standingLabel))
        end

        local textColor = profile and profile.textColor
        if textColor then
            self.rep.text:SetTextColor(textColor.r or 1, textColor.g or 1, textColor.b or 1, textColor.a or 1)
        end
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
        { r = 0, g = 1, b = 0 }
    self:setupBar(self.rep, 0, 100, 50, repColor)
    self.rep.text:SetText(Locales["REP_BAR_DATA"])
    self.rep.text:SetTextColor(textColor.r or 1, textColor.g or 1, textColor.b or 1, 1)

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
