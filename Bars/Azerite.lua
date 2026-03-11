-------------------------------------------------------------------------------
-- Project: AscensionBars
-- Author: Aka-DoctorCode
-- File: Azerite.lua
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

--- Renders the Azerite Power bar based on current item progression
--- Renders the Azerite Power bar based on current item progression
function ascensionBars:renderAzerite()
    if not self.db or not self.db.profile then return end
    
    local profile = self.db.profile
    local bars = profile.bars

    if self.azerite and bars and bars["Azerite"] and bars["Azerite"].enabled then
        self:updateStandardBar(self.azerite, "Azerite",
            -- Current XP Function
            function()
                if C_AzeriteItem and C_AzeriteItem.FindActiveAzeriteItem then
                    local itemLoc = C_AzeriteItem.FindActiveAzeriteItem()
                    if itemLoc and C_AzeriteItem.GetAzeriteItemXPInfo then
                        local xp, _ = C_AzeriteItem.GetAzeriteItemXPInfo(itemLoc)
                        return xp or 0
                    end
                end
                return 0
            end,
            -- Max XP Function
            function()
                if C_AzeriteItem and C_AzeriteItem.FindActiveAzeriteItem then
                    local itemLoc = C_AzeriteItem.FindActiveAzeriteItem()
                    if itemLoc and C_AzeriteItem.GetAzeriteItemXPInfo then
                        local _, total = C_AzeriteItem.GetAzeriteItemXPInfo(itemLoc)
                        return total or 100
                    end
                end
                return 100
            end,
            -- Color Function
            function() 
                return profile.azeriteColor or { r = 0.9, g = 0.8, b = 0.5, a = 1.0 } -- #E5CC7F
            end,
            -- Text Format Function
            function(current, max, percentage)
                local azeriteLevel = 0
                if C_AzeriteItem and C_AzeriteItem.FindActiveAzeriteItem then
                    local itemLoc = C_AzeriteItem.FindActiveAzeriteItem()
                    if itemLoc and C_AzeriteItem.GetPowerLevel then
                        azeriteLevel = C_AzeriteItem.GetPowerLevel(itemLoc) or 0
                    end
                end
                
                -- Dynamic visibility logic
                local showAbs = profile.showAbsoluteValues
                local showPct = profile.showPercentage
                local text = string.format(Locales["AZERITE"] .. " " .. Locales["RANK_NUM"], azeriteLevel)

                if showAbs and showPct then
                    text = string.format(Locales["AZERITE_LEVEL_FORMAT"], azeriteLevel, BreakUpLargeNumbers(current), BreakUpLargeNumbers(max), percentage)
                elseif showAbs then
                    text = string.format("%s | %s / %s", text, BreakUpLargeNumbers(current), BreakUpLargeNumbers(max))
                elseif showPct then
                    text = string.format("%s | %.1f%%", text, percentage)
                end

                return text
            end
        )
    elseif self.azerite then
        self.azerite.bar:Hide()
        self.azerite.txFrame:Hide()
    end
end

--- Displays the Azerite bar in a dummy state for configuration
-- @param profile table The active DB profile
-- @param bars table The bars configuration sub-table
-- @param textColor table The RGB table for text
function ascensionBars:configAzerite(profile, bars, textColor)
    local azeriteConfig = bars["Azerite"]
    if self.azerite and azeriteConfig and azeriteConfig.enabled then
        self.azerite.bar:Show()
        self.azerite.txFrame:Show()
        
        local azeriteColor = profile.azeriteColor or { r = 0.9, g = 0.8, b = 0.5, a = 1.0 } -- #E5CC7F
        self:setupBar(self.azerite, 0, 100, 80, azeriteColor)
        
        self.azerite.text:SetText(Locales["AZERITE_BAR_DATA"])
        self.azerite.text:SetTextColor(textColor.r or 1, textColor.g or 1, textColor.b or 1, 1)
    elseif self.azerite then
        self.azerite.bar:Hide()
        self.azerite.txFrame:Hide()
    end
end