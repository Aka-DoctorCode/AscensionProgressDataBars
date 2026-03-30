-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
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
---@type AscensionBars
local ascensionBars = addonTable.main or LibStub("AceAddon-3.0"):GetAddon(addonName)
---@cast ascensionBars AscensionBars
local locales = LibStub("AceLocale-3.0"):GetLocale("AscensionProgressDataBars")

-- Shared utilities mapped from the main table
local colors = ascensionBars.colors
local menuStyle = ascensionBars.menuStyle

-- Object-Oriented module for the Alerts Tab
addonTable.paragonAlertsTab = {}
local paragonAlertsTab = addonTable.paragonAlertsTab

function paragonAlertsTab:build(panel)
    if not panel or not panel.content then return end
    
    addonTable.configUtils:cleanupContent(panel.content)
    
    local content = panel.content
    local profile = ascensionBars.db.profile
    if not profile then return end

    -- UX IMPROVEMENT: 2-Column Layout Calculations
    local defaultAvailableSpace = (ascensionBars.normalWidth or 750) - (menuStyle.sidebarWidth or 150) - 50
    local colGap = 10
    local colWidth = (defaultAvailableSpace - colGap) / 2
    local sliderWidth = colWidth - 20

    local col1X = 10
    local col2X = 10 + colWidth + colGap
    local startY = -15

    -- Independent Layout Models for the 2 columns
    local col1Layout = addonTable.layoutModel:new(content, startY)
    local col2Layout = addonTable.layoutModel:new(content, startY)

    ---------------------------------------------------------------------------
    -- COLUMN 1: Paragon Alerts
    ---------------------------------------------------------------------------
    local inner1X = col1X + 5
    local check1X = inner1X - 6
    local picker1X = inner1X + 6
    local slider1X = inner1X + 10

    col1Layout:beginSection(col1X, colWidth)
    local headerY = col1Layout.y
    col1Layout:label("ParagonAlertsHeader", locales["PARAGON"] or "Paragon Alerts", inner1X, colors.gold)
    local postLabelY = col1Layout.y

    -- Ponemos el checkbox en la misma fila que el header
    col1Layout.y = headerY + 7
    col1Layout:checkbox("SplitLinesCheckbox", locales["SPLIT_LINES"], nil,
        function() return profile.splitParagonText end,
        function(v)
            profile.splitParagonText = v
            ascensionBars:updateDisplay()
        end, inner1X + 115)
    
    -- Sincronizamos con la columna derecha (que solo usa label y un pequeño margen de -9)
    col1Layout.y = postLabelY - 15

    col1Layout:slider("ParagonTextSizeSlider", locales["TEXT_SIZE"], 10, 40, 1,
        function() return profile.paragonTextSize or 18 end,
        function(v)
            profile.paragonTextSize = v
            ascensionBars:updateDisplay()
        end, sliderWidth, slider1X)

    col1Layout:slider("ParagonXOffsetSlider", locales["POS_X"], -1000, 1000, 5,
        function() return profile.paragonXOffset or 0 end,
        function(v)
            profile.paragonXOffset = v
            ascensionBars:updateDisplay()
        end, sliderWidth, slider1X)
        
    col1Layout:slider("ParagonYOffsetSlider", locales["POS_Y"], -1000, 500, 5,
        function() return profile.paragonYOffset or -100 end,
        function(v)
            profile.paragonYOffset = v
            ascensionBars:updateDisplay()
        end, sliderWidth, slider1X)

        
    col1Layout:colorPicker("AlertColorPicker", locales["ALERT_COLOR"],
        function()
            local c = profile.paragonPendingColor
            if not c then return 0, 0.8, 1, 1 end -- #00CCFF
            return c.r, c.g, c.b, 1
        end,
        function(r, g, b)
            if not profile.paragonPendingColor then profile.paragonPendingColor = {} end
            local c = profile.paragonPendingColor
            c.r = r; c.g = g; c.b = b
            ascensionBars:updateDisplay()
        end, picker1X, false)

    col1Layout.y = col1Layout.y - 12 -- Bottom padding for the card
    col1Layout:endSection()

    ---------------------------------------------------------------------------
    -- COLUMN 2: House Rewards Alerts
    ---------------------------------------------------------------------------
    local inner2X = col2X + 5
    local picker2X = inner2X + 6
    local slider2X = inner2X + 10

    col2Layout:beginSection(col2X, colWidth)
    col2Layout:label("HouseRewardsHeader", locales["HOUSE_FAVOR"] or "House Rewards", inner2X, colors.gold)
    col2Layout.y = col2Layout.y - 15 -- Header bottom margin

    col2Layout:slider("HouseRewardTextSizeSlider", locales["TEXT_SIZE"], 10, 40, 1,
        function() return profile.houseRewardTextSize or 18 end,
        function(v)
            profile.houseRewardTextSize = v
            ascensionBars:updateDisplay()
        end, sliderWidth, slider2X)

    col2Layout:slider("HouseRewardXOffsetSlider", locales["POS_X"], -1000, 1000, 5,
        function() return profile.houseRewardXOffset or 0 end,
        function(v)
            profile.houseRewardXOffset = v
            ascensionBars:updateDisplay()
        end, sliderWidth, slider2X)
        
    col2Layout:slider("HouseRewardYOffsetSlider", locales["POS_Y"], -1000, 500, 5,
        function() return profile.houseRewardTextYOffset or -60 end,
        function(v)
            profile.houseRewardTextYOffset = v
            ascensionBars:updateDisplay()
        end, sliderWidth, slider2X)

    col2Layout:colorPicker("HouseRewardColorPicker", locales["ALERT_COLOR"],
        function()
            local c = profile.houseRewardTextColor
            if not c then return 0.9, 0.5, 0, 1 end -- #E68000
            return c.r, c.g, c.b, 1
        end,
        function(r, g, b)
            if not profile.houseRewardTextColor then profile.houseRewardTextColor = {} end
            local c = profile.houseRewardTextColor
            c.r = r; c.g = g; c.b = b; c.a = 1
            ascensionBars:updateDisplay()
        end, picker2X, false)

    col2Layout.y = col2Layout.y - 12 -- Bottom padding for the card
    col2Layout:endSection()

    -- Calculate the lowest Y point between the columns to set the canvas height accurately
    local maxBottomY = math.min(col1Layout.y, col2Layout.y)
    content:SetHeight(math.abs(maxBottomY) + 20)
end