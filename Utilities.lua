-------------------------------------------------------------------------------
-- Project: AscensionBars
-- Author: Aka-DoctorCode
-- File: Utilities.lua
-- Version: @project-version@
-------------------------------------------------------------------------------
-- Copyright (c) 2025–2026 Aka-DoctorCode. All Rights Reserved.
--
-- This software and its source code are the exclusive property of the author.
-- No part of this file may be copied, modified, redistributed, or used in
-- derivative works without express written permission.
-------------------------------------------------------------------------------

---@type AscensionBars
local AB = LibStub("AceAddon-3.0"):GetAddon("AscensionBars")
local L = LibStub("AceLocale-3.0"):GetLocale("AscensionBars")

-------------------------------------------------------------------------------
-- Player Information
-------------------------------------------------------------------------------
function AB:GetPlayerMaxLevel()
    if GetMaxLevelForLatestExpansion then
        local maxLevel = GetMaxLevelForLatestExpansion()
        if maxLevel then
            return maxLevel
        end
    end
    return 80
end

-------------------------------------------------------------------------------
-- Class Color Retrieval
-------------------------------------------------------------------------------
function AB:GetClassColor()
    if not self.state then
        return { r = 1, g = 1, b = 1, a = 1 } -- #FFFFFF
    end
    if not self.state.cachedClassColor then
        local _, classFilename = UnitClass("player")
        if classFilename then
            local classColor = C_ClassColor.GetClassColor(classFilename)
            if classColor then
                self.state.cachedClassColor = classColor
                return self.state.cachedClassColor
            end
        end
        self.state.cachedClassColor = { r = 1, g = 1, b = 1, a = 1 } -- #FFFFFF
    end
    return self.state.cachedClassColor
end

function AB:ScanParagonRewards()
    if not self.state then
        self.state = { cachedPendingParagons = {} }
    end
    local pending = {}
    if C_Reputation then
        local numFactions = C_Reputation.GetNumFactions()
        if numFactions and numFactions > 0 then
            for i = 1, numFactions do
                local d = C_Reputation.GetFactionDataByIndex(i)
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

-------------------------------------------------------------------------------
-- Frame Management
-------------------------------------------------------------------------------
function AB:HideBlizzardFrames()
    local framesToHide = {
        StatusTrackingBarManager,
        UIWidgetPowerBarContainerFrame
    }
    for _, frame in pairs(framesToHide) do
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
    if r and r > 0 and profile.showRestedBar then
        txt = txt .. string.format(L["RESTED_TEXT"], (m > 0 and r / m * 100) or 0)
    end
    return txt
end
