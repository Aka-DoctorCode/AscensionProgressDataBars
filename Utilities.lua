-------------------------------------------------------------------------------
-- Project: AscensionBars
-- Author: Aka-DoctorCode 
-- File: Utilities.lua
-- Version: 12.0.0
-------------------------------------------------------------------------------
-- Copyright (c) 2025–2026 Aka-DoctorCode. All Rights Reserved.
--
-- This software and its source code are the exclusive property of the author.
-- No part of this file may be copied, modified, redistributed, or used in 
-- derivative works without express written permission.
-------------------------------------------------------------------------------
local AB = LibStub("AceAddon-3.0"):GetAddon("AscensionBars")
local L = LibStub("AceLocale-3.0"):GetLocale("AscensionBars")

function AB:GetClassColor()
    -- Safety check: Ensure state exists
    if not self.state then
        return { r = 1, g = 1, b = 1, a = 1 }
    end

    if not self.state.cachedClassColor then
        local _, classFilename = UnitClass("player")
        if classFilename and RAID_CLASS_COLORS[classFilename] then
            self.state.cachedClassColor = RAID_CLASS_COLORS[classFilename]
        else
            self.state.cachedClassColor = { r = 1, g = 1, b = 1, a = 1 }
        end
    end
    return self.state.cachedClassColor
end

function AB:ScanParagonRewards()
    -- Safety check: Ensure state exists before assignment
    if not self.state then
        self.state = { cachedPendingParagons = {} }
    end

    local pending = {}
    if C_Reputation then
        local numFactions = C_Reputation.GetNumFactions()
        if numFactions and numFactions > 0 then
            for i = 1, numFactions do
                local d = C_Reputation.GetFactionDataByIndex(i)
                -- Need nil check for 'd' and 'd.factionID'
                if d and d.factionID and C_Reputation.IsFactionParagon(d.factionID) then
                    local currentValue, threshold, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(d.factionID)
                    if hasRewardPending then
                        table.insert(pending, { name = d.name or L["UNKNOWN_FACTION"] })
                    end
                end
            end
        end
    end
    self.state.cachedPendingParagons = pending
    self:UpdateDisplay()
end

function AB:HideBlizzardFrames()
    local frames = {
        MainMenuExpBar,
        MainMenuBarMaxLevelBar,
        ReputationWatchBar,
        StatusTrackingBarManager,
        ExpBar,
        ReputationBar,
        HonorBar,
        ArtifactWatchBar,
        AzeriteBar
    }
    for _, frame in pairs(frames) do
        if frame then
            frame:UnregisterAllEvents()
            frame:Hide()
            frame:SetAlpha(0)
            frame.Show = function() end
        end
    end
end

function AB:FormatXP()
    local c, m = UnitXP("player"), UnitXPMax("player")
    local pct = (m > 0 and c / m * 100) or 0
    local profile = self.db.profile

    local txt = ""
    if profile.showAbsoluteValues then
        if profile.showPercentage then
            txt = string.format(L["LEVEL_TEXT_ABS_PCT"],
                UnitLevel("player"),
                BreakUpLargeNumbers(c),
                BreakUpLargeNumbers(m),
                pct)
        else
            txt = string.format(L["LEVEL_TEXT_ABS"],
                UnitLevel("player"),
                BreakUpLargeNumbers(c),
                BreakUpLargeNumbers(m))
        end
    elseif profile.showPercentage then
        txt = string.format(L["LEVEL_TEXT_PCT"], UnitLevel("player"), pct)
    else
        txt = string.format(L["LEVEL_TEXT"], UnitLevel("player"))
    end

    local r = GetXPExhaustion()
    if r and r > 0 then
        txt = txt .. string.format(L["RESTED_TEXT"], (m > 0 and r / m * 100) or 0)
    end
    return txt
end

function AB:AddTooltip(bar, text)
    if not bar or not text then return end

    bar:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
        GameTooltip:SetText(text)
        GameTooltip:Show()
    end)

    bar:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end

function AB:LoadPreset(presetName)
    local presets = {
        minimal = {
            barHeightXP = 3,
            barHeightRep = 3,
            textSize = 10,
            showOnMouseover = true,
            showRestedBar = false,
        },
        detailed = {
            barHeightXP = 8,
            barHeightRep = 8,
            textSize = 14,
            showRestedBar = true,
            showAbsoluteValues = true,
            showPercentage = true,
        },
        classic = {
            useClassColorXP = true,
            useReactionColorRep = true,
            barHeightXP = 5,
            barHeightRep = 5,
            textSize = 12,
        }
    }

    if presets[presetName] then
        for k, v in pairs(presets[presetName]) do
            self.db.profile[k] = v
        end
        self:UpdateDisplay()
    end
end
