-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
-- Author: Aka-DoctorCode
-- File: TextLayout.lua
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

-- Shared utilities mapped from the main table
local colors = ascensionBars.colors
local menuStyle = ascensionBars.menuStyle

-- Función segura para Locales: Evita que AceLocale arroje errores "Missing entry"
local function L(key, fallback)
    local success, val = pcall(function() return locales[key] end)
    if success and type(val) == "string" then
        return val
    end
    return fallback or key
end

-- Object-Oriented module for the Text Layout Tab
addonTable.textLayoutTab = {}
local textLayoutTab = addonTable.textLayoutTab

function textLayoutTab:build(panel)
    if not panel or not panel.content then return end

    addonTable.configUtils:cleanupContent(panel.content)

    local content = panel.content
    local profile = ascensionBars.db.profile
    if not profile then return end

    -- Dimensiones base (Exactamente iguales a BarsLayout)
    local defaultAvailableSpace = (ascensionBars.normalWidth or 750) - (menuStyle.sidebarWidth or 150) - 30
    local colGap = 10
    local colWidth = (defaultAvailableSpace - colGap) / 2
    local col1X = 15
    local col2X = 15 + colWidth + colGap

    local y = -15
    
    -- Usamos el mismo sistema de Layout centralizado que en BarsLayout
    local mainLayout = addonTable.layoutModel:new(content, y)

    ---------------------------------------------------------------------------
    -- SECTION 1: BASE TYPOGRAPHY
    ---------------------------------------------------------------------------
    mainLayout:header("TypographyHeader", L("BASE_TYPOGRAPHY", "Base Typography"))
    local startY = mainLayout.y

    -- Column 1 (Left)
    mainLayout:slider("FontSizeSlider", L("FONT_SIZE", "Font Size"), 8, 32, 1,
        function() return profile.textSize end,
        function(v)
            profile.textSize = v; ascensionBars:updateDisplay()
        end, colWidth - 20, col1X)

    mainLayout:dropdown("FontOutlineDropdown", L("FONT_OUTLINE", "Font Outline"),
        {
            { label = L("NONE", "None"), value = "NONE" },
            { label = "OUTLINE",       value = "OUTLINE" },
            { label = "THICKOUTLINE",  value = "THICKOUTLINE" }
        },
        function() return profile.fontOutline or "OUTLINE" end,
        function(v)
            profile.fontOutline = v; ascensionBars:updateDisplay()
        end, colWidth - 20, col1X)

    local afterCol1Y = mainLayout.y

    -- Column 2 (Right)
    mainLayout.y = startY -- Regresamos la 'Y' arriba para la segunda columna
    mainLayout:slider("GlobalYOffsetSlider", L("GLOBAL_OFFSET", "Global Y Offset"), -100, 100, 1,
        function() return profile.textYOffset or 0 end,
        function(v)
            profile.textYOffset = v; ascensionBars:updateDisplay()
        end, colWidth - 20, col2X)

    mainLayout:colorPicker("GlobalTextColorPicker", L("GLOBAL_TEXT_COLOR", "Global Text Color"),
        function()
            local c = profile.textColor
            if not c then return 1, 1, 1, 1 end
            return c.r, c.g, c.b, c.a
        end,
        function(r, g, b, a)
            profile.textColor = profile.textColor or {}
            local c = profile.textColor
            c.r, c.g, c.b, c.a = r, g, b, a
            ascensionBars:updateDisplay()
        end, col2X + 11, true)

    -- Sincronizamos la Y usando el punto más bajo de ambas columnas
    mainLayout.y = math.min(afterCol1Y, mainLayout.y) - 15

    ---------------------------------------------------------------------------
    -- SECTION 2: VISUAL OPTIONS
    ---------------------------------------------------------------------------
    mainLayout:header("VisualOptionsHeader", L("VISUAL_OPTIONS", "Visual Options"))
    startY = mainLayout.y

    -- Column 1 (Left)
    mainLayout:checkbox("ShowAbsoluteValuesToggle", L("SHOW_ABSOLUTE_VALUES", "Show Absolute Values"), nil,
        function() return profile.showAbsoluteValues end,
        function(v)
            profile.showAbsoluteValues = v; ascensionBars:updateDisplay()
        end, col1X)

    afterCol1Y = mainLayout.y

    -- Column 2 (Right)
    mainLayout.y = startY
    mainLayout:checkbox("UseCompactFormatToggle", L("USE_COMPACT_FORMAT", "Use Compact Format"), nil,
        function() return profile.useCompactFormat end,
        function(v)
            profile.useCompactFormat = v; ascensionBars:updateDisplay()
        end, col2X)

    mainLayout:checkbox("ShowPercentageToggle", L("SHOW_PERCENTAGE", "Show Percentage"), nil,
        function() return profile.showPercentage end,
        function(v)
            profile.showPercentage = v; ascensionBars:updateDisplay()
        end, col2X)

    mainLayout.y = math.min(afterCol1Y, mainLayout.y) - 15

    ---------------------------------------------------------------------------
    -- SECTION 3: BLOCK TEXT MODE
    ---------------------------------------------------------------------------
    mainLayout:header("BlockModeHeader", L("BLOCK_TEXT_MODE", "Block Text Mode"))
    startY = mainLayout.y

    -- Column 1 (Left)
    mainLayout:dropdown("TextVisibilityMode", L("TEXT_VISIBILITY_MODE", "Text Visibility Mode"),
        {
            { label = L("FOCUS_MODE", "Focus Mode"),   value = "FOCUS" },
            { label = L("GRID_DYNAMIC", "Dynamic Grid"), value = "GRID" },
            { label = L("NONE", "None"),         value = "NONE" }
        },
        function() return profile.blockTextMode or "FOCUS" end,
        function(v)
            profile.blockTextMode = v
            ascensionBars:updateDisplay()
            if panel.updateLayout then panel:updateLayout() end
        end, colWidth - 20, col1X)

    afterCol1Y = mainLayout.y

    -- Column 2 (Right)
    mainLayout.y = startY
    if profile.blockTextMode == "FOCUS" then
        mainLayout:slider("FocusDimAlphaSlider", L("DIM_ALPHA", "Dim Alpha"), 0, 100, 5,
            function() return (profile.focusDimAlpha or 0.2) * 100 end,
            function(v)
                profile.focusDimAlpha = v / 100
                ascensionBars:updateDisplay()
            end, colWidth - 20, col2X)
    elseif profile.blockTextMode == "GRID" then
        mainLayout:slider("DynamicGridGapSlider", L("DYNAMIC_GRID_GAP", "Dynamic Grid Gap"), 0, 50, 1,
            function() return profile.dynamicGridGap or 2 end,
            function(v)
                profile.dynamicGridGap = v
                ascensionBars:updateDisplay()
            end, colWidth - 20, col2X)
    end

    mainLayout.y = math.min(afterCol1Y, mainLayout.y) - 15

    ---------------------------------------------------------------------------
    -- SECTION 4: EVENTS & VISIBILITY
    ---------------------------------------------------------------------------
    mainLayout:header("VisibilityHeader", L("EVENTS_VISIBILITY", "Events & Visibility"))
    startY = mainLayout.y

    -- Column 1 (Left)
    mainLayout:checkbox("EnableCarouselToggle", L("ENABLE_CAROUSEL", "Enable Carousel"), nil,
        function() return profile.carouselEnabled end,
        function(v)
            profile.carouselEnabled = v; ascensionBars:updateDisplay()
        end, col1X)

    mainLayout:checkbox("LegendEnabledToggle", L("LATERAL_LEGEND", "Lateral Legend"), nil,
        function() return profile.legendEnabled end,
        function(v)
            profile.legendEnabled = v; ascensionBars:updateDisplay()
        end, col1X)

    afterCol1Y = mainLayout.y

    -- Column 2 (Right)
    mainLayout.y = startY
    mainLayout:slider("BackgroundAlphaSlider", L("REST_OPACITY", "Rest Opacity"), 0, 100, 5,
        function() return (profile.backgroundAlpha or 0.5) * 100 end,
        function(v)
            profile.backgroundAlpha = v / 100
            ascensionBars:updateDisplay()
        end, colWidth - 20, col2X)

    mainLayout.y = math.min(afterCol1Y, mainLayout.y) - 15

    -- Set exact scrollframe bounds
    content:SetHeight(math.abs(mainLayout.y) + 20)
end