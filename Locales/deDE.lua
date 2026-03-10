-------------------------------------------------------------------------------
-- Project: AscensionBars
-- Author: Aka-DoctorCode
-- File: deDE.lua
-- Version: @project-version@
-------------------------------------------------------------------------------
-- Copyright (c) 2025–2026 Aka-DoctorCode. All Rights Reserved.
--
-- This software and its source code are the exclusive property of the author.
-- No part of this file may be copied, modified, redistributed, or used in
-- derivative works without express written permission.
-------------------------------------------------------------------------------

local Locales = LibStub("AceLocale-3.0"):NewLocale("AscensionBars", "deDE", true)

if not Locales then return end

-- General Configuration
Locales["ADDON_NAME"] = "Ascension Bars"
Locales["CONFIG_MODE"] = "Konfigurationsmodus"
Locales["CONFIG_MODE_DESC"] = "Zeige Dummy-Balken, um Änderungen in Echtzeit zu visualisieren."
Locales["FACTION_STANDINGS_RESET"] = "Standardwerte zurücksetzen"
Locales["EMPTY"] = "(Leer)"
Locales["AND"] = " UND "
Locales["CONFIG_MODULE_MISSING"] = "AscensionBars: Konfigurationsmodul nicht gefunden."
Locales["TOGGLE_CONFIG_WINDOW"] = "Konfigurationsfenster umschalten"

-- Tabs
Locales["TAB_BARS_LAYOUT"] = "Balken Layout"
Locales["TAB_TEXT_LAYOUT"] = "Textlayout"
Locales["TAB_BEHAVIOR"] = "Verhalten"
Locales["TAB_COLORS"] = "Farben"
Locales["TAB_PARAGON_ALERTS"] = "Paragon-Warnmeldungen"

-- UI Controls & Labels
Locales["ENABLE"] = "Aktivieren"
Locales["ANCHOR"] = "Anker"
Locales["TOP"] = "Oben"
Locales["BOTTOM"] = "Unten"
Locales["FREE"] = "Frei"
Locales["ORDER"] = "Reihenfolge"
Locales["WIDTH"] = "Breite"
Locales["HEIGHT"] = "Höhe"
Locales["POS_X"] = "Position X"
Locales["POS_Y"] = "Position Y"
Locales["TXT_X"] = "Text X-Versatz"
Locales["TXT_Y"] = "Text Y-Versatz"
Locales["GLOBAL_BLOCKS_OFFSET"] = "Globaler Block-Versatz"
Locales["GLOBAL_BAR_HEIGHT"] = "Globale Balkenhöhe"
Locales["GLOBAL_OFFSET"] = "Globaler Versatz"
Locales["BAR_MANAGEMENT"] = "Balkenverwaltung"
Locales["TOP_BLOCK"] = "Oberer Block"
Locales["BOTTOM_BLOCK"] = "Unterer Block"
Locales["FREE_MODE"] = "Freier Modus"

-- Experience Bar
Locales["EXPERIENCE"] = "Erfahrung"
Locales["XP_BAR_DATA"] = "Erfahrungsbalken Daten | 0/0 (0.0%)"
Locales["XP_BAR_CONFIG_TEXT"] = "Erfahrung: 75% (Ausgeruht)"
Locales["RESTED_XP"] = "Ausgeruhte Erfahrung"
Locales["LEVEL_TEXT"] = "Level %d"
Locales["LEVEL_TEXT_PCT"] = "%d | %d%%"
Locales["LEVEL_TEXT_ABS"] = "%d | %s / %s"
Locales["LEVEL_TEXT_ABS_PCT"] = "%d | %s / %s (%d%%)"
Locales["RESTED_TEXT"] = " (+%d%%)"

-- Reputation Bar
Locales["REPUTATION"] = "Ruhm"
Locales["REP_BAR_DATA"] = "Ruhm Balken Daten | 0/0 (0.0%)"
Locales["PARAGON"] = "Quittung"
Locales["RENOWN_LEVEL"] = "Bekanntheitsgrad"
Locales["REWARD_PENDING_STATUS"] = "Belohnung ausstehend"
Locales["REWARD_PENDING_SINGLE"] = " BELOHNUNG AUSSTEHEND!"
Locales["REWARD_PENDING_PLURAL"] = " BELOHNUNGEN AUSSTEHEND!"

-- Reputation Display Patterns
Locales["REP_LABEL_FORMAT"] = "%s (%s)"
Locales["REP_VALUE_FORMAT_FULL"] = "%s / %s (%.1f%%)"
Locales["REP_VALUE_FORMAT_PCT"] = "(%.1f%%)"

-- Honor Bar
Locales["HONOR"] = "Ehre"
Locales["ENABLE_HONOR_BAR"] = "Ehrenbalken aktivieren"
Locales["HONOR_BAR_DATA"] = "Ehre: 0%"
Locales["HONOR_BAR_HEIGHT"] = "Ehrenbalkenhöhe"
Locales["HONOR_LEVEL_FORMAT"] = "Ehrenrang %d | %s/%s (%.1f%%)"

-- Azerite Bar
Locales["AZERITE"] = "Azerit"
Locales["ENABLE_AZERITE_BAR"] = "Azeritbalken aktivieren"
Locales["AZERITE_BAR_DATA"] = "Azeritkraft: 0%"
Locales["AZERITE_BAR_HEIGHT"] = "Azeritbalkenhöhe"
Locales["AZERITE_LEVEL_FORMAT"] = "Azeritrang %d | %s/%s (%.1f%%)"

-- Housing Favor Bar
Locales["HOUSE_FAVOR"] = "Haus Gunst"
Locales["ENABLE_HOUSE_XP_BAR"] = "Haus Gunst Balken aktivieren"
Locales["HOUSE_XP"] = "Haus Gunst"
Locales["HOUSE_BAR_HEIGHT"] = "Haus Balkenhöhe"
Locales["HOUSE_LEVEL_FORMAT"] = "%s | Lvl %d | %s / %s (%.1f%%)"
Locales["HOUSE_LEVEL_SIMPLE"] = "%s | Level %d"
Locales["HOUSE_UPGRADES_AVAILABLE"] = "HAUSVERBESSERUNGEN FÜR %s VERFÜGBAR"

-- Appearance Tab
Locales["TEXT_AND_FONT"] = "Text und Schriftart"
Locales["LAYOUT_MODE"] = "Layout-Modus"
Locales["ALL_IN_ONE_LINE"] = "Alles in einer Zeile"
Locales["MULTIPLE_LINES"] = "Mehrere Zeilen"
Locales["TEXT_FOLLOWS_BAR"] = "Text folgt Balken"
Locales["TEXT_FOLLOWS_BAR_DESC"] = "Textgruppe 1 folgt der Position des untersten aktiven Balkens."
Locales["FONT_SIZE"] = "Schriftgröße"
Locales["GLOBAL_TEXT_COLOR"] = "Globale Textfarbe"
Locales["TEXT_GROUP_POSITIONS"] = "Textgruppenpositionen"
Locales["DETACH_GROUP"] = "Gruppe %d lösen"
Locales["DETACH_GROUP_DESC"] = "Erlaube Gruppe %d, unabhängig positioniert zu werden."
Locales["GROUP_X"] = "Gruppen %d X-Versatz"
Locales["GROUP_Y"] = "Gruppen %d Y-Versatz"
Locales["TEXT_SIZE"] = "Textgröße"
Locales["TEXT_MANAGEMENT"] = "Text Management"
Locales["GROUP_1"] = "Gruppe 1"
Locales["GROUP_2"] = "Gruppe 2"
Locales["GROUP_3"] = "Gruppe 3"

-- Behavior Tab
Locales["AUTO_HIDE_LOGIC"] = "Logik zum automatischen Ausblenden"
Locales["SHOW_ON_MOUSEOVER"] = "Bei Mausberührung anzeigen"
Locales["HIDE_IN_COMBAT"] = "Im Kampf ausblenden"
Locales["HIDE_AT_MAX_LEVEL"] = "Auf maximaler Stufe ausblenden"
Locales["DATA_DISPLAY"] = "Datenanzeige"
Locales["SHOW_PERCENTAGE"] = "Prozentsatz anzeigen"
Locales["SHOW_ABSOLUTE_VALUES"] = "Absolute Werte anzeigen"
Locales["SHOW_SPARK"] = "Funken anzeigen"

-- Colors Tab
Locales["USE_CLASS_COLOR"] = "Klassenfarbe verwenden"
Locales["CUSTOM_XP_COLOR"] = "Benutzerdefinierte XP-Farbe"
Locales["SHOW_RESTED_BAR"] = "Ausgeruhten Balken anzeigen"
Locales["RESTED_COLOR"] = "Ausgeruhte Farbe"
Locales["USE_REACTION_COLORS"] = "Reaktionsfarben verwenden"
Locales["CUSTOM_REP_COLOR"] = "Benutzerdefinierte Reputationsfarbe"
Locales["HONOR_COLOR"] = "Ehrenfarbe"
Locales["HOUSE_XP_COLOR"] = "Haus Gunst Farbe"
Locales["HOUSE_REWARD_COLOR"] = "Haus Belohnung Textfarbe"
Locales["HOUSE_REWARD_Y_OFFSET"] = "Haus Belohnung Y-Versatz"
Locales["AZERITE_COLOR"] = "Azeritfarbe"

-- Reputation Standings
Locales["HATED"] = "Hass"
Locales["HOSTILE"] = "Feindlich"
Locales["UNFRIENDLY"] = "Unfreundlich"
Locales["NEUTRAL"] = "Neutral"
Locales["FRIENDLY"] = "Freundlich"
Locales["HONORED"] = "Respektiert"
Locales["REVERED"] = "Ehrfürchtig"
Locales["EXALTED"] = "Ehrfürchtig"
Locales["MAXED"] = "Ausgeschöpft"
Locales["RENOWN"] = "Renommee"
Locales["RANK_NUM"] = "Rang %d"

-- Paragon Alerts
Locales["ALERT_STYLING"] = "Warnungsstil"
Locales["SHOW_ON_TOP"] = "Oben anzeigen"
Locales["SPLIT_LINES"] = "Getrennte Zeilen"
Locales["VERTICAL_OFFSET_Y"] = "Vertikaler Versatz Y"
Locales["ALERT_COLOR"] = "Warnungsfarbe"
Locales["REWARD_AVAILABLE"] = "BELOHNUNG VERFÜGBAR"
Locales["REWARD_ON_CHAR"] = "BELOHNUNG VERFÜGBAR AUF %s"
Locales["PARAGON_TEXT_SIZE"] = "Warnungs Textgröße"
Locales["PARAGON_TEXT_Y"] = "Warnungs Y-Versatz"
Locales["PARAGON_ON_TOP"] = "Warnung oben anzeigen"

-- Config/Preview Strings
Locales["CONFIG_FACTION_A_REWARD"] = "[KONFIGURATION] FRAKTION A BELOHNUNG"
Locales["CONFIG_FACTION_B_REWARD"] = "[KONFIGURATION] FRAKTION B BELOHNUNG"
Locales["CONFIG_MULTIPLE_REWARDS"] = "[KONFIGURATION] MEHRERE BELOHNUNGEN VERFÜGBAR!"