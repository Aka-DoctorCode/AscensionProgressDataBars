-------------------------------------------------------------------------------
-- Project: AscensionBars
-- Author: Aka-DoctorCode
-- File: Colors.lua
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

-- Shared utilities mapped from the main table
local colors = ascensionBars.colors
local menuStyle = ascensionBars.menuStyle

-- Object-Oriented module for the Colors Tab
addonTable.colorsTab = {}
local colorsTab = addonTable.colorsTab

function colorsTab:build(panel)
    if not panel or not panel.content then return end
    
    addonTable.configUtils:cleanupContent(panel.content)
    
    local content = panel.content
    local profile = ascensionBars.db.profile
    if not profile then return end

    -- UX IMPROVEMENT: 2-Column Layout Calculations
    local defaultAvailableSpace = (ascensionBars.normalWidth or 750) - (menuStyle.sidebarWidth or 150) - 30
    local colGap = 15
    local colWidth = (defaultAvailableSpace - colGap) / 2

    local col1X = 10
    local col2X = 10 + colWidth + colGap
    local startY = -15
    
    -- Independent Layout Models for the 2 columns
    local col1Layout = addonTable.layoutModel:new(content, startY)
    local col2Layout = addonTable.layoutModel:new(content, startY)

    -- Helper to safely trigger layout reflows when checking boxes
    local function triggerLayoutUpdate()
        if panel.updateLayout then
            _G.C_Timer.After(0.01, function() panel:updateLayout() end)
        end
    end

    ---------------------------------------------------------------------------
    -- COLUMN 1: Experience, House Favor, Honor & Azerite
    ---------------------------------------------------------------------------
    local inner1X = col1X + 5
    local picker1X = inner1X + 5
    
    
    -- 1. Experience Card
    col1Layout:beginSection(col1X, colWidth)
    col1Layout:label("ExperienceHeader", locales["EXPERIENCE"], inner1X, colors.gold)
    
    col1Layout:checkbox("UseClassColorXPCheckbox", locales["USE_CLASS_COLOR"], nil,
        function() return profile.useClassColorXP end,
        function(v)
            profile.useClassColorXP = v
            ascensionBars:updateDisplay()
            triggerLayoutUpdate()
        end, inner1X - 6)
        
    if not profile.useClassColorXP then
        col1Layout:colorPicker("CustomXPColorPicker", locales["CUSTOM_XP_COLOR"],
            function()
                local c = profile.xpBarColor
                return c.r, c.g, c.b, c.a
            end,
            function(r, g, b, a)
                if not profile.xpBarColor then profile.xpBarColor = {} end
                local c = profile.xpBarColor
                c.r = r; c.g = g; c.b = b; c.a = a
                ascensionBars:updateDisplay()
            end, picker1X, true)
    end
    
    col1Layout:checkbox("ShowRestedBarCheckbox", locales["SHOW_RESTED_BAR"], nil,
        function() return profile.showRestedBar end,
        function(v)
            profile.showRestedBar = v
            ascensionBars:updateDisplay()
            triggerLayoutUpdate()
        end, inner1X - 6)
        
    if profile.showRestedBar then
        col1Layout:colorPicker("RestedColorPicker", locales["RESTED_COLOR"],
            function()
                local c = profile.restedBarColor
                return c.r, c.g, c.b, c.a
            end,
            function(r, g, b, a)
                if not profile.restedBarColor then profile.restedBarColor = {} end
                local c = profile.restedBarColor
                c.r = r; c.g = g; c.b = b; c.a = a
                ascensionBars:updateDisplay()
            end, picker1X, true)
    end
    col1Layout.y = col1Layout.y - 12 -- Extra bottom padding to ensure card encapsulates content
    col1Layout:endSection()
    col1Layout.y = col1Layout.y - 15 -- Gap between cards

    -- 2. House Favor Card
    col1Layout:beginSection(col1X, colWidth)
    col1Layout:label("HouseFavorHeader", locales["HOUSE_FAVOR"], inner1X, colors.gold)
    col1Layout.y = col1Layout.y - 8
    
    col1Layout:colorPicker("HouseXPColorPicker", locales["HOUSE_XP_COLOR"],
        function()
            local c = profile.houseXpColor
            if not c then return 0.9, 0.5, 0, 1 end -- #E68000
            return c.r, c.g, c.b, c.a
        end,
        function(r, g, b, a)
            if not profile.houseXpColor then profile.houseXpColor = {} end
            local c = profile.houseXpColor
            c.r = r; c.g = g; c.b = b; c.a = a
            ascensionBars:updateDisplay()
        end, picker1X, true)
        
    col1Layout.y = col1Layout.y - 12
    col1Layout:endSection()
    col1Layout.y = col1Layout.y - 15

    -- 3. Honor Card
    col1Layout:beginSection(col1X, colWidth)
    col1Layout:label("HonorHeader", locales["HONOR"], inner1X, colors.gold)
    col1Layout.y = col1Layout.y - 8
    
    col1Layout:colorPicker("HonorColorPicker", locales["HONOR_COLOR"],
        function()
            local c = profile.honorColor
            if not c then return 0.8, 0.2, 0.2, 1 end -- #CC3333
            return c.r, c.g, c.b, c.a
        end,
        function(r, g, b, a)
            if not profile.honorColor then profile.honorColor = {} end
            local c = profile.honorColor
            c.r = r; c.g = g; c.b = b; c.a = a
            ascensionBars:updateDisplay()
        end, picker1X, true)
        
    col1Layout.y = col1Layout.y - 12
    col1Layout:endSection()
    col1Layout.y = col1Layout.y - 15

    -- 4. Azerite Card
    col1Layout:beginSection(col1X, colWidth)
    col1Layout:label("AzeriteHeader", locales["AZERITE"], inner1X, colors.gold)
    col1Layout.y = col1Layout.y - 8
    
    col1Layout:colorPicker("AzeriteColorPicker", locales["AZERITE_COLOR"],
        function()
            local c = profile.azeriteColor
            if not c then return 0.9, 0.8, 0.5, 1 end -- #E6CC80
            return c.r, c.g, c.b, c.a
        end,
        function(r, g, b, a)
            if not profile.azeriteColor then profile.azeriteColor = {} end
            local c = profile.azeriteColor
            c.r = r; c.g = g; c.b = b; c.a = a
            ascensionBars:updateDisplay()
        end, picker1X, true)
        
    col1Layout.y = col1Layout.y - 12
    col1Layout:endSection()

    ---------------------------------------------------------------------------
    -- COLUMN 2: Reputation (Long Vertical Card to balance the layout)
    ---------------------------------------------------------------------------
    local inner2X = col2X + 5
    local picker2X = inner2X + 6
    
    col2Layout:beginSection(col2X, colWidth)
    col2Layout:label("ReputationHeader", locales["REPUTATION"], inner2X, colors.gold)
    
    col2Layout:checkbox("UseReactionColorsCheckbox", locales["USE_REACTION_COLORS"], nil,
        function() return profile.useReactionColorRep end,
        function(v)
            profile.useReactionColorRep = v
            ascensionBars:updateDisplay()
            triggerLayoutUpdate()
        end, inner2X - 6)
        
    if not profile.useReactionColorRep then
        col2Layout:colorPicker("CustomRepColorPicker", locales["CUSTOM_REP_COLOR"],
            function()
                local c = profile.repBarColor
                return c.r, c.g, c.b, c.a
            end,
            function(r, g, b, a)
                if not profile.repBarColor then profile.repBarColor = {} end
                local c = profile.repBarColor
                c.r = r; c.g = g; c.b = b; c.a = a
                ascensionBars:updateDisplay()
            end, picker2X, true)
    else
        local standingLabels = {
            locales["HATED"], locales["HOSTILE"], locales["UNFRIENDLY"], locales["NEUTRAL"],
            locales["FRIENDLY"], locales["HONORED"], locales["REVERED"], locales["EXALTED"],
            locales["PARAGON"], locales["MAXED"], locales["RENOWN"]
        }
        -- Simple straight vertical list for standings
        for i = 1, 11 do
            col2Layout:colorPicker(
                "RepStandingColorPicker_" .. i,
                standingLabels[i] or string.format(locales["RANK_NUM"], i),
                function()
                    local c = profile.repColors[i] or {r = 1, g = 1, b = 1, a = 1} -- #FFFFFF
                    return c.r, c.g, c.b, c.a
                end,
                function(r, g, b, a)
                    profile.repColors[i] = {r = r, g = g, b = b, a = a}
                    ascensionBars:updateDisplay()
                end,
                picker2X, true)
        end
    end
    col2Layout.y = col2Layout.y - 12 -- Extra bottom padding
    col2Layout:endSection()

    -- Calculate the lowest Y point between the 2 columns to set the canvas height
    local maxBottomY = math.min(col1Layout.y, col2Layout.y)
    content:SetHeight(math.abs(maxBottomY) + 20)
end