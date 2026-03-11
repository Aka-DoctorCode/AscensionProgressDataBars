-------------------------------------------------------------------------------
-- Project: AscensionBars
-- Author: Aka-DoctorCode
-- File: Experience.lua
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

--- Renders the Experience bar and optional rested overlay
-- @param shouldHideXP boolean Whether the bar should be hidden (e.g., at max level)
function ascensionBars:renderExperience(shouldHideXP)
    if not self.db or not self.db.profile then return end
    
    local profile = self.db.profile
    local bars = profile.bars
    local xpObj = self.xp

    if xpObj and bars and bars["XP"] and bars["XP"].enabled and not shouldHideXP then
        local currentXP = UnitXP("player") or 0
        local maxXP = UnitXPMax("player") or 1
        
        -- Default XP Blue: #0066E6
        local xpColor = profile.xpBarColor or { r = 0, g = 0.4, b = 0.9, a = 1 }
        local classColor = profile.useClassColorXP and self:getClassColor() or xpColor
        
        self:setupBar(xpObj, 0, maxXP, currentXP, classColor)

        -- Handle Rested XP Overlay
        if profile.showRestedBar then
            local rested = GetXPExhaustion()
            local overlay = xpObj.restedOverlay
            local bar = xpObj.bar
            
            if rested and rested > 0 and overlay and bar then
                local barWidth = bar:GetWidth()
                local barHeight = bar:GetHeight()
                local restedWidth = barWidth * (math.min(currentXP + rested, maxXP) / maxXP)
                
                overlay:SetSize(restedWidth, barHeight)
                overlay:SetPoint("LEFT", bar, "LEFT")
                
                -- Default Rested Purple: #9966CC
                local rBarColor = profile.restedBarColor or { r = 0.6, g = 0.4, b = 0.8, a = 1 }
                overlay:SetColorTexture(rBarColor.r, rBarColor.g, rBarColor.b, rBarColor.a)
                overlay:Show()
            elseif overlay then
                overlay:Hide()
            end
        elseif xpObj.restedOverlay then
            xpObj.restedOverlay:Hide()
        end

        -- Update Text using the formatted string from main logic
        if xpObj.text then
            local rested = GetXPExhaustion() or 0
            xpObj.text:SetText(self:formatXP(rested) or "")
        end
        
        if xpObj.txFrame then
            xpObj.txFrame:Show()
        end
    elseif xpObj then
        if xpObj.bar then xpObj.bar:Hide() end
        if xpObj.txFrame then xpObj.txFrame:Hide() end
        if xpObj.restedOverlay then xpObj.restedOverlay:Hide() end
    end
end

--- Displays the Experience bar in a dummy state for configuration
-- @param profile table The active DB profile
-- @param bars table The bars configuration sub-table
-- @param textColor table The RGB table for text
function ascensionBars:configExperience(profile, bars, textColor)
    local xpObj = self.xp
    if not xpObj then return end
    
    local xpConfig = bars["XP"]
    if xpConfig and xpConfig.enabled then
        if xpObj.bar then xpObj.bar:Show() end
        if xpObj.txFrame then xpObj.txFrame:Show() end
        
        -- Default XP Blue: #0066E6
        local xpColor = profile.xpBarColor or { r = 0, g = 0.4, b = 0.9, a = 1 }
        local classColor = profile.useClassColorXP and self:getClassColor() or xpColor
        
        self:setupBar(xpObj, 0, 100, 75, classColor)

        if xpObj.text then
            xpObj.text:SetText(Locales["XP_BAR_CONFIG_TEXT"] or Locales["XP_BAR_DATA"])
            xpObj.text:SetTextColor(textColor.r or 1, textColor.g or 1, textColor.b or 1, 1)
        end

        -- Config Preview for Rested Bar
        if profile.showRestedBar then
            local bar = xpObj.bar
            local overlay = xpObj.restedOverlay
            if bar and overlay then
                local barWidth = bar:GetWidth() or 0
                overlay:SetSize(barWidth * 0.25, bar:GetHeight() or 6)
                overlay:ClearAllPoints()
                overlay:SetPoint("LEFT", bar, "LEFT", barWidth * 0.75, 0)
                
                -- Default Rested Purple: #9966CC
                local rBarColor = profile.restedBarColor or { r = 0.6, g = 0.4, b = 0.8, a = 1 }
                overlay:SetColorTexture(rBarColor.r, rBarColor.g, rBarColor.b, rBarColor.a)
                overlay:Show()
            end
        elseif xpObj.restedOverlay then
            xpObj.restedOverlay:Hide()
        end
    else
        if xpObj.bar then xpObj.bar:Hide() end
        if xpObj.txFrame then xpObj.txFrame:Hide() end
        if xpObj.restedOverlay then xpObj.restedOverlay:Hide() end
    end
end