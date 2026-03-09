-------------------------------------------------------------------------------
-- Project: AscensionBars
-- Author: Aka-DoctorCode
-- File: Honor.lua
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

function ascensionBars:renderHonor()
    local profile = self.db and self.db.profile
    if not profile then return end
    local bars = profile.bars

    local honorObj = self.honor
    if honorObj and bars and bars["Honor"] and bars["Honor"].enabled then
        self:updateStandardBar(honorObj, "Honor",
            function() return _G.UnitHonor("player") or 0 end,
            function() return _G.UnitHonorMax("player") or 100 end,
            function() return profile.honorColor or { r = 0.8, g = 0.2, b = 0.2, a = 1.0 } end,
            function(current, max, percentage)
                local honorLevel = _G.UnitHonorLevel("player") or 0
                return string.format("Honor Level %d | %d/%d (%.1f%%)", honorLevel, current, max, percentage)
            end
        )
    elseif honorObj then
        if honorObj.bar then honorObj.bar:Hide() end
        if honorObj.txFrame then honorObj.txFrame:Hide() end
    end
end

function ascensionBars:configHonor(profile, bars, textColor)
    local honorConfig = bars["Honor"]
    if self.honor and honorConfig and honorConfig.enabled then
        self.honor.bar:Show()
        self.honor.txFrame:Show()
        local honorColor = profile.honorColor or { r = 0.8, g = 0.2, b = 0.2, a = 1.0 }
        self:setupBar(self.honor, 0, 100, 30, honorColor)
        self.honor.text:SetText(Locales["HONOR_BAR_DATA"])
        self.honor.text:SetTextColor(textColor.r or 1, textColor.g or 1, textColor.b or 1, 1)
    elseif self.honor then
        self.honor.bar:Hide()
        self.honor.txFrame:Hide()
    end
end
