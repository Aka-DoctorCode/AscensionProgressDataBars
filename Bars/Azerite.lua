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
local ascensionBars = LibStub("AceAddon-3.0"):GetAddon(addonName)
---@cast ascensionBars AscensionBars
local Locales = LibStub("AceLocale-3.0"):GetLocale("AscensionBars")

function ascensionBars:renderAzerite()
    local profile = self.db and self.db.profile
    if not profile then return end
    local bars = profile.bars

    if self.azerite and bars and bars["Azerite"] and bars["Azerite"].enabled then
        self:updateStandardBar(self.azerite, "Azerite",
            function()
                if C_AzeriteItem and C_AzeriteItem.FindActiveAzeriteItem then
                    local itemLoc = C_AzeriteItem.FindActiveAzeriteItem()
                    if itemLoc then
                        local xp, total = C_AzeriteItem.GetAzeriteItemXPInfo(itemLoc)
                        return xp or 0
                    end
                end
                return 0
            end,
            function()
                if C_AzeriteItem and C_AzeriteItem.FindActiveAzeriteItem then
                    local itemLoc = C_AzeriteItem.FindActiveAzeriteItem()
                    if itemLoc then
                        local xp, total = C_AzeriteItem.GetAzeriteItemXPInfo(itemLoc)
                        return total or 100
                    end
                end
                return 100
            end,
            function() return profile.azeriteColor or { r = 0.9, g = 0.8, b = 0.5, a = 1.0 } end,
            function(current, max, percentage)
                return string.format("Azerite Power %d/%d (%.1f%%)", current, max, percentage)
            end
        )
    elseif self.azerite then
        self.azerite.bar:Hide()
        self.azerite.txFrame:Hide()
    end
end

function ascensionBars:configAzerite(profile, bars, textColor)
    local azeriteConfig = bars["Azerite"]
    if self.azerite and azeriteConfig and azeriteConfig.enabled then
        self.azerite.bar:Show()
        self.azerite.txFrame:Show()
        local azeriteColor = profile.azeriteColor or { r = 0.9, g = 0.8, b = 0.5, a = 1.0 }
        self:setupBar(self.azerite, 0, 100, 80, azeriteColor)
        self.azerite.text:SetText(Locales["AZERITE_BAR_DATA"])
        self.azerite.text:SetTextColor(textColor.r or 1, textColor.g or 1, textColor.b or 1, 1)
    elseif self.azerite then
        self.azerite.bar:Hide()
        self.azerite.txFrame:Hide()
    end
end
