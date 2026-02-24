-------------------------------------------------------------------------------
-- Project: AscensionBars
-- Author: Aka-DoctorCode
-- File: Constants.lua
-- Version: 25
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
        barHeightXP = 6,
        barHeightRep = 6,
        barHeightHouse = 6,
        textHeight = 15,
        textSize = 12,
        yOffset = -2,
        paragonTextSize = 14,
        paragonTextYOffset = -100,
        houseRewardTextYOffset = -60,
        paragonOnTop = false,
        splitParagonText = false,
        paragonTextGap = 5,
        paragonPendingColor = { r = 0, g = 1, b = 0, a = 1.0 }, -- #00FF00
        showOnMouseover = false,
        hideInCombat = false,
        hideAtMaxLevel = true,
        useClassColorXP = true,
        xpBarColor = { r = 0.0, g = 0.4, b = 0.9, a = 1.0 },           -- #0066E6
        showRestedBar = true,
        restedBarColor = { r = 0.6, g = 0.4, b = 0.8, a = 1.0 },       -- #9966CC
        useReactionColorRep = true,
        repBarColor = { r = 0.0, g = 1.0, b = 0.0, a = 1.0 },          -- #00FF00
        textColor = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 },            -- #FFFFFF
        repColors = {
            [1] = { r = 0.8, g = 0.133, b = 0.133, a = 1.0 },          -- #CC2222
            [2] = { r = 1.0, g = 0.0, b = 0.0, a = 1.0 },              -- #FF0000
            [3] = { r = 0.933, g = 0.4, b = 0.133, a = 1.0 },          -- #EE6622
            [4] = { r = 1.0, g = 1.0, b = 0.0, a = 1.0 },              -- #FFFF00
            [5] = { r = 0.0, g = 1.0, b = 0.0, a = 1.0 },              -- #00FF00
            [6] = { r = 0.0, g = 1.0, b = 0.533, a = 1.0 },            -- #00FF88
            [7] = { r = 0.0, g = 1.0, b = 0.8, a = 1.0 },              -- #00FFCC
            [8] = { r = 0.0, g = 1.0, b = 1.0, a = 1.0 },              -- #00FFFF
            [9] = { r = 0.858, g = 0.733, b = 0.008, a = 1.0 },        -- #DBBB02
            [10] = { r = 0.639, g = 0.208, b = 0.933, a = 1.0 },       -- #A335EE
            [11] = { r = 0.255, g = 0.412, b = 0.882, a = 1.0 },       -- #4169E1
        },
        houseRewardTextColor = { r = 0.9, g = 0.5, b = 0.0, a = 1.0 }, -- #E68000
        showPercentage = true,
        showAbsoluteValues = true,
        fontOutline = "OUTLINE",
        honorBarEnabled = false,
        houseXpBarEnabled = false,
        monitoredHouseId = 0,
        artifactBarEnabled = false,
        honorColor = { r = 0.8, g = 0.2, b = 0.2, a = 1.0 },    -- #CC3333
        houseXpColor = { r = 0.9, g = 0.5, b = 0.0, a = 1.0 },  -- #E68000
        artifactColor = { r = 0.9, g = 0.8, b = 0.5, a = 1.0 }, -- #E6CC80
        sparkEnabled = true,
        animationSpeed = 1.0,
        backgroundAlpha = 0.5,
        barGap = 2,
        barAnchor = "TOP",
        textGap = 13.5,
    }
}

AB.constants = {
    TEXTURE_BAR = "Interface\\Buttons\\WHITE8X8",
    TEXTURE_SPARK = "Interface\\CastingBar\\UI-CastingBar-Spark",
    UPDATE_THROTTLE = 0.1,
    DEFAULT_GAP = 30,
    MIN_TEXT_WIDTH = 100,
    ANCHOR_POINTS = {
        TOP = "TOP",
        BOTTOM = "BOTTOM",
        LEFT = "LEFT",
        RIGHT = "RIGHT",
        CENTER = "CENTER"
    },
    MAX_BAR_HEIGHT = 50,
    MIN_BAR_HEIGHT = 1,
    MAX_TEXT_SIZE = 24,
    MIN_TEXT_SIZE = 8,
}
