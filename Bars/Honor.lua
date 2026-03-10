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

local addonName, addonTable = ...
local ascensionBars = addonTable.main or LibStub("AceAddon-3.0"):GetAddon(addonName)
local Locales = LibStub("AceLocale-3.0"):GetLocale("AscensionBars")

--- Renders the Honor bar using standard unit APIs
function ascensionBars:renderHonor()
    if not self.db or not self.db.profile then return end
    
    local profile = self.db.profile
    local bars = profile.bars
    local honorObj = self.honor

    if honorObj and bars and bars["Honor"] and bars["Honor"].enabled then
        self:updateStandardBar(honorObj, "Honor",
            -- Current Honor Function
            function() return UnitHonor("player") or 0 end,
            -- Max Honor Function
            function() return UnitHonorMax("player") or 100 end,
            -- Color Function
            function() 
                return profile.honorColor or { r = 0.8, g = 0.2, b = 0.2, a = 1.0 } -- #CC3333
            end,
            -- Text Format Function
            function(current, max, percentage)
                local honorLevel = UnitHonorLevel("player") or 0
                
                -- Use localized string and BreakUpLargeNumbers for consistency
                return string.format(Locales["HONOR_LEVEL_FORMAT"], 
                    honorLevel, 
                    BreakUpLargeNumbers(current), 
                    BreakUpLargeNumbers(max), 
                    percentage
                )
            end
        )
    elseif honorObj then
        if honorObj.bar then honorObj.bar:Hide() end
        if honorObj.txFrame then honorObj.txFrame:Hide() end
    end
end

--- Displays the Honor bar in a dummy state for configuration
-- @param profile table The active DB profile
-- @param bars table The bars configuration sub-table
-- @param textColor table The RGB table for text
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
        
        if honorObj.text then
            honorObj.text:SetText(Locales["HONOR_BAR_DATA"])
            honorObj.text:SetTextColor(textColor.r or 1, textColor.g or 1, textColor.b or 1, 1)
        end
    else
        if honorObj.bar then honorObj.bar:Hide() end
        if honorObj.txFrame then honorObj.txFrame:Hide() end
    end
end