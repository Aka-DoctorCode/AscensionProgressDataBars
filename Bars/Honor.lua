-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
-- Author: Aka-DoctorCode
-- File: Bars/Honor.lua
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
local Locales   = LibStub("AceLocale-3.0"):GetLocale("AscensionProgressDataBars")
local dataText  = addonTable.dataText

-------------------------------------------------------------------------------
-- MODULE DEFINITION
-------------------------------------------------------------------------------

local HonorModule = core:NewModule("Honor", "AceEvent-3.0")
HonorModule.core  = core

-------------------------------------------------------------------------------
-- MODULE LIFECYCLE
-------------------------------------------------------------------------------

function HonorModule:OnEnable()
    self:RegisterEvent("HONOR_XP_UPDATE",    "onHonorUpdate")
    self:RegisterEvent("HONOR_LEVEL_UPDATE",  "onUpdate")
end

function HonorModule:OnDisable()
    self:UnregisterAllEvents()
end

-------------------------------------------------------------------------------
-- EVENT HANDLERS
-------------------------------------------------------------------------------

function HonorModule:onHonorUpdate()
    local state = self.core.state
    if not state then return end

    local current = UnitHonor("player") or 0
    local last    = state.lastHonor

    if last and last > 0 and current > last then
        local gained = current - last
        if self.core.pushCarouselEvent then
            self.core:pushCarouselEvent("HONOR", "honor", "Honor", gained)
        end
    end

    state.lastHonor = current
    self.core:updateDisplay()
end

function HonorModule:onUpdate()
    self.core:updateDisplay()
end

-------------------------------------------------------------------------------
-- RENDER DISPATCH
-------------------------------------------------------------------------------

function HonorModule:UpdateRender(isConfig, shouldHideXP)
    if isConfig then
        self:renderConfig()
    else
        self:renderLive()
    end
end

-------------------------------------------------------------------------------
-- LIVE RENDER
-------------------------------------------------------------------------------

function HonorModule:renderLive()
    local profile = self.core.db and self.core.db.profile
    if not profile then return end

    local bars     = profile.bars
    local honorObj = self.core.honor
    if not honorObj then return end

    if not bars or not bars["Honor"] or not bars["Honor"].enabled then
        if honorObj.bar     then honorObj.bar:Hide()     end
        if honorObj.txFrame then honorObj.txFrame:Hide() end
        return
    end

    local honorLevel = UnitHonorLevel("player") or 0

    self.core:updateStandardBar(honorObj, "Honor",
        function() return UnitHonor("player")    or 0   end,
        function() return UnitHonorMax("player") or 100 end,
        function()
            -- Default Honor Red: #CC3333
            return profile.honorColor or { r = 0.8, g = 0.2, b = 0.2, a = 1.0 }
        end,
        function(current, max, percentage)
            if not dataText then return "" end
            local baseText   = dataText:formatHonor(current, max, percentage)
            local levelString = string.format(Locales["LEVEL_TEXT"] or "Level %d", honorLevel)
            if type(baseText) == "string" then
                if not string.find(baseText, levelString) then
                    return string.format("%s | %s", levelString, baseText)
                end
                return baseText
            end
            return levelString
        end
    )

    honorObj.displayName = string.format(Locales["HONOR_LEVEL_SIMPLE"] or "Honor Level %d", honorLevel)
end

-------------------------------------------------------------------------------
-- CONFIG PREVIEW RENDER
-------------------------------------------------------------------------------

function HonorModule:renderConfig()
    local profile = self.core.db and self.core.db.profile
    if not profile then return end

    local bars     = profile.bars
    local honorObj = self.core.honor
    if not honorObj then return end

    local honorConfig = bars and bars["Honor"]
    if not honorConfig or not honorConfig.enabled then
        if honorObj.bar     then honorObj.bar:Hide()     end
        if honorObj.txFrame then honorObj.txFrame:Hide() end
        return
    end

    if honorObj.bar     then honorObj.bar:Show()     end
    if honorObj.txFrame then honorObj.txFrame:Show() end

    -- Default Honor Red: #CC3333
    local honorColor = profile.honorColor or { r = 0.8, g = 0.2, b = 0.2, a = 1.0 }
    self.core:setupBar(honorObj, 0, 100, 30, honorColor)

    honorObj.current     = 1500
    honorObj.max         = 3000
    honorObj.percentage  = 50
    honorObj.displayName = string.format(Locales["LEVEL_TEXT"] or "Level %d", 45)
    honorObj.color       = honorColor

    if honorObj.centerText then
        local baseText    = Locales["HONOR_BAR_DATA"] or "Honor"
        local levelString = string.format(Locales["LEVEL_TEXT"] or "Level %d", 45)
        honorObj.centerText:SetText(levelString .. " | " .. baseText)
    end
end

-- Backward-compat shims
function core:renderHonor()
    local mod = self:GetModule("Honor", true)
    if mod then mod:renderLive() end
end

function core:configHonor(profile, bars, textColor)
    local mod = self:GetModule("Honor", true)
    if mod then mod:renderConfig() end
end