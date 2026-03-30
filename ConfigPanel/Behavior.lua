-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
-- Author: Aka-DoctorCode
-- File: Behavior.lua
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
local locales = LibStub("AceLocale-3.0"):GetLocale("AscensionProgressDataBars")

-- Object-Oriented module for the Behavior Tab
addonTable.behaviorTab = {}
local behaviorTab = addonTable.behaviorTab

function behaviorTab:build(panel)
    if not panel or not panel.content then return end
    
    addonTable.configUtils:cleanupContent(panel.content)
    
    local content = panel.content
    local profile = ascensionBars.db.profile
    if not profile then return end

    local layout = addonTable.layoutModel:new(content, -15)
    
    -- Auto Hide Logic Section
    layout:header("AutoHideLogicHeader", locales["AUTO_HIDE_LOGIC"])
    
    layout:checkbox("ShowOnMouseoverCheckbox", locales["SHOW_ON_MOUSEOVER"], nil,
        function() return profile.showOnMouseover end,
        function(v)
            profile.showOnMouseover = v
            ascensionBars:updateDisplay()
        end)
        
    layout:checkbox("HideInCombatCheckbox", locales["HIDE_IN_COMBAT"], nil,
        function() return profile.hideInCombat end,
        function(v)
            profile.hideInCombat = v
            ascensionBars:updateDisplay()
        end)
        
    layout:checkbox("HideAtMaxLevelCheckbox", locales["HIDE_AT_MAX_LEVEL"], nil,
        function() return profile.hideAtMaxLevel end,
        function(v)
            profile.hideAtMaxLevel = v
            ascensionBars:updateDisplay()
        end)

    -- Data Display Section
    layout:header("DataDisplayHeader", locales["DATA_DISPLAY"])
    
    layout:checkbox("ShowRestedXPToggle", locales["SHOW_RESTED"], nil,
        function() return profile.showRestedBar end,
        function(v)
            profile.showRestedBar = v; ascensionBars:updateDisplay()
        end)

    layout:checkbox("ShowPercentageCheckbox", locales["SHOW_PERCENTAGE"], nil,
        function() return profile.showPercentage end,
        function(v)
            profile.showPercentage = v
            ascensionBars:updateDisplay()
        end)
        
    layout:checkbox("ShowAbsoluteValuesCheckbox", locales["SHOW_ABSOLUTE_VALUES"], nil,
        function() return profile.showAbsoluteValues end,
        function(v)
            profile.showAbsoluteValues = v
            ascensionBars:updateDisplay()
        end)

    layout:checkbox("UseCompactFormatToggle", locales["USE_COMPACT_FORMAT"], nil,
        function() return profile.useCompactFormat end,
        function(v)
            profile.useCompactFormat = v; ascensionBars:updateDisplay()
        end)
        
    layout:checkbox("ShowSparkCheckbox", locales["SHOW_SPARK"], nil,
        function() return profile.sparkEnabled end,
        function(v)
            profile.sparkEnabled = v
            ascensionBars:updateDisplay()
        end)

    content:SetHeight(math.abs(layout.y) + 20)
end