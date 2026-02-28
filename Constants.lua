-------------------------------------------------------------------------------
-- Project: AscensionBars
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
---@type AscensionBars
local AB = LibStub("AceAddon-3.0"):GetAddon("AscensionBars")

AB.defaults = {
    profile = {
        -- GENERAL
        textSize = 14,
        yOffset = -2,
        backgroundAlpha = 0.8,
        barGap = 2,
        globalBarHeight = 6,
        textGap = 13.5,
        fontOutline = "OUTLINE",
        hideInCombat = false,
        hideAtMaxLevel = true,
        showOnMouseover = false,
        showPercentage = true,
        showAbsoluteValues = true,
        useClassColorXP = true,
        sparkEnabled = true,
        barAnchor = "TOP",
        textColor = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 }, -- #FFFFFF
        textGroups = {
            T1 = { detached = false, x = 0, y = -25 },
            T2 = { detached = false, x = 0, y = -50 },
            T3 = { detached = false, x = 0, y = -75 },
        },
        textLayoutMode = "SINGLE_LINE",
        textFollowBar = true,
        bars = {
            ["XP"] = {
                enabled = true,
                block = "TOP",
                order = 1,
                freeX = 0,
                freeY = 0,
                freeWidth = 500,
                freeHeight = 6,
                textX = 0,
                textY = 0,
                textBlock = "T1",
                textOrder = 1
            },
            ["Rep"] = {
                enabled = true,
                block = "TOP",
                order = 2,
                freeX = 0,
                freeY = -20,
                freeWidth = 500,
                freeHeight = 6,
                textX = 0,
                textY = 0,
                textBlock = "T1",
                textOrder = 2
            },
            ["Honor"] = {
                enabled = false,
                block = "TOP",
                order = 3,
                freeX = 0,
                freeY = -40,
                freeWidth = 500,
                freeHeight = 6,
                textX = 0,
                textY = 0,
                textBlock = "T1",
                textOrder = 3
            },
            ["HouseXp"] = {
                enabled = false,
                block = "TOP",
                order = 4,
                freeX = 0,
                freeY = -60,
                freeWidth = 500,
                freeHeight = 6,
                textX = 0,
                textY = 0,
                textBlock = "T1",
                textOrder = 4
            },
            ["Azerite"] = {
                enabled = false,
                block = "TOP",
                order = 5,
                freeX = 0,
                freeY = -80,
                freeWidth = 500,
                freeHeight = 6,
                textX = 0,
                textY = 0,
                textBlock = "T1",
                textOrder = 5
            },
        },
        -- EXPERIENCE
        showRestedBar = true,
        xpBarColor = { r = 0.0, g = 0.4, b = 0.9, a = 1.0 },     -- #0066E6
        restedBarColor = { r = 0.6, g = 0.4, b = 0.8, a = 1.0 }, -- #9966CC
        -- REPUTATION
        useReactionColorRep = true,
        repBarColor = { r = 0.0, g = 1.0, b = 0.0, a = 1.0 },    -- #00FF00
        repColors = {
            [1] = { r = 0.8, g = 0.133, b = 0.133, a = 1.0 },    -- #CC2222
            [2] = { r = 1.0, g = 0.0, b = 0.0, a = 1.0 },        -- #FF0000
            [3] = { r = 0.933, g = 0.4, b = 0.133, a = 1.0 },    -- #EE6622
            [4] = { r = 1.0, g = 1.0, b = 0.0, a = 1.0 },        -- #FFFF00
            [5] = { r = 0.0, g = 1.0, b = 0.0, a = 1.0 },        -- #00FF00
            [6] = { r = 0.0, g = 1.0, b = 0.533, a = 1.0 },      -- #00FF88
            [7] = { r = 0.0, g = 1.0, b = 0.8, a = 1.0 },        -- #00FFCC
            [8] = { r = 0.0, g = 1.0, b = 1.0, a = 1.0 },        -- #00FFFF
            [9] = { r = 0.858, g = 0.733, b = 0.008, a = 1.0 },  -- #DBBB02
            [10] = { r = 0.639, g = 0.208, b = 0.933, a = 1.0 }, -- #A335EE
            [11] = { r = 0.255, g = 0.412, b = 0.882, a = 1.0 }, -- #4169E1
        },
        -- PARAGON
        paragonTextSize = 18,
        paragonTextYOffset = -100,
        splitParagonText = false,
        paragonOnTop = false,
        paragonPendingColor = { r = 0, g = 1, b = 0, a = 1.0 }, -- #00FF00
        -- HOUSING
        houseRewardTextYOffset = -60,
        houseXpBarEnabled = false,
        houseXpColor = { r = 0.9, g = 0.5, b = 0.0, a = 1.0 },         -- #E68000
        houseRewardTextColor = { r = 0.9, g = 0.5, b = 0.0, a = 1.0 }, -- #E68000
        -- ARTIFACT
        azeriteBarEnabled = false,
        azeriteBarColor = { r = 0.9, g = 0.8, b = 0.5, a = 1.0 }, -- #E6CC80
        -- HONOR
        honorBarEnabled = false,
        honorColor = { r = 0.8, g = 0.2, b = 0.2, a = 1.0 }, -- #CC3333
    }
}

AB.constants = {
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
