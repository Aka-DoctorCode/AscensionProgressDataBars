-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
-- Author: Aka-DoctorCode
-- File: Constants.lua
-------------------------------------------------------------------------------
---@diagnostic disable: undefined-global, undefined-field, inject-field

local addonName, _ = ...
local ascensionBars = LibStub("AceAddon-3.0"):GetAddon(addonName)

-------------------------------------------------------------------------------
-- Default profile
-------------------------------------------------------------------------------

ascensionBars.defaults = {
    profile = {
        -- -------------------------------------------------------------------------------
        -- GENERAL APPEARANCE
        -- -------------------------------------------------------------------------------
        globalBarHeight = 6,          -- Default height of bars (if not per-block)
        barGap = 2,                   -- Gap between bars (global)
        backgroundAlpha = 0.8,        -- Alpha for bar background texture
        barAnchor = "TOP",            -- Which block appears first (TOP or BOTTOM)
        sparkEnabled = true,          -- Show spark at progress edge

        -- -------------------------------------------------------------------------------
        -- TEXT & FONT
        -- -------------------------------------------------------------------------------
        textSize = 14,                -- Global text size
        textColor = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 }, -- #FFFFFF
        fontOutline = "OUTLINE",      -- Font outline style
        textYOffset = -12,            -- Global text Y offset relative to bar
        textGap = 13.5,               -- Legacy, kept for compatibility

        -- -------------------------------------------------------------------------------
        -- LAYOUT OFFSETS & GAPS (Global)
        -- -------------------------------------------------------------------------------
        yOffset = -2,                 -- Global Y offset for bars (negative for TOP, positive for BOTTOM)

        -- -------------------------------------------------------------------------------
        -- BEHAVIOR SETTINGS
        -- -------------------------------------------------------------------------------
        hideInCombat = false,         -- Hide bars during combat
        hideAtMaxLevel = true,        -- Hide XP bar when at max level
        showOnMouseover = false,      -- Only show bars when mouse is over them
        focusFadeEnabled = true,      -- Fade non‑focused bars when hovering
        focusDimAlpha = 0.4,          -- Alpha for non‑focused bars
        blockTextMode = "FOCUS",      -- "FOCUS" | "GRID" | "NONE"
        useCompactFormat = false,     -- Show compact numbers (e.g., 1.2k)
        useDecimals = true,           -- Show one decimal place in percentages

        -- -------------------------------------------------------------------------------
        -- PER‑BLOCK CUSTOMIZATION
        -- -------------------------------------------------------------------------------
        usePerBlockHeights = false,   -- Enable separate height per block
        blockHeights = nil,           -- Will be filled at runtime
        usePerBlockOffsets = nil,     -- Not yet used
        usePerBlockGaps = nil,        -- Not yet used
        topOffset = nil,
        bottomOffset = nil,
        topBarGap = nil,
        bottomBarGap = nil,

        -- -------------------------------------------------------------------------------
        -- DISPLAY MODES (Percentage, Absolute)
        -- -------------------------------------------------------------------------------
        showPercentage = true,        -- Show percentage in text
        showAbsoluteValues = true,    -- Show absolute current/max values

        -- -------------------------------------------------------------------------------
        -- ADVANCED CUSTOM GRID
        -- -------------------------------------------------------------------------------
        customGridMasterEnabled = false,   -- Master toggle for custom grid feature
        customGrids = {
            TOP = {
                enabled = false,
                preset = "CUSTOM",
                numRows = 1,
                colsPerRow = { 1 },
                assignments = { [1] = { [1] = "none" } }
            },
            BOTTOM = {
                enabled = false,
                preset = "CUSTOM",
                numRows = 1,
                colsPerRow = { 1 },
                assignments = { [1] = { [1] = "none" } }
            }
        },
        dynamicGridGap = 2,           -- Gap between grid cells

        -- -------------------------------------------------------------------------------
        -- LEGEND & CAROUSEL (Event display)
        -- -------------------------------------------------------------------------------
        legendEnabled = false,
        legendX = -20,
        legendY = 0,
        legendPoint = "RIGHT",
        legendRelativePoint = "RIGHT",
        legendBgAlpha = 0.4,
        legendTextSize = 12,
        legendFontOutline = "OUTLINE",
        carouselEnabled = false,
        carouselBatchDelay = 2,
        carouselRotateInterval = 5,
        carouselXOffset = 0,
        carouselYOffset = -50,
        carouselBgAlpha = 0.4,

        -- -------------------------------------------------------------------------------
        -- BAR SPECIFIC CONFIGURATION (Default settings for built‑in bars)
        -- -------------------------------------------------------------------------------
        bars = {
            ["XP"] = {
                enabled = true,
                block = "TOP",
                order = 1,
                freeX = 0, freeY = 0, freeWidth = 500, freeHeight = 6,
                useCustomFont = false, customFontPath = nil,
                useCustomTextSize = false, customTextSize = 14,
                useCustomTextColor = false,
                customTextColor = { r = 1, g = 1, b = 1, a = 1 } -- #FFFFFF
            },
            ["Rep"] = {
                enabled = true,
                block = "TOP",
                order = 2,
                freeX = 0, freeY = -20, freeWidth = 500, freeHeight = 6,
                useCustomFont = false, customFontPath = nil,
                useCustomTextSize = false, customTextSize = 14,
                useCustomTextColor = false,
                customTextColor = { r = 1, g = 1, b = 1, a = 1 } -- #FFFFFF
            },
            ["Honor"] = {
                enabled = false,
                block = "BOTTOM",
                order = 1,
                freeX = 0, freeY = -40, freeWidth = 500, freeHeight = 6,
                useCustomFont = false, customFontPath = nil,
                useCustomTextSize = false, customTextSize = 14,
                useCustomTextColor = false,
                customTextColor = { r = 1, g = 1, b = 1, a = 1 } -- #FFFFFF
            },
            ["HouseXp"] = {
                enabled = false,
                block = "BOTTOM",
                order = 2,
                freeX = 0, freeY = -60, freeWidth = 500, freeHeight = 6,
                useCustomFont = false, customFontPath = nil,
                useCustomTextSize = false, customTextSize = 14,
                useCustomTextColor = false,
                customTextColor = { r = 1, g = 1, b = 1, a = 1 } -- #FFFFFF
            },
            ["Azerite"] = {
                enabled = false,
                block = "FREE",
                order = 1,
                freeX = 0, freeY = -80, freeWidth = 500, freeHeight = 6,
                useCustomFont = false, customFontPath = nil,
                useCustomTextSize = false, customTextSize = 14,
                useCustomTextColor = false,
                customTextColor = { r = 1, g = 1, b = 1, a = 1 } -- #FFFFFF
            },
        },

        -- -------------------------------------------------------------------------------
        -- XP BAR COLORS
        -- -------------------------------------------------------------------------------
        showRestedBar = true,
        useClassColorXP = true,       -- Use class color for XP bar when available
        xpBarColor = { r = 0.0, g = 0.4, b = 0.9, a = 1.0 }, -- #0066E6
        restedBarColor = { r = 0.6, g = 0.4, b = 0.8, a = 1.0 }, -- #9966CC

        -- -------------------------------------------------------------------------------
        -- REPUTATION BAR
        -- -------------------------------------------------------------------------------
        useReactionColorRep = true,   -- Color by standing (Hated → Exalted)
        repBarColor = { r = 0.0, g = 1.0, b = 0.0, a = 1.0 }, -- #00FF00
        repColors = {
            [1] = { r = 0.8, g = 0.133, b = 0.133, a = 1.0 }, -- #CC2222 (Hated)
            [2] = { r = 1.0, g = 0.0, b = 0.0, a = 1.0 },     -- #FF0000 (Hostile)
            [3] = { r = 0.933, g = 0.4, b = 0.133, a = 1.0 }, -- #EE6622 (Unfriendly)
            [4] = { r = 1.0, g = 1.0, b = 0.0, a = 1.0 },     -- #FFFF00 (Neutral)
            [5] = { r = 0.0, g = 1.0, b = 0.0, a = 1.0 },     -- #00FF00 (Friendly)
            [6] = { r = 0.0, g = 1.0, b = 0.533, a = 1.0 },   -- #00FF88 (Honored)
            [7] = { r = 0.0, g = 1.0, b = 0.8, a = 1.0 },     -- #00FFCC (Revered)
            [8] = { r = 0.0, g = 1.0, b = 1.0, a = 1.0 },     -- #00FFFF (Exalted)
            [9] = { r = 0.858, g = 0.733, b = 0.008, a = 1.0 },-- #DBBA02 (Renown 1)
            [10] = { r = 0.639, g = 0.208, b = 0.933, a = 1.0 },-- #A335EE (Renown 2)
            [11] = { r = 0.255, g = 0.412, b = 0.882, a = 1.0 },-- #4169E1 (Renown 3)
        },

        -- -------------------------------------------------------------------------------
        -- HONOR BAR
        -- -------------------------------------------------------------------------------
        honorBarEnabled = false,
        honorColor = { r = 0.8, g = 0.2, b = 0.2, a = 1.0 }, -- #CC3333

        -- -------------------------------------------------------------------------------
        -- AZERITE BAR
        -- -------------------------------------------------------------------------------
        azeriteBarEnabled = false,
        azeriteColor = { r = 0.9, g = 0.8, b = 0.5, a = 1.0 }, -- #E6CC7F

        -- -------------------------------------------------------------------------------
        -- HOUSE FAVOR BAR
        -- -------------------------------------------------------------------------------
        houseXpBarEnabled = false,
        houseXpColor = { r = 0.9, g = 0.5, b = 0.0, a = 1.0 }, -- #E68000
        houseRewardTextSize = 18,
        houseRewardXOffset = 0,
        houseRewardTextYOffset = -60,
        houseRewardTextColor = { r = 1, g = 0.5, b = 0.1, a = 1.0 }, -- #FF801A

        -- -------------------------------------------------------------------------------
        -- PARAGON ALERTS
        -- -------------------------------------------------------------------------------
        paragonTextSize = 18,
        paragonXOffset = 0,
        paragonYOffset = -100,
        splitParagonText = false,      -- Show each faction on its own line
        paragonPendingColor = { r = 0, g = 1, b = 0, a = 1.0 }, -- #00FF00

        -- -------------------------------------------------------------------------------
        -- DATA CACHES (runtime)
        -- -------------------------------------------------------------------------------
        housingCache = {
            lastTrackedGuid = "",
            houses = {},
        },
    },
    global = {
        paragonRewards = {},
    }
}

-------------------------------------------------------------------------------
-- Constants for internal use
-------------------------------------------------------------------------------

ascensionBars.constants = {
    TEXTURE_BAR = "Interface\\Buttons\\WHITE8X8",
    TEXTURE_SPARK = "Interface\\CastingBar\\UI-CastingBar-Spark",
    UPDATE_THROTTLE = 1,           -- Seconds between forced updates
    DEFAULT_GAP = 30,
    MIN_BAR_HEIGHT = 1,
    MAX_BAR_HEIGHT = 50,
    MIN_TEXT_WIDTH = 100,
    MIN_TEXT_SIZE = 8,
    MAX_TEXT_SIZE = 24,
}

-------------------------------------------------------------------------------
-- UI State Management variables
-------------------------------------------------------------------------------

ascensionBars.configFrame = nil
ascensionBars.isMinimized = false
ascensionBars.normalWidth = 1000
ascensionBars.normalHeight = 500
ascensionBars.activeTab = 1
ascensionBars.tabs = {}
ascensionBars.panels = {}

-------------------------------------------------------------------------------
-- COLOR UTILITIES & ADJACENCY VARIATIONS
-------------------------------------------------------------------------------

--- Converts RGB components (0-1) to HSL (H: 0-360, S: 0-1, L: 0-1).
local function rgbToHSL(r, g, b)
    local max = math.max(r, g, b)
    local min = math.min(r, g, b)
    local h, s, l
    l = (max + min) / 2

    if max == min then
        h = 0
        s = 0
    else
        local d = max - min
        s = l > 0.5 and (d / (2 - max - min)) or (d / (max + min))
        if max == r then
            h = ((g - b) / d) + (g < b and 6 or 0)
        elseif max == g then
            h = ((b - r) / d) + 2
        else
            h = ((r - g) / d) + 4
        end
        h = h * 60
    end
    return h, s, l
end

local function hueToRGB(p, q, t)
    if t < 0 then t = t + 1 end
    if t > 1 then t = t - 1 end
    if t < 1/6 then return p + (q - p) * 6 * t end
    if t < 1/2 then return q end
    if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
    return p
end

--- Converts HSL components (H: 0-360, S: 0-1, L: 0-1) to RGB (0-1).
local function hslToRGB(h, s, l)
    local r, g, b
    if s == 0 then
        r, g, b = l, l, l
    else
        h = h / 360
        local q = l < 0.5 and (l * (1 + s)) or (l + s - l * s)
        local p = 2 * l - q
        r = hueToRGB(p, q, h + 1/3)
        g = hueToRGB(p, q, h)
        b = hueToRGB(p, q, h - 1/3)
    end
    return r, g, b
end

ascensionBars.rgbToHSL = rgbToHSL
ascensionBars.hslToRGB = hslToRGB

--- Returns a color variation for adjacent reputation bars with the same level.
-- Step 0: Base color (unchanged)
-- Step 1: -20% luminosity (darker)
-- Step 2: +15% luminosity (lighter)
function ascensionBars:getRepColorVariation(baseColor, step)
    if not baseColor or not step or step == 0 then
        return baseColor
    end

    local h, s, l = rgbToHSL(baseColor.r or 1, baseColor.g or 1, baseColor.b or 1)
    local newL = l

    if step == 1 then
        -- -20% luminosity
        newL = math.max(0.05, l * 0.80)
    elseif step == 2 then
        -- +15% luminosity
        newL = math.min(0.95, l + (1.0 - l) * 0.15)
    end

    local r, g, b = hslToRGB(h, s, newL)
    return { r = r, g = g, b = b, a = baseColor.a or 1 }
end
