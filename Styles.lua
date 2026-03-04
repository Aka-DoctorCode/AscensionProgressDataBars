-------------------------------------------------------------------------------
-- Project: AscensionBars
-- Author: Aka-DoctorCode
-- File: Styles.lua
-- Version: V31
-------------------------------------------------------------------------------
-- Copyright (c) 2025–2026 Aka-DoctorCode. All Rights Reserved.
--
-- This software and its source code are the exclusive property of the author.
-- No part of this file may be copied, modified, redistributed, or used in
-- derivative works without express written permission.
-------------------------------------------------------------------------------

local addonName, addonTable = ...
local ascensionBars = LibStub("AceAddon-3.0"):GetAddon(addonName)
---@class AscensionBars
---@cast ascensionBars AscensionBars

-------------------------------------------------------------------------------
-- CONSTANTS & colors
-------------------------------------------------------------------------------

ascensionBars.colors = {
    primary           = { 0.498, 0.075, 0.925, 1.0 },  -- #7F13EC
    gold              = { 1.000, 0.800, 0.200, 1.0 },  -- #FFCC33
    background_dark   = { 0.020, 0.020, 0.031, 0.95 }, -- #050508
    surface_dark      = { 0.047, 0.039, 0.082, 1.0 },  -- #0C0A15
    surface_highlight = { 0.165, 0.141, 0.239, 1.0 },  -- #2A243D
    black_detail      = { 0.0, 0.0, 0.0, 1.0 },        -- #000000
    white_detail      = { 1.0, 1.0, 1.0, 1.0 },        -- #FFFFFF
    text_light        = { 0.886, 0.910, 0.941, 1.0 },  -- #E2E8F0
    text_dim          = { 0.580, 0.640, 0.720, 1.0 },  -- #94A3B7
    sidebar_bg        = { 0.10, 0.10, 0.10, 0.95 },    -- #1A1A1A
    sidebar_hover     = { 0.20, 0.20, 0.20, 0.5 },     -- #333333
    sidebar_accent    = { 0.00, 0.48, 1.00, 0.95 },    -- #007AFF
    sidebar_active    = { 0.00, 0.40, 1.00, 0.2 },     -- #0066FF
}

ascensionBars.files = {
    bgfile   = "Interface\\ChatFrame\\ChatFrameBackground",
    edgefile = "Interface\\Tooltips\\UI-Tooltip-Border",
    arrow    = "Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Up",
    close    = "Interface\\Buttons\\UI-Panel-CloseButton",
    maximize = "Interface\\Buttons\\ui-panel-hidebutton-up",
    minimize = "Interface\\Buttons\\ui-panel-hidebutton-disabled",
}

ascensionBars.menuStyle = {
    -- Structural
    sidebarWidth = 160,
    contentPadding = 15,
    headerSpacing = 25,
    labelSpacing = 20,
    dividerSpacing = 4,
    titleTop = -15,
    titleLeft = 15,
    separatorTop = -40,
    separatorSideMargin = 10,
    checkboxSize = 30,
    checkboxSpacing = 30,
    sliderWidth = 180,
    sliderSpacing = 75,
    dropdownWidth = 120,
    dropdownHeight = 40,
    colorPickerSize = 20,
    colorPickerSpacing = 35,
    uiHeaderSize = 18,
    uiLabelSize = 12,
    uiHeaderColor = { 1.000, 0.800, 0.200, 1.0 },     -- #FFCC33
    uiBackgroundColor = { 0.020, 0.020, 0.031, 0.95 } -- #050508
}
