-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
-- Author: Aka-DoctorCode
-- File: BlizzardIntegration.lua
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
local locales = LibStub("AceLocale-3.0"):GetLocale("AscensionBars")

local colors = ascensionBars.colors
local menuStyle = ascensionBars.menuStyle

local blizzardPanel = CreateFrame("Frame", "AscensionBars_BlizPanel", UIParent)
blizzardPanel.name = locales["ADDON_NAME"] or addonName
blizzardPanel:Hide()

local function buildBlizUI()
    if blizzardPanel.isInitialized then return end

    local title = blizzardPanel:CreateFontString(nil, "OVERLAY", menuStyle.headerFont)
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText(blizzardPanel.name)
    title:SetTextColor(unpack(colors.gold)) -- #FFCC33

    local description = blizzardPanel:CreateFontString(nil, "OVERLAY", menuStyle.descFont)
    description:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -12)
    description:SetPoint("RIGHT", -16, 0)
    description:SetJustifyH("LEFT")
    description:SetText("All configuration options have been moved to a specialized high-performance menu for a better user experience.")

    local openMenuButton = CreateFrame("Button", nil, blizzardPanel, "UIPanelButtonTemplate")
    openMenuButton:SetSize(280, 45)
    openMenuButton:SetPoint("CENTER", blizzardPanel, "CENTER", 0, 0)
    openMenuButton:SetText("OPEN ASCENSION SETTINGS")

    openMenuButton:SetScript("OnClick", function()
        ---@class SettingsPanel : Frame
        ---@field Close function
        local settingsPanel = _G["SettingsPanel"]
        ---@cast settingsPanel SettingsPanel
        if settingsPanel and settingsPanel:IsShown() then
            settingsPanel:Close()
        end
        ascensionBars:toggleConfig()
    end)

    blizzardPanel.isInitialized = true
end

blizzardPanel:SetScript("OnShow", buildBlizUI)

local function registerBlizzardOptions()
    ---@class Settings
    ---@field RegisterCanvasLayoutCategory function
    ---@field RegisterAddOnCategory function
    local settings = _G["Settings"]
    ---@cast settings Settings
    if settings and settings.RegisterCanvasLayoutCategory then
        local category = settings.RegisterCanvasLayoutCategory(blizzardPanel, blizzardPanel.name)
        settings.RegisterAddOnCategory(category)
    else
        local addCategory = _G["InterfaceOptions_AddCategory"]
        if addCategory then 
            addCategory(blizzardPanel) 
        end
    end
end

if ascensionBars:IsEnabled() or (ascensionBars.db) then
    registerBlizzardOptions()
else
    local oldInit = ascensionBars.OnInitialize
    ascensionBars.OnInitialize = function(self)
        if type(oldInit) == "function" then 
            oldInit(self) 
        end
        registerBlizzardOptions()
    end
end