-------------------------------------------------------------------------------
-- Project: AscensionBars
-- Author: Aka-DoctorCode
-- File: enUS.lua
-- Version: @project-version@
-------------------------------------------------------------------------------
-- Copyright (c) 2025–2026 Aka-DoctorCode. All Rights Reserved.
--
-- This software and its source code are the exclusive property of the author.
-- No part of this file may be copied, modified, redistributed, or used in
-- derivative works without express written permission.
-------------------------------------------------------------------------------

local _, addonTable = ...
local Locales = LibStub("AceLocale-3.0"):NewLocale("AscensionBars", "enUS", true) or
    LibStub("AceLocale-3.0"):NewLocale("AscensionBars", "enGB")

if not Locales then return end

-- General Configuration
Locales["ADDON_NAME"] = "Ascension Bars"
Locales["CONFIG_MODE"] = "Config Mode"
Locales["CONFIG_MODE_DESC"] = "Show dummy bars to visualize changes in real-time."
Locales["FACTION_STANDINGS_RESET"] = "Reset Defaults"
Locales["EMPTY"] = "(Empty)"
Locales["AND"] = " AND "
Locales["CONFIG_MODULE_MISSING"] = "AscensionBars: Configuration module not found."
Locales["TOGGLE_CONFIG_WINDOW"] = "Toggle Config Window"

-- Tabs
Locales["TAB_BARS_LAYOUT"] = "Bars Layout"
Locales["TAB_TEXT_LAYOUT"] = "Text Layout"
Locales["TAB_BEHAVIOR"] = "Behavior"
Locales["TAB_COLORS"] = "Colors"
Locales["TAB_PARAGON_ALERTS"] = "Paragon Alerts"

-- UI Controls & Labels
Locales["ENABLE"] = "Enable"
Locales["ANCHOR"] = "Anchor"
Locales["TOP"] = "Top"
Locales["BOTTOM"] = "Bottom"
Locales["FREE"] = "Free"
Locales["ORDER"] = "Order"
Locales["WIDTH"] = "Width"
Locales["HEIGHT"] = "Height"
Locales["POS_X"] = "Position X"
Locales["POS_Y"] = "Position Y"
Locales["TXT_X"] = "Text X Offset"
Locales["TXT_Y"] = "Text Y Offset"
Locales["GLOBAL_BLOCKS_OFFSET"] = "Global Blocks Offset"
Locales["GLOBAL_BAR_HEIGHT"] = "Global Bar Height"
Locales["GLOBAL_OFFSET"] = "Global Offset"
Locales["BAR_MANAGEMENT"] = "Bar Management"
Locales["TOP_BLOCK"] = "Top Block"
Locales["BOTTOM_BLOCK"] = "Bottom Block"
Locales["FREE_MODE"] = "Free Mode"

-- Experience Bar
Locales["EXPERIENCE"] = "Experience"
Locales["XP_BAR_DATA"] = "Experience Bar Data | 0/0 (0.0%)"
Locales["XP_BAR_CONFIG_TEXT"] = "Experience: 75% (Resting)"
Locales["RESTED_XP"] = "Rested XP"
Locales["LEVEL_TEXT"] = "Level %d"
Locales["LEVEL_TEXT_PCT"] = "%d | %d%%"
Locales["LEVEL_TEXT_ABS"] = "%d | %s / %s"
Locales["LEVEL_TEXT_ABS_PCT"] = "%d | %s / %s (%d%%)"
Locales["RESTED_TEXT"] = " (+%d%%)"

-- Reputation Bar
Locales["REPUTATION"] = "Reputation"
Locales["REP_BAR_DATA"] = "Reputation Bar Data | 0/0 (0.0%)"
Locales["PARAGON"] = "Paragon"
Locales["RENOWN_LEVEL"] = "Renown Level"
Locales["REWARD_PENDING_STATUS"] = "Reward Pending"
Locales["REWARD_PENDING_SINGLE"] = " REWARD PENDING!"
Locales["REWARD_PENDING_PLURAL"] = " REWARDS PENDING!"

-- Reputation Display Patterns
Locales["REP_LABEL_FORMAT"] = "%s (%s)"
Locales["REP_VALUE_FORMAT_FULL"] = "%s / %s (%.1f%%)"
Locales["REP_VALUE_FORMAT_PCT"] = "(%.1f%%)"

-- Honor Bar
Locales["HONOR"] = "Honor"
Locales["ENABLE_HONOR_BAR"] = "Enable Honor Bar"
Locales["HONOR_BAR_DATA"] = "Honor: 0%"
Locales["HONOR_BAR_HEIGHT"] = "Honor Bar Height"
Locales["HONOR_LEVEL_FORMAT"] = "Honor Level %d | %s/%s (%.1f%%)"

-- Azerite Bar
Locales["AZERITE"] = "Azerite"
Locales["ENABLE_AZERITE_BAR"] = "Enable Azerite Bar"
Locales["AZERITE_BAR_DATA"] = "Azerite Power: 0%"
Locales["AZERITE_BAR_HEIGHT"] = "Azerite Bar Height"
Locales["AZERITE_LEVEL_FORMAT"] = "Azerite Level %d | %s/%s (%.1f%%)"

-- Housing Favor Bar
Locales["HOUSE_FAVOR"] = "House Favor"
Locales["ENABLE_HOUSE_XP_BAR"] = "Enable House Favor Bar"
Locales["HOUSE_XP"] = "House Favor"
Locales["HOUSE_BAR_HEIGHT"] = "House Bar Height"
Locales["HOUSE_LEVEL_FORMAT"] = "%s | Lvl %d | %s / %s (%.1f%%)"
Locales["HOUSE_LEVEL_SIMPLE"] = "%s | Level %d"
Locales["HOUSE_UPGRADES_AVAILABLE"] = "HOUSE UPGRADES AVAILABLE FOR %s"

-- Appearance Tab
Locales["TEXT_AND_FONT"] = "Text and Font"
Locales["LAYOUT_MODE"] = "Layout Mode"
Locales["ALL_IN_ONE_LINE"] = "All in one line"
Locales["MULTIPLE_LINES"] = "Multiple lines"
Locales["TEXT_FOLLOWS_BAR"] = "Text follows bar"
Locales["TEXT_FOLLOWS_BAR_DESC"] = "Text Group 1 will follow the position of the lowest active bar."
Locales["FONT_SIZE"] = "Font Size"
Locales["GLOBAL_TEXT_COLOR"] = "Global Text Color"
Locales["TEXT_GROUP_POSITIONS"] = "Text Group Positions"
Locales["DETACH_GROUP"] = "Detach Group %d"
Locales["DETACH_GROUP_DESC"] = "Allow Group %d to be positioned independently."
Locales["GROUP_X"] = "Group %d X Offset"
Locales["GROUP_Y"] = "Group %d Y Offset"
Locales["TEXT_MANAGEMENT"] = "Text Management"
Locales["TEXT_SIZE"] = "Text Size"
Locales["GROUP_1"] = "Group 1"
Locales["GROUP_2"] = "Group 2"
Locales["GROUP_3"] = "Group 3"

-- Behavior Tab
Locales["AUTO_HIDE_LOGIC"] = "Auto-Hide Logic"
Locales["SHOW_ON_MOUSEOVER"] = "Show on Mouseover"
Locales["HIDE_IN_COMBAT"] = "Hide in Combat"
Locales["HIDE_AT_MAX_LEVEL"] = "Hide at Max Level"
Locales["DATA_DISPLAY"] = "Data Display"
Locales["SHOW_PERCENTAGE"] = "Show Percentage"
Locales["SHOW_ABSOLUTE_VALUES"] = "Show Absolute Values"
Locales["SHOW_SPARK"] = "Show Spark"

-- Colors Tab
Locales["USE_CLASS_COLOR"] = "Use Class Color"
Locales["CUSTOM_XP_COLOR"] = "Custom XP Color"
Locales["SHOW_RESTED_BAR"] = "Show Rested Bar"
Locales["RESTED_COLOR"] = "Rested Color"
Locales["USE_REACTION_COLORS"] = "Use Reaction Colors"
Locales["CUSTOM_REP_COLOR"] = "Custom Reputation Color"
Locales["HONOR_COLOR"] = "Honor Color"
Locales["HOUSE_XP_COLOR"] = "House Favor Color"
Locales["HOUSE_REWARD_COLOR"] = "House Reward Text Color"
Locales["HOUSE_REWARD_Y_OFFSET"] = "House Reward Y Offset"
Locales["AZERITE_COLOR"] = "Azerite Color"

-- Reputation Standings
Locales["HATED"] = "Hated"
Locales["HOSTILE"] = "Hostile"
Locales["UNFRIENDLY"] = "Unfriendly"
Locales["NEUTRAL"] = "Neutral"
Locales["FRIENDLY"] = "Friendly"
Locales["HONORED"] = "Honored"
Locales["REVERED"] = "Revered"
Locales["EXALTED"] = "Exalted"
Locales["MAXED"] = "Maxed"
Locales["RENOWN"] = "Renown"
Locales["RANK_NUM"] = "Rank %d"

-- Paragon Alerts
Locales["ALERT_STYLING"] = "Alert Styling"
Locales["SHOW_ON_TOP"] = "Show on Top"
Locales["SPLIT_LINES"] = "Split Lines"
Locales["VERTICAL_OFFSET_Y"] = "Vertical Offset Y"
Locales["ALERT_COLOR"] = "Alert Color"
Locales["REWARD_AVAILABLE"] = "REWARD AVAILABLE TO BE COLLECTED"
Locales["REWARD_ON_CHAR"] = "REWARD AVAILABLE ON %s"
Locales["PARAGON_TEXT_SIZE"] = "Alert Text Size"
Locales["PARAGON_TEXT_Y"] = "Alert Y Offset"
Locales["PARAGON_ON_TOP"] = "Show Alert at Top of Screen"

-- Config/Preview Strings
Locales["CONFIG_FACTION_A_REWARD"] = "[CONFIG] FACTION A REWARD"
Locales["CONFIG_FACTION_B_REWARD"] = "[CONFIG] FACTION B REWARD"
Locales["CONFIG_MULTIPLE_REWARDS"] = "[CONFIG] MULTIPLE REWARDS PENDING!"