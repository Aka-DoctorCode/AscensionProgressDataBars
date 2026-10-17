-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
-- Author: Aka-DoctorCode
-- File: enUS.lua
-------------------------------------------------------------------------------
---@diagnostic disable: undefined-global, undefined-field, inject-field

local _, addonTable = ...
local Locales = _G.LibStub("AceLocale-3.0"):NewLocale("AscensionProgressDataBars", "enUS", true) or
    _G.LibStub("AceLocale-3.0"):NewLocale("AscensionProgressDataBars", "enGB")

if not Locales then return end

-------------------------------------------------------------------------------
-- GENERAL
-------------------------------------------------------------------------------
Locales["ADDON_NAME"] = "Ascension Progress Data Bar"
Locales["CONFIG_MODE"] = "Config Mode"
Locales["CONFIG_MODE_DESC"] = "Show dummy bars to visualize changes in real-time."
Locales["FACTION_STANDINGS_RESET"] = "Reset Defaults"
Locales["EMPTY"] = "Empty"
Locales["AND"] = " AND "
Locales["CONFIG_MODULE_MISSING"] = "AscensionBars: Configuration module not found."
Locales["TOGGLE_CONFIG_WINDOW"] = "Toggle Config Window"

-------------------------------------------------------------------------------
-- CAROUSEL GAINS
-------------------------------------------------------------------------------
Locales["Experience"] = "Experience"
Locales["Reputation"] = "Reputation"
Locales["House XP"] = "House XP"
Locales["Honor"] = "Honor"
Locales["Azerite"] = "Azerite"

-------------------------------------------------------------------------------
-- TABS
-------------------------------------------------------------------------------
Locales["TAB_BARS_LAYOUT"] = "Bars Layout"
Locales["TAB_CUSTOM_GRID"] = "Custom Bars"
Locales["TAB_TEXT_LAYOUT"] = "Text Layout"
Locales["TAB_BEHAVIOR"] = "Behavior"
Locales["TAB_COLORS"] = "Colors"
Locales["TAB_PARAGON_ALERTS"] = "Alerts"
Locales["TAB_PROFILES"] = "Profiles"

-------------------------------------------------------------------------------
-- UI CONTROLS & LABELS
-------------------------------------------------------------------------------
Locales["ENABLE"] = "Enable"
Locales["ENABLE_DESC"] = "Enable or disable this specific progress bar."
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
Locales["GLOBAL_SETTINGS"] = "Global Settings"
Locales["PER_BLOCK_OFFSET"] = "Use Per-Block Offset"
Locales["PER_BLOCK_OFFSET_DESC"] = "Enable to set independent Y-offsets for the Top and Bottom bar blocks instead of a single global offset."
Locales["PER_BLOCK_GAP"] = "Use Per-Block Gap"
Locales["PER_BLOCK_GAP_DESC"] = "Enable to set independent spacing gaps for the Top and Bottom bar blocks."
Locales["BAR_GAP"] = "Global Gap Between Bars"
Locales["TOP_OFFSET"] = "Top Block Offset"
Locales["BOTTOM_OFFSET"] = "Bottom Block Offset"
Locales["BLOCK_HEIGHT"] = "Block Bar Height"
Locales["USE_PER_BLOCK_HEIGHT"] = "Use Per-Block Height"
Locales["USE_PER_BLOCK_HEIGHT_DESC"] = "Enable to set different bar heights for the Top and Bottom blocks."
Locales["USE_CUSTOM_HEIGHT"] = "Custom Height"
Locales["USE_CUSTOM_HEIGHT_DESC"] = "Toggle between using the global block height or setting a unique height for this specific bar."
Locales["CUSTOM_HEIGHT"] = "Custom Height"
Locales["USE_PER_GROUP_SIZE"] = "Use Per-Group Size"
Locales["USE_PER_GROUP_COLOR"] = "Use Per-Group Color"
Locales["USE_CUSTOM_TEXT_SIZE"] = "Use Custom Text Size"
Locales["USE_CUSTOM_TEXT_COLOR"] = "Use Custom Text Color"
Locales["GROUP_SIZE"] = "Group Text Size"
Locales["GROUP_COLOR"] = "Group Text Color"
Locales["CUSTOM_TEXT_SIZE"] = "Custom Text Size"
Locales["CUSTOM_TEXT_COLOR"] = "Custom Text Color"
Locales["TOP_GAP"] = "Top Block Gap"
Locales["BOTTOM_GAP"] = "Bottom Block Gap"
Locales["BAR_MANAGEMENT"] = "Bar Management"
Locales["TOP_BLOCK"] = "Top Block"
Locales["BOTTOM_BLOCK"] = "Bottom Block"
Locales["FREE_MODE"] = "Free Mode"
Locales["DIM_ALPHA"] = "Dim Alpha"
Locales["CAROUSEL_OPTIONS"] = "Carousel Options"
Locales["CAROUSEL_X_OFFSET"] = "X Offset"
Locales["CAROUSEL_Y_OFFSET"] = "Y Offset"
Locales["CAROUSEL_BG_ALPHA"] = "Background Alpha"

-------------------------------------------------------------------------------
-- EXPERIENCE BAR
-------------------------------------------------------------------------------
Locales["EXPERIENCE"] = "Experience"
Locales["XP_BAR_DATA"] = "Experience Bar Data | 0/0 (0.0%)"
Locales["XP_BAR_CONFIG_TEXT"] = "Experience: 75% (Resting)"
Locales["RESTED_XP"] = "Rested XP"
Locales["RESTED_TEXT"] = "Rested"
Locales["LEVEL_TEXT"] = "Level %d"
Locales["LEVEL_TEXT_ABS_PCT"] = "Level %d | %s / %s (%.1f%%)"
Locales["LEVEL_TEXT_ABS"] = "Level %d | %s / %s"
Locales["LEVEL_TEXT_PCT"] = "Level %d | %.1f%%"
Locales["RESTED_LABEL"] = "Rested: %s"

-------------------------------------------------------------------------------
-- REPUTATION BAR
-------------------------------------------------------------------------------
Locales["REPUTATION"] = "Reputation"
Locales["REP_BAR_DATA"] = "Reputation Bar Data | 0/0 (0.0%)"
Locales["PARAGON"] = "Paragon"
Locales["RENOWN_LEVEL"] = "Renown Level"
Locales["REWARD_PENDING_STATUS"] = "Reward Pending"
Locales["REWARD_PENDING_SINGLE"] = " REWARD PENDING!"
Locales["REWARD_PENDING_PLURAL"] = " REWARDS PENDING!"
Locales["ADD_CUSTOM_REPUTATION"] = "Add Custom Reputation"
Locales["SEARCH_FACTION"] = "Search Faction"
Locales["SELECT_FACTION"] = "Select Faction"
Locales["ADD"] = "Add"
Locales["DELETE"] = "Delete"

-- Reputation Display Patterns
Locales["REP_LABEL_FORMAT"] = "%s (%s)"
Locales["REP_VALUE_FORMAT_FULL"] = "%s / %s (%.1f%%)"
Locales["REP_VALUE_FORMAT_PCT"] = "(%.1f%%)"

-------------------------------------------------------------------------------
-- HONOR BAR
-------------------------------------------------------------------------------
Locales["HONOR"] = "Honor"
Locales["HONOR_LEVEL_SIMPLE"] = "Honor Level %d"
Locales["ENABLE_HONOR_BAR"] = "Enable Honor Bar"
Locales["HONOR_BAR_DATA"] = "Honor: 0%"
Locales["HONOR_BAR_HEIGHT"] = "Honor Bar Height"
Locales["HONOR_LEVEL_FORMAT"] = "Honor Level %d | %s/%s (%.1f%%)"

-------------------------------------------------------------------------------
-- AZERITE BAR
-------------------------------------------------------------------------------
Locales["AZERITE"] = "Azerite"
Locales["ENABLE_AZERITE_BAR"] = "Enable Azerite Bar"
Locales["AZERITE_BAR_DATA"] = "Azerite Power: 0%"
Locales["AZERITE_BAR_HEIGHT"] = "Azerite Bar Height"
Locales["AZERITE_LEVEL_FORMAT"] = "Azerite Level %d | %s/%s (%.1f%%)"

-------------------------------------------------------------------------------
-- HOUSING FAVOR BAR
-------------------------------------------------------------------------------
Locales["HOUSE_FAVOR"] = "House Favor Level"
Locales["ENABLE_HOUSE_XP_BAR"] = "Enable House Favor Bar"
Locales["HOUSE_XP"] = "House Favor"
Locales["HOUSE_BAR_HEIGHT"] = "House Bar Height"
Locales["HOUSE_LEVEL_FORMAT"] = "%s Level %d | %s / %s (%.1f%%)"
Locales["HOUSE_LEVEL_ABS"]    = "%s Level %d | %s / %s"
Locales["HOUSE_LEVEL_PCT"]    = "%s Level %d | (%.1f%%)"
Locales["HOUSE_LEVEL_SIMPLE"] = "%s Level %d"
Locales["HOUSE_UPGRADES_AVAILABLE"] = "HOUSE UPGRADES AVAILABLE FOR %s"

-------------------------------------------------------------------------------
-- TEXT LAYOUT TAB
-------------------------------------------------------------------------------
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

-------------------------------------------------------------------------------
-- BEHAVIOR TAB
-------------------------------------------------------------------------------
Locales["AUTO_HIDE_LOGIC"] = "Auto-Hide Logic"
Locales["BARS_HIDDEN_COMBAT_HOVER"] = "Bars hidden - Hover to show (Hidden in Combat)"
Locales["BARS_HIDDEN_HOVER"] = "Bars hidden - Hover to show"
Locales["BARS_HIDDEN_COMBAT"] = "Bars hidden in Combat"
Locales["SHOW_ON_MOUSEOVER"] = "Show on Mouseover"
Locales["SHOW_ON_MOUSEOVER_DESC"] = "Only show the bars when the mouse is over them. If disabled, bars will always be visible unless combat-hide is active."
Locales["HIDE_IN_COMBAT"] = "Hide in Combat"
Locales["HIDE_IN_COMBAT_DESC"] = "Automatically hide the bars when you enter combat to reduce UI clutter."
Locales["HIDE_AT_MAX_LEVEL"] = "Hide XP Bar at Max Level"
Locales["HIDE_AT_MAX_LEVEL_DESC"] = "Automatically hide the Experience bar when your character reaches the maximum level."
Locales["DATA_DISPLAY"] = "Data Display"
Locales["SHOW_PERCENTAGE"] = "Show Percentage"
Locales["SHOW_PERCENTAGE_DESC"] = "Display the progress percentage on the bars."
Locales["SHOW_ABSOLUTE_VALUES"] = "Show Absolute Values"
Locales["SHOW_ABSOLUTE_VALUES_DESC"] = "Display the absolute current and maximum values (e.g., 1200 / 5000)."
Locales["SHOW_SPARK"] = "Show Spark"
Locales["SHOW_SPARK_DESC"] = "Show a bright spark at the leading edge of the progress bars for better visibility."

-------------------------------------------------------------------------------
-- COLORS TAB
-------------------------------------------------------------------------------
Locales["USE_CLASS_COLOR"] = "Use Class Color"
Locales["USE_CLASS_COLOR_DESC"] = "Color the Experience bar using your character's class color."
Locales["CUSTOM_XP_COLOR"] = "Custom XP Color"
Locales["SHOW_RESTED_BAR"] = "Show Rested Bar"
Locales["SHOW_RESTED_BAR_DESC"] = "Display a secondary bar showing your currently earned Rested Experience."
Locales["RESTED_COLOR"] = "Rested Color"
Locales["USE_REACTION_COLORS"] = "Use Reaction Colors"
Locales["USE_REACTION_COLORS_DESC"] = "Automatically color the Reputation bar based on your standing (Hated, Neutral, Exalted, etc.)."
Locales["CUSTOM_REP_COLOR"] = "Custom Reputation Color"
Locales["HONOR_COLOR"] = "Honor Color"
Locales["HOUSE_XP_COLOR"] = "House Favor Color"
Locales["HOUSE_REWARD_COLOR"] = "House Reward Text Color"
Locales["HOUSE_REWARD_Y_OFFSET"] = "House Reward Y Offset"
Locales["AZERITE_COLOR"] = "Azerite Color"

-------------------------------------------------------------------------------
-- REPUTATION STANDINGS
-------------------------------------------------------------------------------
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

-------------------------------------------------------------------------------
-- PARAGON ALERTS
-------------------------------------------------------------------------------
Locales["ALERT_STYLING"] = "Alert Styling"
Locales["SPLIT_LINES"] = "Split Lines"
Locales["SPLIT_LINES_DESC"] = "When multiple Paragon rewards are pending, show each faction on a separate line instead of combining them."
Locales["ALERT_COLOR"] = "Alert Color"
Locales["REWARD_AVAILABLE"] = "REWARD AVAILABLE TO BE COLLECTED"
Locales["REWARD_ON_CHAR"] = "REWARD AVAILABLE ON %s"
Locales["PARAGON_TEXT_SIZE"] = "Alert Text Size"

-------------------------------------------------------------------------------
-- CUSTOM GRID MODE
-------------------------------------------------------------------------------
Locales["CUSTOM_GRID"] = "Custom Bars"
Locales["CUSTOM_GRID_ENABLE"] = "Enable Custom Grid Layout"
Locales["CUSTOM_GRID_ENABLE"] = "Enable Custom Grid Layout"
Locales["ENABLE_ADVANCED_GRID"] = "Enable Custom Grid (Advanced)"
Locales["ENABLE_ADVANCED_GRID_DESC"] = "Enable the advanced grid system to manually position bars in rows and columns. This overrides standard layout logic."
Locales["GRID_OPTIONS"] = "Grid Configuration"
Locales["GRID_ROWS"] = "Total Rows"
Locales["GRID_COLS_FOR_ROW"] = "Cols for Row %d"
Locales["GRID_CELL"] = "Row %d - Col %d"
Locales["GRID_PRESET"] = "Layout Preset"
Locales["PRESET_CUSTOM"] = "Custom"
Locales["PRESET_2X1"] = "2x1 (2 Rows, 1 Col)"
Locales["PRESET_2X2"] = "2x2 (2 Rows, 2 Cols)"
Locales["PRESET_3X2"] = "3x2 (3 Rows, 2 Cols)"
Locales["ASSIGN_BAR"] = "Assign Bar"

-------------------------------------------------------------------------------
-- TEXT LAYOUT (additional)
-------------------------------------------------------------------------------
Locales["BLOCK_TEXT_MODE"] = "Text Behavior"
Locales["TEXT_VISIBILITY_MODE"] = "Text Visibility Mode"
Locales["FOCUS_MODE"] = "Show on Hover"
Locales["GRID_DYNAMIC"] = "Always Visible"
Locales["NONE"] = "None"
Locales["BASE_TYPOGRAPHY"] = "Base Typography"
Locales["FONT_OUTLINE"] = "Font Outline"
Locales["VISUAL_OPTIONS"] = "Visual Options"
Locales["SHOW_RESTED"] = "Show Rested XP"
Locales["USE_COMPACT_FORMAT"] = "Compact Format"
Locales["USE_COMPACT_FORMAT_DESC"] = "Format large numbers into a shorter, more readable style (e.g., 1.2k instead of 1200)."
Locales["EVENTS_VISIBILITY"] = "Visibility"
Locales["ENABLE_CAROUSEL"] = "Enable Event Carousel"
Locales["ENABLE_CAROUSEL_DESC"] = "Display a rotating banner of recent Experience and Reputation gains."
Locales["LATERAL_LEGEND"] = "Enable Lateral Legend"
Locales["LATERAL_LEGEND_DESC"] = "Show a permanent legend displaying the current status for all active bars."
Locales["DYNAMIC_GRID_GAP"] = "Grid Gap"
Locales["LEGEND_OPTIONS"] = "Legend Options"
Locales["LEGEND_TEXT_SIZE"] = "Legend Text Size"
Locales["LEGEND_BG_ALPHA"] = "Background Alpha"
Locales["LEGEND_FONT_OUTLINE"] = "Legend Font Outline"

-------------------------------------------------------------------------------
-- CONFIG / PREVIEW STRINGS
-------------------------------------------------------------------------------
Locales["CONFIG_FACTION_A_REWARD"] = "[CONFIG] FACTION A REWARD"
Locales["CONFIG_FACTION_B_REWARD"] = "[CONFIG] FACTION B REWARD"
Locales["CONFIG_MULTIPLE_REWARDS"] = "[CONFIG] MULTIPLE REWARDS PENDING!"

-------------------------------------------------------------------------------
-- PROFILES TAB
-------------------------------------------------------------------------------
Locales["PROFILES"] = "Profiles"
Locales["PROFILE_DESC_1"] = "You can change the active database profile, so you can have different settings for every character."
Locales["PROFILE_DESC_2"] = "Reset the current profile back to its default values."
Locales["RESET_PROFILE"] = "Reset Profile"
Locales["CURRENT_PROFILE"] = "Current Profile:"
Locales["PROFILE_DESC_3"] = "Create a new profile or choose an existing one."
Locales["NEW"] = "New Profile"
Locales["EXISTING_PROFILES"] = "Existing Profiles"
Locales["COPY_PROFILE_DESC"] = "Copy settings from another profile into the current one."
Locales["COPY_FROM"] = "Copy From"
Locales["DELETE_PROFILE_DESC"] = "Delete unused profiles to save space."
Locales["DELETE_PROFILE"] = "Delete a Profile"
Locales["DELETE_PROFILE_CONFIRM"] = "Delete profile '%s'?"
Locales["ACCEPT"] = "Accept"
Locales["CANCEL"] = "Cancel"
Locales["YES"] = "Yes"
Locales["NO"] = "No"
Locales["IMPORT_PROFILE"] = "Import Profile"
Locales["EXPORT_PROFILE"] = "Export Profile"
Locales["IMPORT_EXPORT_DESC"] = "Share your configuration with others."
Locales["CLOSE"] = "Close"
Locales["IMPORT"] = "Import"
Locales["RESET_CONFIRM"] = "Are you sure you want to reset the profile '%s' to defaults?"