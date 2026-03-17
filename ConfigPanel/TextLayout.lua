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

    local startY = -15
    local maxColumnY = startY

    ---------------------------------------------------------------------------
    -- COLUMN 1 (LEFT): Typography & Visual Disposition
    ---------------------------------------------------------------------------
    local leftLayout = addonTable.layoutModel:new(content, startY)
    
    -- Header 1: Base Typography
    local header1 = content:CreateFontString(nil, "OVERLAY", menuStyle.labelFont)
    header1:SetPoint("TOPLEFT", col1X - 5, leftLayout.y)
    header1:SetWidth(colWidth)
    header1:SetJustifyH("CENTER")
    header1:SetText(locales["BASE_TYPOGRAPHY"])
    local fontPath, _, outline = header1:GetFont()
    header1:SetFont(fontPath, 20, outline)
    header1:SetTextColor(0.64, 0.21, 0.93)
    
    leftLayout.y = leftLayout.y - 30

    leftLayout:slider("FontSizeSlider", locales["FONT_SIZE"], 8, 32, 1,
        function() return profile.textSize end,
        function(v) profile.textSize = v; ascensionBars:updateDisplay() end, colWidth - 20, col1X)

    leftLayout:dropdown("FontOutlineDropdown", locales["FONT_OUTLINE"],
        {
            { label = locales["NONE"], value = "NONE" },
            { label = "OUTLINE", value = "OUTLINE" },
            { label = "THICKOUTLINE", value = "THICKOUTLINE" }
        },
        function() return profile.fontOutline or "OUTLINE" end,
        function(v) profile.fontOutline = v; ascensionBars:updateDisplay() end,
        colWidth - 20, col1X)

    leftLayout:colorPicker("GlobalTextColorPicker", locales["GLOBAL_TEXT_COLOR"],
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
        end, col1X + 11, true)
        
    leftLayout.y = leftLayout.y - 15

    -- Header 2: Visual Disposition
    local header2 = content:CreateFontString(nil, "OVERLAY", menuStyle.labelFont)
    header2:SetPoint("TOPLEFT", col1X - 5, leftLayout.y)
    header2:SetWidth(colWidth)
    header2:SetJustifyH("CENTER")
    header2:SetText(locales["VISUAL_DISPOSITION"])
    header2:SetFont(fontPath, 20, outline)
    header2:SetTextColor(0.64, 0.21, 0.93)
    
    leftLayout.y = leftLayout.y - 30

    -- leftLayout:checkbox("ShowRestedXPToggle", locales["SHOW_RESTED"], nil,
    --     function() return profile.showRestedBar end,
    --     function(v) profile.showRestedBar = v; ascensionBars:updateDisplay() end, col1X)

    leftLayout:checkbox("UseCompactFormatToggle", locales["USE_COMPACT_FORMAT"], nil,
        function() return profile.useCompactFormat end,
        function(v) profile.useCompactFormat = v; ascensionBars:updateDisplay() end, col1X)
        
    -- leftLayout:checkbox("ShowAbsoluteValuesToggle", locales["SHOW_ABSOLUTE_VALUES"], nil,
    --     function() return profile.showAbsoluteValues end,
    --     function(v) profile.showAbsoluteValues = v; ascensionBars:updateDisplay() end, col1X)

    -- leftLayout:checkbox("ShowPercentageToggle", locales["SHOW_PERCENTAGE"], nil,
    --     function() return profile.showPercentage end,
    --     function(v) profile.showPercentage = v; ascensionBars:updateDisplay() end, col1X)

    if leftLayout.y < maxColumnY then maxColumnY = leftLayout.y end

    ---------------------------------------------------------------------------
    -- COLUMN 2 (RIGHT): Block Mode & Events
    ---------------------------------------------------------------------------
    local rightLayout = addonTable.layoutModel:new(content, startY)
    
    -- Header 3: Block Text Mode
    local header3 = content:CreateFontString(nil, "OVERLAY", menuStyle.labelFont)
    header3:SetPoint("TOPLEFT", col2X - 5, rightLayout.y)
    header3:SetWidth(colWidth)
    header3:SetJustifyH("CENTER")
    header3:SetText(locales["BLOCK_TEXT_MODE"])
    header3:SetFont(fontPath, 20, outline)
    header3:SetTextColor(0.64, 0.21, 0.93)
    
    rightLayout.y = rightLayout.y - 30

        rightLayout:dropdown("TextVisibilityMode", locales["TEXT_VISIBILITY_MODE"] or "Modo de visibilidad",
        {
            { label = locales["FOCUS_MODE"], value = "FOCUS" },
            { label = locales["GRID_DYNAMIC"], value = "GRID" },
            -- { label = locales["NONE"], value = "NONE" }
        },
        function() return profile.blockTextMode or "FOCUS" end,
        function(v) 
            profile.blockTextMode = v
            ascensionBars:updateDisplay()
            if panel.updateLayout then panel:updateLayout() end
        end,
        colWidth - 20, col2X)

    if profile.blockTextMode == "FOCUS" then
        rightLayout:slider("FocusDimAlphaSlider", locales["DIM_ALPHA"] or "Atenuación", 0, 100, 5,
            function() return (profile.focusDimAlpha or 0.2) * 100 end,
            function(v) 
                profile.focusDimAlpha = v / 100
                ascensionBars:updateDisplay()
            end, colWidth - 20, col2X)
    elseif profile.blockTextMode == "GRID" then
        rightLayout:slider("DynamicGridGapSlider", locales["DYNAMIC_GRID_GAP"] or "Espaciado de cuadrícula", 0, 50, 1,
            function() return profile.dynamicGridGap or 2 end,
            function(v)
                profile.dynamicGridGap = v
                ascensionBars:updateDisplay()
            end, colWidth - 20, col2X)
    end
    
    -- Spacing before next header
    rightLayout.y = rightLayout.y - 20

    -- -- Header 4: Events & Visibility
    -- local header4 = content:CreateFontString(nil, "OVERLAY", menuStyle.labelFont)
    -- header4:SetPoint("TOPLEFT", col2X - 5, rightLayout.y)
    -- header4:SetWidth(colWidth)
    -- header4:SetJustifyH("CENTER")
    -- header4:SetText(locales["EVENTS_VISIBILITY"])
    -- header4:SetFont(fontPath, 20, outline)
    -- header4:SetTextColor(0.64, 0.21, 0.93)
    
    -- rightLayout.y = rightLayout.y - 30

    -- rightLayout:checkbox("EnableCarouselToggle", locales["ENABLE_CAROUSEL"], nil,
    --     function() return profile.carouselEnabled end,
    --     function(v) profile.carouselEnabled = v; ascensionBars:updateDisplay() end, col2X)
        
    -- rightLayout:checkbox("LegendEnabledToggle", locales["LATERAL_LEGEND"], nil,
    --     function() return profile.legendEnabled end,
    --     function(v) profile.legendEnabled = v; ascensionBars:updateDisplay() end, col2X)
        
    -- rightLayout:slider("BackgroundAlphaSlider", locales["REST_OPACITY"], 0, 100, 5,
    --     function() return (profile.backgroundAlpha or 0.5) * 100 end,
    --     function(v) 
    --         profile.backgroundAlpha = v / 100 
    --         ascensionBars:updateDisplay() 
    --     end, colWidth - 20, col2X)

    -- if rightLayout.y < maxColumnY then maxColumnY = rightLayout.y end

    -- content:SetHeight(math.abs(maxColumnY) + 20)
end