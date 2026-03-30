-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
-- Author: Aka-DoctorCode
-- File: Bars/Experience.lua
-- Version: @project-version@
-------------------------------------------------------------------------------
-- Copyright (c) 2025-2026 Aka-DoctorCode. All Rights Reserved.
--
-- This software and its source code are the exclusive property of the author.
-- No part of this file may be copied, modified, redistributed, or used in
-- derivative works without express written permission.
-------------------------------------------------------------------------------

local addonName, addonTable = ...
---@type AscensionBars
local core = addonTable.main or LibStub("AceAddon-3.0"):GetAddon(addonName)
---@cast core AscensionBars
local Locales = LibStub("AceLocale-3.0"):GetLocale("AscensionProgressDataBars")

-------------------------------------------------------------------------------
-- MODULE DEFINITION
-------------------------------------------------------------------------------

local ExperienceModule = core:NewModule("Experience", "AceEvent-3.0")

-- Keep a reference for the config functions that still live on core
-- (accessed via ExperienceModule.core to avoid global pollution)
ExperienceModule.core = core

-------------------------------------------------------------------------------
-- MODULE LIFECYCLE
-------------------------------------------------------------------------------

function ExperienceModule:OnEnable()
    self:RegisterEvent("PLAYER_XP_UPDATE",  "onXPUpdate")
    self:RegisterEvent("UPDATE_EXHAUSTION",  "onUpdate")
    self:RegisterEvent("PLAYER_LEVEL_UP",    "onUpdate")
end

function ExperienceModule:OnDisable()
    self:UnregisterAllEvents()
end

-------------------------------------------------------------------------------
-- EVENT HANDLERS
-------------------------------------------------------------------------------

function ExperienceModule:onXPUpdate()
    local state = self.core.state
    if not state then return end

    local currentXP = UnitXP("player")   or 0
    local currentMax = UnitXPMax("player") or 0
    local lastXP = state.lastXP

    if lastXP and lastXP > 0 and currentXP > lastXP then
        local gained = currentXP - lastXP
        if self.core.pushCarouselEvent then
            self.core:pushCarouselEvent("XP", "xp", "XP", gained)
        end
    end

    state.lastXP    = currentXP
    state.lastXPMax = currentMax
    self.core:updateDisplay()
end

function ExperienceModule:onUpdate()
    self.core:updateDisplay()
end

-------------------------------------------------------------------------------
-- RENDER DISPATCH  (called by core:updateDisplay via IterateModules)
-------------------------------------------------------------------------------

--- Unified render entry point — delegates to config or live render.
-- @param isConfig boolean True when the config panel is open.
-- @param shouldHideXP boolean True when the player is at max level and hiding is enabled.
function ExperienceModule:UpdateRender(isConfig, shouldHideXP)
    if isConfig then
        self:renderConfig()
    else
        self:renderLive(shouldHideXP)
    end
end

-------------------------------------------------------------------------------
-- LIVE RENDER
-------------------------------------------------------------------------------

function ExperienceModule:renderLive(shouldHideXP)
    local profile = self.core.db and self.core.db.profile
    if not profile then return end

    local bars  = profile.bars
    local xpObj = self.core.xp
    if not xpObj then return end

    if not bars or not bars["XP"] or not bars["XP"].enabled or shouldHideXP then
        if xpObj.bar        then xpObj.bar:Hide()         end
        if xpObj.txFrame    then xpObj.txFrame:Hide()     end
        if xpObj.restedOverlay then xpObj.restedOverlay:Hide() end
        return
    end

    local currentXP = UnitXP("player")   or 0
    local maxXP     = UnitXPMax("player") or 1

    -- Default XP Blue: #0066E6
    local xpColor   = profile.xpBarColor or { r = 0, g = 0.4, b = 0.9, a = 1 }
    local classColor = profile.useClassColorXP and self.core:getClassColor() or xpColor

    self.core:setupBar(xpObj, 0, maxXP, currentXP, classColor)

    xpObj.current     = currentXP
    xpObj.max         = maxXP
    xpObj.percentage  = (currentXP / maxXP) * 100
    xpObj.displayName = string.format(Locales["LEVEL_TEXT"] or "Level %d", UnitLevel("player") or 0)
    xpObj.color       = classColor
    xpObj.rested      = GetXPExhaustion() or 0

    self:applyRestedOverlay(xpObj, currentXP, maxXP, profile)

    local dataText = addonTable.dataText
    if dataText then
        if xpObj.centerText then xpObj.centerText:SetText(dataText:formatExperience()) end
        if xpObj.leftText   then xpObj.leftText:SetText("")   end
        if xpObj.rightText  then xpObj.rightText:SetText("")  end
    end

    if xpObj.txFrame then xpObj.txFrame:Show() end
end

--- Applies the rested XP overlay starting at the current XP fill end-point.
-- The overlay extends rightward and does NOT overlap the filled portion.
-- @param xpObj table The XP bar object.
-- @param currentXP number Current XP amount.
-- @param maxXP number Maximum XP for the level.
-- @param profile table Active DB profile.
function ExperienceModule:applyRestedOverlay(xpObj, currentXP, maxXP, profile)
    local overlay = xpObj.restedOverlay
    if not overlay then return end

    if not profile.showRestedBar then
        overlay:Hide()
        return
    end

    local rested = GetXPExhaustion()
    local bar    = xpObj.bar

    if rested and rested > 0 and bar then
        local barWidth  = bar:GetWidth()
        local barHeight = bar:GetHeight()

        -- Start at the XP fill edge, extend rightward by the rested portion
        local xpFillEnd   = barWidth * (currentXP / maxXP)
        local restedEnd   = barWidth * (math.min(currentXP + rested, maxXP) / maxXP)
        local restedWidth = math.max(0, restedEnd - xpFillEnd)

        overlay:SetDrawLayer("ARTWORK", 1)
        overlay:SetSize(restedWidth, barHeight)
        overlay:ClearAllPoints()
        overlay:SetPoint("LEFT", bar, "LEFT", xpFillEnd, 0)

        -- Default Rested Purple: #9966CC
        local rBarColor = profile.restedBarColor or { r = 0.6, g = 0.4, b = 0.8, a = 1 }
        overlay:SetColorTexture(rBarColor.r, rBarColor.g, rBarColor.b, rBarColor.a)
        overlay:Show()
    else
        overlay:Hide()
    end
end

-------------------------------------------------------------------------------
-- CONFIG PREVIEW RENDER
-------------------------------------------------------------------------------

function ExperienceModule:renderConfig()
    local profile = self.core.db and self.core.db.profile
    if not profile then return end

    local bars  = profile.bars
    local xpObj = self.core.xp
    if not xpObj then return end

    local xpConfig = bars and bars["XP"]
    if not xpConfig or not xpConfig.enabled then
        if xpObj.bar     then xpObj.bar:Hide()     end
        if xpObj.txFrame then xpObj.txFrame:Hide() end
        if xpObj.restedOverlay then xpObj.restedOverlay:Hide() end
        return
    end

    if xpObj.bar     then xpObj.bar:Show()     end
    if xpObj.txFrame then xpObj.txFrame:Show() end

    -- Default XP Blue: #0066E6
    local xpColor   = profile.xpBarColor or { r = 0, g = 0.4, b = 0.9, a = 1 }
    local classColor = profile.useClassColorXP and self.core:getClassColor() or xpColor

    self.core:setupBar(xpObj, 0, 100, 75, classColor)

    xpObj.current     = 7500
    xpObj.max         = 10000
    xpObj.percentage  = 75
    xpObj.displayName = string.format(Locales["LEVEL_TEXT"] or "Level %d", 60)
    xpObj.color       = classColor
    xpObj.rested      = 2500

    if xpObj.centerText then
        xpObj.centerText:SetText(Locales["XP_BAR_CONFIG_TEXT"] or Locales["XP_BAR_DATA"] or "")
    end

    -- Config preview: rested overlay starts at 75% and covers next 25%
    local overlay = xpObj.restedOverlay
    local bar     = xpObj.bar
    if profile.showRestedBar and overlay and bar then
        local barWidth = bar:GetWidth() or 0
        overlay:SetDrawLayer("ARTWORK", 1)
        overlay:SetSize(barWidth * 0.25, bar:GetHeight() or 6)
        overlay:ClearAllPoints()
        overlay:SetPoint("LEFT", bar, "LEFT", barWidth * 0.75, 0)

        -- Default Rested Purple: #9966CC
        local rBarColor = profile.restedBarColor or { r = 0.6, g = 0.4, b = 0.8, a = 1 }
        overlay:SetColorTexture(rBarColor.r, rBarColor.g, rBarColor.b, rBarColor.a)
        overlay:Show()
    elseif overlay then
        overlay:Hide()
    end
end

-- Backward-compat shim: core still calls self:configExperience / self:renderExperience
-- via the old dispatch in some config panel code paths. Delegate to this module.
function core:renderExperience(shouldHideXP)
    local mod = self:GetModule("Experience", true)
    if mod then mod:renderLive(shouldHideXP) end
end

function core:configExperience(profile, bars, textColor)
    local mod = self:GetModule("Experience", true)
    if mod then mod:renderConfig() end
end