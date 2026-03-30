-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
-- Author: Aka-DoctorCode
-- File: Bars/Azerite.lua
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
local Locales  = LibStub("AceLocale-3.0"):GetLocale("AscensionProgressDataBars")
local dataText = addonTable.dataText

-------------------------------------------------------------------------------
-- MODULE DEFINITION
-------------------------------------------------------------------------------

local AzeriteModule = core:NewModule("Azerite", "AceEvent-3.0")
AzeriteModule.core  = core

-------------------------------------------------------------------------------
-- MODULE LIFECYCLE
-------------------------------------------------------------------------------

function AzeriteModule:OnEnable()
    self:RegisterEvent("AZERITE_ITEM_EXPERIENCE_CHANGED", "onAzeriteUpdate")
end

function AzeriteModule:OnDisable()
    self:UnregisterAllEvents()
end

-------------------------------------------------------------------------------
-- EVENT HANDLERS
-------------------------------------------------------------------------------

function AzeriteModule:onAzeriteUpdate()
    local state = self.core.state
    if not state then return end

    if not (C_AzeriteItem and C_AzeriteItem.FindActiveAzeriteItem) then return end

    local itemLoc = C_AzeriteItem.FindActiveAzeriteItem()
    if not itemLoc then return end

    if not C_AzeriteItem.GetAzeriteItemXPInfo then return end
    local current = C_AzeriteItem.GetAzeriteItemXPInfo(itemLoc)
    if not current then return end

    local last = state.lastAzeriteXP
    if last and last > 0 and current > last then
        local gained = current - last
        if self.core.pushCarouselEvent then
            self.core:pushCarouselEvent("AZERITE", "azerite", "Azerite", gained)
        end
    end

    state.lastAzeriteXP = current
    self.core:updateDisplay()
end

-------------------------------------------------------------------------------
-- RENDER DISPATCH
-------------------------------------------------------------------------------

function AzeriteModule:UpdateRender(isConfig, shouldHideXP)
    if isConfig then
        self:renderConfig()
    else
        self:renderLive()
    end
end

-------------------------------------------------------------------------------
-- LIVE RENDER
-------------------------------------------------------------------------------

function AzeriteModule:renderLive()
    local profile = self.core.db and self.core.db.profile
    if not profile then return end

    local bars      = profile.bars
    local azObj     = self.core.azerite
    if not azObj then return end

    if not bars or not bars["Azerite"] or not bars["Azerite"].enabled then
        if azObj.bar     then azObj.bar:Hide()     end
        if azObj.txFrame then azObj.txFrame:Hide() end
        return
    end

    self.core:updateStandardBar(azObj, "Azerite",
        function()
            if not (C_AzeriteItem and C_AzeriteItem.FindActiveAzeriteItem) then return 0 end
            local itemLoc = C_AzeriteItem.FindActiveAzeriteItem()
            if not (itemLoc and C_AzeriteItem.GetAzeriteItemXPInfo) then return 0 end
            local xp = C_AzeriteItem.GetAzeriteItemXPInfo(itemLoc)
            return xp or 0
        end,
        function()
            if not (C_AzeriteItem and C_AzeriteItem.FindActiveAzeriteItem) then return 100 end
            local itemLoc = C_AzeriteItem.FindActiveAzeriteItem()
            if not (itemLoc and C_AzeriteItem.GetAzeriteItemXPInfo) then return 100 end
            local _, total = C_AzeriteItem.GetAzeriteItemXPInfo(itemLoc)
            return total or 100
        end,
        function()
            -- Default Azerite Gold: #E5CC7F
            return profile.azeriteColor or { r = 0.9, g = 0.8, b = 0.5, a = 1.0 }
        end,
        function(current, max, percentage)
            if not dataText then return "" end
            return dataText:formatAzerite(current, max, percentage)
        end
    )

    -- Store additional legend info
    local azeriteLevel = 0
    if C_AzeriteItem and C_AzeriteItem.FindActiveAzeriteItem then
        local itemLocation = C_AzeriteItem.FindActiveAzeriteItem()
        if itemLocation and C_AzeriteItem.GetPowerLevel then
            azeriteLevel = C_AzeriteItem.GetPowerLevel(itemLocation) or 0
        end
    end
    azObj.displayName = string.format((Locales["AZERITE"] or "Azerite") .. " Level %d", azeriteLevel)
end

-------------------------------------------------------------------------------
-- CONFIG PREVIEW RENDER
-------------------------------------------------------------------------------

function AzeriteModule:renderConfig()
    local profile = self.core.db and self.core.db.profile
    if not profile then return end

    local azObj = self.core.azerite
    if not azObj then return end

    local azConfig = profile.bars and profile.bars["Azerite"]
    if not azConfig or not azConfig.enabled then
        if azObj.bar     then azObj.bar:Hide()     end
        if azObj.txFrame then azObj.txFrame:Hide() end
        return
    end

    if azObj.bar     then azObj.bar:Show()     end
    if azObj.txFrame then azObj.txFrame:Show() end

    -- Default Azerite Gold: #E5CC7F
    local azeriteColor = profile.azeriteColor or { r = 0.9, g = 0.8, b = 0.5, a = 1.0 }
    self.core:setupBar(azObj, 0, 100, 80, azeriteColor)

    azObj.current     = 2500
    azObj.max         = 5000
    azObj.percentage  = 50
    azObj.displayName = string.format((Locales["AZERITE"] or "Azerite") .. " Level %d", 30)
    azObj.color       = azeriteColor

    if azObj.centerText then
        azObj.centerText:SetText(Locales["AZERITE_BAR_DATA"])
    end
end

-- Backward-compat shims
function core:renderAzerite()
    local mod = self:GetModule("Azerite", true)
    if mod then mod:renderLive() end
end

function core:configAzerite(profile, bars, textColor)
    local mod = self:GetModule("Azerite", true)
    if mod then mod:renderConfig() end
end