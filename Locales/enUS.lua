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

local Locales = LibStub("AceLocale-3.0"):NewLocale("AscensionBars", "enUS", true) or
    LibStub("AceLocale-3.0"):NewLocale("AscensionBars", "enGB")
if not Locales then return end

-- General Configuration
Locales["ADDON_NAME"] = "Ascension Bars"
Locales["CONFIG_MODE"] = "Config Mode"
Locales["CONFIG_MODE_DESC"] = "Show dummy bars to visualize changes in real-time."
Locales["FACTION_STANDINGS_RESET"] = "Reset Defaults"
Locales["EMPTY"] = "(Empty)"

-- Tabs
Locales["TAB_BARS_LAYOUT"] = "Bars Layout"
Locales["TAB_TEXT_LAYOUT"] = "Text Layout"
Locales["TAB_BEHAVIOR"] = "Behavior"
Locales["TAB_COLORS"] = "Colors"
Locales["TAB_PARAGON_ALERTS"] = "Paragon Alerts"

-- Global Controls
Locales["ENABLE"] = "Enable"
Locales["ORDER"] = "Order"
Locales["ANCHOR"] = "Anchor"
Locales["TOP"] = "Top"
Locales["BOTTOM"] = "Bottom"
Locales["FREE"] = "Free"
Locales["WIDTH"] = "Width"
Locales["HEIGHT"] = "Height"
Locales["POS_X"] = "Pos X"
Locales["POS_Y"] = "Pos Y"
Locales["TXT_X"] = "Txt X"
Locales["TXT_Y"] = "Txt Y"

-- Layout Tab
Locales["GLOBAL_POSITIONING"] = "Global Positioning"
Locales["GLOBAL_BLOCKS_OFFSET"] = "Global Blocks Offset"
Locales["GLOBAL_BAR_HEIGHT"] = "Global Bar Height"
Locales["BAR_MANAGEMENT"] = "Bar Management"
Locales["TOP_BLOCK"] = "Top Block"
Locales["BOTTOM_BLOCK"] = "Bottom Block"
Locales["FREE_MODE"] = "Free Mode"

-- Appearance / Text Layout Tab
Locales["TEXT_AND_FONT"] = "Text & Font"
Locales["LAYOUT_MODE"] = "Layout Mode"
Locales["ALL_IN_ONE_LINE"] = "All in one line"
Locales["MULTIPLE_LINES"] = "Multiple lines"
Locales["TEXT_FOLLOWS_BAR"] = "Text follows its Bar"
Locales["TEXT_FOLLOWS_BAR_DESC"] = "If disabled, text will anchor to the global center."
Locales["FONT_SIZE"] = "Font Size"
Locales["GLOBAL_TEXT_COLOR"] = "Global Text Color"
Locales["TEXT_GROUP_POSITIONS"] = "Text Group Positions"
Locales["DETACH_GROUP"] = "Detach %d"
Locales["DETACH_GROUP_DESC"] = "Anchor group %d globally instead of to the bars."
Locales["GROUP_X"] = "Group %d X"
Locales["GROUP_Y"] = "Group %d Y"
Locales["TEXT_MANAGEMENT"] = "Text Management"
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
Locales["EXPERIENCE"] = "Experience"
Locales["USE_CLASS_COLOR"] = "Use Class Color"
Locales["CUSTOM_XP_COLOR"] = "Custom XP Color"
Locales["SHOW_RESTED_BAR"] = "Show Rested Bar"
Locales["RESTED_COLOR"] = "Rested Color"
Locales["REPUTATION"] = "Reputation"
Locales["USE_REACTION_COLORS"] = "Use Reaction Colors"
Locales["CUSTOM_REP_COLOR"] = "Custom Reputation Color"
Locales["HONOR"] = "Honor"
Locales["HONOR_COLOR"] = "Honor Color"
Locales["HOUSE_FAVOR"] = "House Favor"
Locales["HOUSE_XP_COLOR"] = "House Favor Color"
Locales["HOUSE_REWARD_COLOR"] = "Reward Text Color"
Locales["HOUSE_REWARD_Y_OFFSET"] = "Reward Text Y-Offset"
Locales["AZERITE"] = "Azerite"
Locales["AZERITE_COLOR"] = "Azerite Color"
Locales["RANK_NUM"] = "Rank %d"

-- Paragon Alerts Tab
Locales["ALERT_STYLING"] = "Alert Styling"
Locales["SHOW_ON_TOP"] = "Show On Top"
Locales["SPLIT_LINES"] = "Split Lines"
Locales["TEXT_SIZE"] = "Text Size"
Locales["VERTICAL_OFFSET_Y"] = "Vertical Offset Y"
Locales["ALERT_COLOR"] = "Alert Color"

-- Standing Data
Locales["HATED"] = "Hated"
Locales["HOSTILE"] = "Hostile"
Locales["UNFRIENDLY"] = "Unfriendly"
Locales["NEUTRAL"] = "Neutral"
Locales["FRIENDLY"] = "Friendly"
Locales["HONORED"] = "Honored"
Locales["REVERED"] = "Revered"
Locales["EXALTED"] = "Exalted"
Locales["PARAGON"] = "Paragon"
Locales["MAXED"] = "Maxed"
Locales["RENOWN"] = "Renown"
Locales["UNKNOWN_FACTION"] = "Unknown Faction"
Locales["UNKNOWN_STANDING"] = "???"

-- Formats
Locales["LEVEL_TEXT_ABS_PCT"] = "Level %d | %s/%s (%.1f%%)"
Locales["LEVEL_TEXT_ABS"] = "Level %d | %s/%s"
Locales["LEVEL_TEXT_PCT"] = "Level %d | %.1f%%"
Locales["LEVEL_TEXT"] = "Level %d"
Locales["RESTED_TEXT"] = " | Rested %.1f%%"
Locales["RENOWN_LEVEL"] = "Renown %d"

-- Other Legacy Keys
Locales["APPEARANCE"] = "Appearance"
Locales["BAR_ANCHOR"] = "Bar Position"
Locales["BAR_GAP"] = "Bar Gap"
Locales["BAR_GAP_DESC"] = "Gap between bars."
Locales["ANCHOR_TOP"] = "Top (Default)"
Locales["ANCHOR_BOTTOM"] = "Bottom"
Locales["ANCHOR_DESC"] = "Controls the anchor point of the bars. Top: Bars top, Text bottom. Bottom: Bars bottom, Text top."
Locales["POSITION_SIZE"] = "Position & Size"
Locales["VERTICAL_POSITION"] = "Vertical Position (Y)"
Locales["TEXT_GAP"] = "Text Gap"
Locales["XP_BAR_HEIGHT"] = "XP Bar Height"
Locales["REP_BAR_HEIGHT"] = "Reputation Bar Height"
Locales["VISIBILITY"] = "Visibility"
Locales["COLORS"] = "Colors"
Locales["PARAGON_ALERTS"] = "Paragon Alerts"
Locales["FACTION_COLORS"] = "Faction Colors"
Locales["ADVANCED"] = "Advanced"
Locales["REWARD_PENDING"] = " REWARD PENDING!"
Locales["AND"] = " AND "
Locales["REWARD_PENDING_SINGLE"] = " REWARD PENDING!"
Locales["REWARD_PENDING_PLURAL"] = " REWARDS PENDING!"
Locales["XP_BAR_DATA"] = "Experience Bar Data | 0/0 (0.0%)"
Locales["REP_BAR_DATA"] = "Reputation Bar Data | 0/0 (0.0%)"
Locales["CONFIG_FACTION_A_REWARD"] = "[CONFIG] FACTION A REWARD"
Locales["CONFIG_FACTION_B_REWARD"] = "[CONFIG] FACTION B REWARD"
Locales["CONFIG_MULTIPLE_REWARDS"] = "[CONFIG] MULTIPLE REWARDS PENDING!"
Locales["REWARD_PENDING_STATUS"] = "Reward Pending"
Locales["OPTIONAL_BARS"] = "Optional Bars"
Locales["ENABLE_HONOR_BAR"] = "Enable Honor Bar"
Locales["HONOR_BAR_DATA"] = "Honor: 0%"
Locales["HONOR_BAR_HEIGHT"] = "Honor Bar Height"
Locales["ENABLE_HOUSE_XP_BAR"] = "Enable House Favor Bar"
Locales["HOUSE_XP"] = "House Favor"
Locales["HOUSE_XP_BAR_DATA"] = "House Level 0 | 0/0 (0.0%)"
Locales["ENABLE_AZERITE_BAR"] = "Enable Azerite Bar"
Locales["AZERITE_BAR_DATA"] = "Azerite Power: 0%"
Locales["AZERITE_BAR_HEIGHT"] = "Azerite Bar Height"
Locales["HOUSE_BAR_HEIGHT"] = "House Bar Height"
Locales["ENABLE_BAR"] = "Enable Bar"
Locales["LAYOUT_BLOCK"] = "Layout Block"
Locales["BAR_ORDER"] = "Position"
Locales["BAR_WIDTH"] = "Width"
Locales["BAR_HEIGHT"] = "Height"
Locales["LAYOUT"] = "Layout"
Locales["HOUSING_FAVOR"] = "House Favor"
Locales["READY"] = "Ready"
Locales["REWARD_AVAILABLE"] = "Reward available to be collected"
Locales["REWARD_ON_CHAR"] = "Reward available on %s"
Locales["HOUSING_UPGRADE_READY"] = "HOUSE UPGRADE READY"