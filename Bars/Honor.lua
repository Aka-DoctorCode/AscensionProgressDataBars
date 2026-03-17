-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
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

local addonName, addonTable = ...
---@type AscensionBars
local ascensionBars = addonTable.main or LibStub("AceAddon-3.0"):GetAddon(addonName)
---@cast ascensionBars AscensionBars
local Locales = LibStub("AceLocale-3.0"):GetLocale("AscensionBars")
local dataText = addonTable.dataText

--- Renders the Honor bar using standard unit APIs
---@self AscensionBars
function ascensionBars:renderHonor()
    if not self.db or not self.db.profile then return end
    
    local profile = self.db.profile
    local bars = profile.bars
    local honorObj = self.honor

    if honorObj and bars and bars["Honor"] and bars["Honor"].enabled then
        self:updateStandardBar(honorObj, "Honor",
            function() return UnitHonor("player") or 0 end,
            function() return UnitHonorMax("player") or 100 end,
            function() 
                return profile.honorColor or { r = 0.8, g = 0.2, b = 0.2, a = 1.0 } -- #CC3333
            end,
            function(current, max, percentage)
                if not dataText then return { identity="", details="", percentage="" } end
                return dataText:formatHonor(current, max, percentage)
            end
        )
        -- Store additional legend info
        honorObj.displayName = string.format(Locales["LEVEL_TEXT"] or "Level %d", UnitHonorLevel("player") or 0)

    elseif honorObj then
        if honorObj.bar then honorObj.bar:Hide() end
        if honorObj.txFrame then honorObj.txFrame:Hide() end
    end
end

--- Displays the Honor bar in a dummy state for configuration
-- @param profile table The active DB profile
-- @param bars table The bars configuration sub-table
-- @param textColor table The RGB table for text
---@self AscensionBars
function ascensionBars:configHonor(profile, bars, textColor)
    local honorObj = self.honor
    if not honorObj then return end
    
    local honorConfig = bars["Honor"]
    if honorConfig and honorConfig.enabled then
        if honorObj.bar then honorObj.bar:Show() end
        if honorObj.txFrame then honorObj.txFrame:Show() end
        
        -- Default Honor Red: #CC3333
        local honorColor = profile.honorColor or { r = 0.8, g = 0.2, b = 0.2, a = 1.0 }
        self:setupBar(honorObj, 0, 100, 30, honorColor)
        
        -- Store config preview values for legend
        honorObj.current = 1500
        honorObj.max = 3000
        honorObj.percentage = 50
        honorObj.displayName = string.format(Locales["LEVEL_TEXT"] or "Level %d", 45)
        honorObj.color = honorColor
        
        if honorObj.centerText then
            honorObj.centerText:SetText(Locales["HONOR_BAR_DATA"])
        end
    else
        if honorObj.bar then honorObj.bar:Hide() end
        if honorObj.txFrame then honorObj.txFrame:Hide() end
    end
end