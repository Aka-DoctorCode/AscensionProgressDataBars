-------------------------------------------------------------------------------
-- Project: AscensionBars
-- Author: Aka-DoctorCode
-- File: ParagonAlerts.lua
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
local locales = LibStub("AceLocale-3.0"):GetLocale("AscensionBars")

-- Object-Oriented module for the Paragon Alerts Tab
addonTable.paragonAlertsTab = {}
local paragonAlertsTab = addonTable.paragonAlertsTab

function paragonAlertsTab:build(panel)
    if not panel or not panel.content then return end
    
    addonTable.configUtils:cleanupContent(panel.content)
    
    local content = panel.content
    local profile = ascensionBars.db.profile
    if not profile then return end

    local layout = addonTable.layoutModel:new(content, -15)
    
    layout:header("AlertStylingHeader", locales["ALERT_STYLING"])
    
    layout:checkbox("ShowOnTopCheckbox", locales["SHOW_ON_TOP"], nil,
        function() return profile.paragonOnTop end,
        function(v)
            profile.paragonOnTop = v
            ascensionBars:updateDisplay()
        end)
        
    layout:checkbox("SplitLinesCheckbox", locales["SPLIT_LINES"], nil,
        function() return profile.splitParagonText end,
        function(v)
            profile.splitParagonText = v
            ascensionBars:updateDisplay()
        end)
        
    layout:slider("ParagonTextSizeSlider", locales["TEXT_SIZE"], 10, 40, 1,
        function() return profile.paragonTextSize or 18 end,
        function(v)
            profile.paragonTextSize = v
            ascensionBars:updateDisplay()
        end,
        180, 15)
        
    layout:slider("ParagonVerticalOffsetYSlider", locales["VERTICAL_OFFSET_Y"], -1000, 500, 5,
        function() return profile.paragonTextYOffset or -100 end,
        function(v)
            profile.paragonTextYOffset = v
            ascensionBars:updateDisplay()
        end,
        180, 15)
        
    layout:colorPicker("AlertColorPicker", locales["ALERT_COLOR"],
        function()
            local c = profile.paragonPendingColor
            if not c then return 0, 0.8, 1, 1 end -- #00CCFF
            return c.r, c.g, c.b, 1
        end,
        function(r, g, b)
            if not profile.paragonPendingColor then profile.paragonPendingColor = {} end
            local c = profile.paragonPendingColor
            c.r = r
            c.g = g
            c.b = b
            ascensionBars:updateDisplay()
        end,
        15, false)

    content:SetHeight(math.abs(layout.y) + 20)
end