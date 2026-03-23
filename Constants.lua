-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
-- Author: Aka-DoctorCode
-- File: Constants.lua
-- Version: @project-version@
-------------------------------------------------------------------------------
-- Copyright (c) 2025–2026 Aka-DoctorCode. All Rights Reserved.
--
-- This software and its source code are the exclusive property of the author.
-- No part of this file may be copied, modified, redistributed, or used in
-- derivative works without express written permission.
-------------------------------------------------------------------------------

local addonName, _ = ...
---@type AscensionBars
local ascensionBars = LibStub("AceAddon-3.0"):GetAddon(addonName)
---@cast ascensionBars AscensionBars

-------------------------------------------------------------------------------
-- Default profile
-------------------------------------------------------------------------------

ascensionBars.defaults = {
    profile = {
        textSize = 14,
        yOffset = -2,
        backgroundAlpha = 0.8,
        barGap = 2,
        globalBarHeight = 6,
        textGap = 13.5,
        textYOffset = -12,
        fontOutline = "OUTLINE",
        hideInCombat = false,
        hideAtMaxLevel = true,
        showOnMouseover = false,
        showPercentage = true,
        showAbsoluteValues = true,
        useCompactFormat = false,
        useDecimals = true,
        useClassColorXP = true,
        sparkEnabled = true,
        usePerBlockHeights = false,
        barAnchor = "TOP",
        textColor = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 }, -- #FFFFFF
        blockTextMode = "FOCUS",       -- "FOCUS" | "GRID" | "NONE"
        dynamicGridGap = 2,
        focusFadeEnabled = true,
        focusDimAlpha = 0.4,
        legendEnabled = false,
        carouselEnabled = false,
        carouselBatchDelay = 2,
        carouselRotateInterval = 5,
        elementStyles = {
            ["AlertStylingHeader"] = {
                contentPadding = 0,
            },
        },
        customGrids = {
            TOP = {
                enabled = false,
                numRows = 1,
                colsPerRow = { 1 },
                assignments = {
                    [1] = { [1] = "none" }
                }
            },
            BOTTOM = {
                enabled = false,
                numRows = 1,
                colsPerRow = { 1 },
                assignments = {
                    [1] = { [1] = "none" }
                }
            }
        },
        bars = {
            ["XP"] = {
                enabled = true,
                block = "TOP",
                order = 1,
                freeX = 0,
                freeY = 0,
                freeWidth = 500,
                freeHeight = 6,
                useCustomFont = false,
                customFontPath = nil,
                useCustomTextSize = false,
                customTextSize = 14,
                useCustomTextColor = false,
                customTextColor = { r = 1, g = 1, b = 1, a = 1 }
            },
            ["Rep"] = {
                enabled = true,
                block = "TOP",
                order = 1,
                freeX = 0,
                freeY = -20,
                freeWidth = 500,
                freeHeight = 6,
                useCustomFont = false,
                customFontPath = nil,
                useCustomTextSize = false,
                customTextSize = 14,
                useCustomTextColor = false,
                customTextColor = { r = 1, g = 1, b = 1, a = 1 }
            },
            ["Honor"] = {
                enabled = false,
                block = "TOP",
                order = 2,
                freeX = 0,
                freeY = -40,
                freeWidth = 500,
                freeHeight = 6,
                useCustomFont = false,
                customFontPath = nil,
                useCustomTextSize = false,
                customTextSize = 14,
                useCustomTextColor = false,
                customTextColor = { r = 1, g = 1, b = 1, a = 1 }
            },
            ["HouseXp"] = {
                enabled = false,
                block = "TOP",
                order = 2,
                freeX = 0,
                freeY = -60,
                freeWidth = 500,
                freeHeight = 6,
                useCustomFont = false,
                customFontPath = nil,
                useCustomTextSize = false,
                customTextSize = 14,
                useCustomTextColor = false,
                customTextColor = { r = 1, g = 1, b = 1, a = 1 }
            },
            ["Azerite"] = {
                enabled = false,
                block = "FREE",
                order = 1,
                freeX = 0,
                freeY = -80,
                freeWidth = 500,
                freeHeight = 6,
                useCustomFont = false,
                customFontPath = nil,
                useCustomTextSize = false,
                customTextSize = 14,
                useCustomTextColor = false,
                customTextColor = { r = 1, g = 1, b = 1, a = 1 }
            },
        },
        showRestedBar = true,
        xpBarColor = { r = 0.0, g = 0.4, b = 0.9, a = 1.0 }, -- #0066E6
        restedBarColor = { r = 0.6, g = 0.4, b = 0.8, a = 1.0 }, -- #9966CC
        useReactionColorRep = true,
        repBarColor = { r = 0.0, g = 1.0, b = 0.0, a = 1.0 }, -- #00FF00
        repColors = {
            [1] = { r = 0.8, g = 0.133, b = 0.133, a = 1.0 }, -- #CC2222
            [2] = { r = 1.0, g = 0.0, b = 0.0, a = 1.0 }, -- #FF0000
            [3] = { r = 0.933, g = 0.4, b = 0.133, a = 1.0 }, -- #EE6622
            [4] = { r = 1.0, g = 1.0, b = 0.0, a = 1.0 }, -- #FFFF00
            [5] = { r = 0.0, g = 1.0, b = 0.0, a = 1.0 }, -- #00FF00
            [6] = { r = 0.0, g = 1.0, b = 0.533, a = 1.0 }, -- #00FF88
            [7] = { r = 0.0, g = 1.0, b = 0.8, a = 1.0 }, -- #00FFCC
            [8] = { r = 0.0, g = 1.0, b = 1.0, a = 1.0 }, -- #00FFFF
            [9] = { r = 0.858, g = 0.733, b = 0.008, a = 1.0 }, -- #DBBA02
            [10] = { r = 0.639, g = 0.208, b = 0.933, a = 1.0 }, -- #A335EE
            [11] = { r = 0.255, g = 0.412, b = 0.882, a = 1.0 }, -- #4169E1
        },
        paragonTextSize = 18,
        paragonTextYOffset = -100,
        splitParagonText = false,
        paragonOnTop = false,
        paragonPendingColor = { r = 0, g = 1, b = 0, a = 1.0 }, -- #00FF00
        houseRewardTextYOffset = -60,
        houseXpBarEnabled = false,
        houseXpColor = { r = 0.9, g = 0.5, b = 0.0, a = 1.0 }, -- #E68000        
        houseRewardTextColor = { r = 1, g = 0.5, b = 0.1, a = 1.0 }, -- #FF801A
        azeriteBarEnabled = false,
        azeriteColor = { r = 0.9, g = 0.8, b = 0.5, a = 1.0 }, -- #E6D180
        honorBarEnabled = false,
        honorColor = { r = 0.8, g = 0.2, b = 0.2, a = 1.0 }, -- #CC3333
        housingCache = {
            lastTrackedGuid = "",
            houses = {},
        },
        carouselXOffset = 0,
        carouselYOffset = -50,
        carouselBgAlpha = 0.4,
    },
    global = {
        paragonRewards = {},
    }
}

ascensionBars.constants = {
    TEXTURE_BAR = "Interface\\Buttons\\WHITE8X8",
    TEXTURE_SPARK = "Interface\\CastingBar\\UI-CastingBar-Spark",
    UPDATE_THROTTLE = 0.1,
    DEFAULT_GAP = 30,
    MIN_BAR_HEIGHT = 1,
    MAX_BAR_HEIGHT = 50,
    MIN_TEXT_WIDTH = 100,
    MIN_TEXT_SIZE = 8,
    MAX_TEXT_SIZE = 24,
}


-- UI State Management variables
ascensionBars.configFrame = nil
ascensionBars.isMinimized = false
ascensionBars.normalWidth = 850
ascensionBars.normalHeight = 500
ascensionBars.activeTab = 1
ascensionBars.tabs = {}
ascensionBars.panels = {}
