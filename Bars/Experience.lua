-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
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
---@type AscensionBars
local ascensionBars = addonTable.main or LibStub("AceAddon-3.0"):GetAddon(addonName)
---@cast ascensionBars AscensionBars
local Locales = LibStub("AceLocale-3.0"):GetLocale("AscensionBars")
local dataText = addonTable.dataText



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

        -- Store values for legend
        xpObj.current = currentXP
        xpObj.max = maxXP
        xpObj.percentage = (currentXP / maxXP) * 100
        xpObj.displayName = string.format(Locales["LEVEL_TEXT"] or "Level %d", UnitLevel("player") or 0)
        xpObj.color = classColor
        xpObj.rested = GetXPExhaustion() or 0

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

        if dataText then
            local str = dataText:formatExperience()
            xpObj.centerText:SetText(str)
            xpObj.leftText:SetText("")
            xpObj.rightText:SetText("")
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

        -- Store config preview values for legend
        xpObj.current = 7500
        xpObj.max = 10000
        xpObj.percentage = 75
        xpObj.displayName = string.format(Locales["LEVEL_TEXT"] or "Level %d", 60)
        xpObj.color = classColor
        xpObj.rested = 2500

        if xpObj.centerText then
            xpObj.centerText:SetText(Locales["XP_BAR_CONFIG_TEXT"] or Locales["XP_BAR_DATA"])
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