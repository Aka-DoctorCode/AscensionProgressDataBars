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

    local layout = addonTable.layoutModel:new(content, -15)

    -- Experience Section
    layout:header("ExperienceHeader", locales["EXPERIENCE"])
    
    layout:checkbox("UseClassColorXPCheckbox", locales["USE_CLASS_COLOR"], nil,
        function() return profile.useClassColorXP end,
        function(v)
            profile.useClassColorXP = v
            ascensionBars:updateDisplay()
            if panel.updateLayout then panel:updateLayout() end
        end)
        
    if not profile.useClassColorXP then
        layout:colorPicker("CustomXPColorPicker", locales["CUSTOM_XP_COLOR"],
            function()
                local c = profile.xpBarColor
                return c.r, c.g, c.b, c.a
            end,
            function(r, g, b, a)
                if not profile.xpBarColor then profile.xpBarColor = {} end
                local c = profile.xpBarColor
                c.r = r
                c.g = g
                c.b = b
                c.a = a
                ascensionBars:updateDisplay()
            end,
            25, true)
    end
    
    layout:checkbox("ShowRestedBarCheckbox", locales["SHOW_RESTED_BAR"], nil,
        function() return profile.showRestedBar end,
        function(v)
            profile.showRestedBar = v
            ascensionBars:updateDisplay()
            if panel.updateLayout then panel:updateLayout() end
        end)
        
    if profile.showRestedBar then
        layout:colorPicker("RestedColorPicker", locales["RESTED_COLOR"],
            function()
                local c = profile.restedBarColor
                return c.r, c.g, c.b, c.a
            end,
            function(r, g, b, a)
                if not profile.restedBarColor then profile.restedBarColor = {} end
                local c = profile.restedBarColor
                c.r = r
                c.g = g
                c.b = b
                c.a = a
                ascensionBars:updateDisplay()
            end,
            25, true)
    end

    -- Reputation Section
    layout:header("ReputationHeader", locales["REPUTATION"])
    
    layout:checkbox("UseReactionColorsCheckbox", locales["USE_REACTION_COLORS"], nil,
        function() return profile.useReactionColorRep end,
        function(v)
            profile.useReactionColorRep = v
            ascensionBars:updateDisplay()
            if panel.updateLayout then panel:updateLayout() end
        end)
        
    if not profile.useReactionColorRep then
        layout:colorPicker("CustomRepColorPicker", locales["CUSTOM_REP_COLOR"],
            function()
                local c = profile.repBarColor
                return c.r, c.g, c.b, c.a
            end,
            function(r, g, b, a)
                if not profile.repBarColor then profile.repBarColor = {} end
                local c = profile.repBarColor
                c.r = r
                c.g = g
                c.b = b
                c.a = a
                ascensionBars:updateDisplay()
            end,
            25, true)
    else
        local standingLabels = {
            locales["HATED"], locales["HOSTILE"], locales["UNFRIENDLY"], locales["NEUTRAL"],
            locales["FRIENDLY"], locales["HONORED"], locales["REVERED"], locales["EXALTED"],
            locales["PARAGON"], locales["MAXED"], locales["RENOWN"]
        }
        local startY = layout.y        
        layout:beginSection()
        for i = 1, 11 do
            local colIdx = (i - 1) % 2
            local xOff = 16 + (colIdx * 184)
            
            layout:colorPicker(
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
                xOff,
                true
            )
            
            if colIdx == 0 then 
                layout.y = layout.y + (menuStyle.colorPickerSpacing or 20)
            end
        end
        
        layout:endSection()
    end

    -- Honor Section
    layout:header("HonorHeader", locales["HONOR"])
    
    layout:colorPicker("HonorColorPicker", locales["HONOR_COLOR"],
        function()
            local c = profile.honorColor
            if not c then return 0.8, 0.2, 0.2, 1 end -- #CC3333
            return c.r, c.g, c.b, c.a
        end,
        function(r, g, b, a)
            if not profile.honorColor then profile.honorColor = {} end
            local c = profile.honorColor
            c.r = r
            c.g = g
            c.b = b
            c.a = a
            ascensionBars:updateDisplay()
        end,
        15, true)

    -- House Favor Section
    layout:header("HouseFavorHeader", locales["HOUSE_FAVOR"])
    
    layout:colorPicker("HouseXPColorPicker", locales["HOUSE_XP_COLOR"],
        function()
            local c = profile.houseXpColor
            if not c then return 0.9, 0.5, 0, 1 end -- #E68000
            return c.r, c.g, c.b, c.a
        end,
        function(r, g, b, a)
            if not profile.houseXpColor then profile.houseXpColor = {} end
            local c = profile.houseXpColor
            c.r = r
            c.g = g
            c.b = b
            c.a = a
            ascensionBars:updateDisplay()
        end,
        15, true)
        
    layout:colorPicker("HouseRewardColorPicker", locales["HOUSE_REWARD_COLOR"],
        function()
            local c = profile.houseRewardTextColor
            if not c then return 0.9, 0.5, 0, 1 end -- #E68000
            return c.r, c.g, c.b, c.a
        end,
        function(r, g, b, a)
            if not profile.houseRewardTextColor then profile.houseRewardTextColor = {} end
            local c = profile.houseRewardTextColor
            c.r = r
            c.g = g
            c.b = b
            c.a = a
            ascensionBars:updateDisplay()
        end,
        15, true)
        
    layout:slider("HouseRewardYOffsetSlider", locales["HOUSE_REWARD_Y_OFFSET"], -1000, 500, 5,
        function() return profile.houseRewardTextYOffset or -40 end,
        function(v)
            profile.houseRewardTextYOffset = v
            ascensionBars:updateDisplay()
        end,
        180, 15)

    -- Azerite Section
    layout:header("AzeriteHeader", locales["AZERITE"])
    
    layout:colorPicker("AzeriteColorPicker", locales["AZERITE_COLOR"],
        function()
            local c = profile.azeriteColor
            if not c then return 0.9, 0.8, 0.5, 1 end -- #E6CC80
            return c.r, c.g, c.b, c.a
        end,
        function(r, g, b, a)
            if not profile.azeriteColor then profile.azeriteColor = {} end
            local c = profile.azeriteColor
            c.r = r
            c.g = g
            c.b = b
            c.a = a
            ascensionBars:updateDisplay()
        end,
        15, true)

    content:SetHeight(math.abs(layout.y) + 20)
end