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
local locales = LibStub("AceLocale-3.0"):GetLocale("AscensionProgressDataBars")
local colors = ascensionBars.colors
local menuStyle = ascensionBars.menuStyle

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

    local defaultAvailableSpace = (ascensionBars.normalWidth or 750) - (menuStyle.sidebarWidth or 150) - 30
    local colGap = 10
    local colWidth = (defaultAvailableSpace - colGap) / 2
    local col1X = 15
    local col2X = 15 + colWidth + colGap

    local y = -15

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
    mainLayout.y = startY
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
    -- SECTION 2: BLOCK TEXT MODE
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
            -- Force UI refresh to show/hide context options
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
    -- SECTION 3: EVENTS & VISIBILITY
    ---------------------------------------------------------------------------
    mainLayout:header("VisibilityHeader", L("EVENTS_VISIBILITY", "Events & Visibility"))
    startY = mainLayout.y

    -- Column 1 (Left)
    mainLayout:checkbox("EnableCarouselToggle", L("ENABLE_CAROUSEL", "Enable Carousel"), nil,
        function() return profile.carouselEnabled end,
        function(v)
            profile.carouselEnabled = v
            ascensionBars:updateDisplay()
            if panel.updateLayout then panel:updateLayout() end
        end, col1X)

    mainLayout:checkbox("LegendEnabledToggle", L("LATERAL_LEGEND", "Lateral Legend"), nil,
        function() return profile.legendEnabled end,
        function(v)
            profile.legendEnabled = v
            ascensionBars:updateDisplay()
            if panel.updateLayout then panel:updateLayout() end
        end, col1X)

    afterCol1Y = mainLayout.y

    mainLayout.y = math.min(afterCol1Y, mainLayout.y) - 15

    ---------------------------------------------------------------------------
    -- SECTION 4: CAROUSEL OPTIONS
    ---------------------------------------------------------------------------
    if profile.carouselEnabled then
        mainLayout:header("CarouselOptionsHeader", L("CAROUSEL_OPTIONS", "Carousel Options"))
        startY = mainLayout.y

        -- Column 1 (Left): X Offset & Background Alpha
        mainLayout:slider("CarouselXOffsetSlider", L("CAROUSEL_X_OFFSET", "X Offset"), -1000, 1000, 5,
            function() return profile.carouselXOffset or 0 end,
            function(v)
                profile.carouselXOffset = v
                ascensionBars:updateCarouselVisibility()
            end, colWidth - 20, col1X)

        mainLayout.y = mainLayout.y - 10

        mainLayout:slider("CarouselBgAlphaSlider", L("CAROUSEL_BG_ALPHA", "Background Alpha"), 0, 100, 5,
            function() 
                local alpha = profile.carouselBgAlpha
                if alpha == nil then alpha = 0.4 end
                return alpha * 100 
            end,
            function(v)
                profile.carouselBgAlpha = v / 100
                ascensionBars:updateCarouselVisibility()
            end, colWidth - 20, col1X)

        afterCol1Y = mainLayout.y

        -- Column 2 (Right): Y Offset
        mainLayout.y = startY
        mainLayout:slider("CarouselYOffsetSlider", L("CAROUSEL_Y_OFFSET", "Y Offset"), -1000, 1000, 5,
            function() return profile.carouselYOffset or 80 end,
            function(v)
                profile.carouselYOffset = v
                ascensionBars:updateCarouselVisibility()
            end, colWidth - 20, col2X)

        mainLayout.y = math.min(afterCol1Y, mainLayout.y) - 15
    end

    ---------------------------------------------------------------------------
    -- SECTION 5: LEGEND OPTIONS
    ---------------------------------------------------------------------------
    if profile.legendEnabled then
        mainLayout:header("LegendOptionsHeader", L("LEGEND_OPTIONS", "Legend Options"))
        startY = mainLayout.y

        -- Column 1 (Left): Text Size & Outline
        mainLayout:slider("LegendTextSizeSlider", L("LEGEND_TEXT_SIZE", "Legend Text Size"), 8, 32, 1,
            function() return profile.legendTextSize or 12 end,
            function(v)
                profile.legendTextSize = v
                ascensionBars:updateLegend()
            end, colWidth - 20, col1X)

        mainLayout.y = mainLayout.y - 10 

        mainLayout:dropdown("LegendFontOutlineDropdown", L("LEGEND_FONT_OUTLINE", "Legend Font Outline"),
            {
                { label = L("NONE", "None"), value = "NONE" },
                { label = "OUTLINE",       value = "OUTLINE" },
                { label = "THICKOUTLINE",  value = "THICKOUTLINE" }
            },
            function() return profile.legendFontOutline or "OUTLINE" end,
            function(v)
                profile.legendFontOutline = v
                ascensionBars:updateLegend()
            end, colWidth - 20, col1X)

        afterCol1Y = mainLayout.y

        -- Column 2 (Right): Background Alpha
        mainLayout.y = startY
        mainLayout:slider("LegendBgAlphaSlider", L("LEGEND_BG_ALPHA", "Background Alpha"), 0, 100, 5,
            function() 
                local alpha = profile.legendBgAlpha
                if alpha == nil then alpha = 0.4 end
                return alpha * 100 
            end,
            function(v)
                profile.legendBgAlpha = v / 100
                ascensionBars:updateLegend()
            end, colWidth - 20, col2X)

        mainLayout.y = math.min(afterCol1Y, mainLayout.y) - 15
    end

    content:SetHeight(math.abs(mainLayout.y) + 60)
end
