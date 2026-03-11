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

local _, addonTable = ...
local Locales = LibStub("AceLocale-3.0"):NewLocale("AscensionBars", "deDE")

if not Locales then return end

-- General Configuration
Locales["ADDON_NAME"] = "Ascension Bars"
Locales["CONFIG_MODE"] = "Konfigurationsmodus"
Locales["CONFIG_MODE_DESC"] = "Zeigt Testleisten an, um Änderungen in Echtzeit zu visualisieren."
Locales["FACTION_STANDINGS_RESET"] = "Standardwerte zurücksetzen"
Locales["EMPTY"] = "(Leer)"
Locales["AND"] = " UND "
Locales["CONFIG_MODULE_MISSING"] = "AscensionBars: Konfigurationsmodul nicht gefunden."
Locales["TOGGLE_CONFIG_WINDOW"] = "Konfigurationsfenster umschalten"

-- Tabs
Locales["TAB_BARS_LAYOUT"] = "Leisten-Layout"
Locales["TAB_TEXT_LAYOUT"] = "Text-Layout"
Locales["TAB_BEHAVIOR"] = "Verhalten"
Locales["TAB_COLORS"] = "Farben"
Locales["TAB_PARAGON_ALERTS"] = "Paragon-Warnungen"

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
Locales["TXT_X"] = "Textversatz X"
Locales["TXT_Y"] = "Textversatz Y"
Locales["GLOBAL_BLOCKS_OFFSET"] = "Globaler Blockversatz"
Locales["GLOBAL_BAR_HEIGHT"] = "Globale Leistenhöhe"
Locales["GLOBAL_OFFSET"] = "Globaler Versatz"
Locales["BAR_MANAGEMENT"] = "Leistenverwaltung"
Locales["TOP_BLOCK"] = "Oberer Block"
Locales["BOTTOM_BLOCK"] = "Unterer Block"
Locales["FREE_MODE"] = "Freier Modus"

-- Experience Bar
Locales["EXPERIENCE"] = "Erfahrung"
Locales["XP_BAR_DATA"] = "Erfahrungsleistendaten | 0/0 (0.0%)"
Locales["XP_BAR_CONFIG_TEXT"] = "Erfahrung: 75% (Ausgeruht)"
Locales["RESTED_XP"] = "Erholt-Bonus"
Locales["LEVEL_TEXT"] = "Stufe %d"
Locales["LEVEL_TEXT_ABS_PCT"] = "Stufe %d | %s / %s (%.1f%%)"
Locales["LEVEL_TEXT_ABS"] = "Stufe %d | %s / %s"
Locales["LEVEL_TEXT_PCT"] = "Stufe %d | %.1f%%"
Locales["RESTED_LABEL"] = "Erholt: %s"

-- Reputation Bar
Locales["REPUTATION"] = "Ruf"
Locales["REP_BAR_DATA"] = "Rufleistendaten | 0/0 (0.0%)"
Locales["PARAGON"] = "Paragon"
Locales["RENOWN_LEVEL"] = "Ruhmstufe"
Locales["REWARD_PENDING_STATUS"] = "Belohnung ausstehend"
Locales["REWARD_PENDING_SINGLE"] = " BELOHNUNG VERFÜGBAR!"
Locales["REWARD_PENDING_PLURAL"] = " BELOHNUNGEN VERFÜGBAR!"

-- Reputation Display Patterns
Locales["REP_LABEL_FORMAT"] = "%s (%s)"
Locales["REP_VALUE_FORMAT_FULL"] = "%s / %s (%.1f%%)"
Locales["REP_VALUE_FORMAT_PCT"] = "(%.1f%%)"

-- Honor Bar
Locales["HONOR"] = "Ehre"
Locales["ENABLE_HONOR_BAR"] = "Ehrenleiste aktivieren"
Locales["HONOR_BAR_DATA"] = "Ehre: 0%"
Locales["HONOR_BAR_HEIGHT"] = "Ehrenleistenhöhe"
Locales["HONOR_LEVEL_FORMAT"] = "Ehrenstufe %d | %s/%s (%.1f%%)"

-- Azerite Bar
Locales["AZERITE"] = "Azerit"
Locales["ENABLE_AZERITE_BAR"] = "Azeritleiste aktivieren"
Locales["AZERITE_BAR_DATA"] = "Azeritmacht: 0%"
Locales["AZERITE_BAR_HEIGHT"] = "Azeritleistenhöhe"
Locales["AZERITE_LEVEL_FORMAT"] = "Azeritstufe %d | %s/%s (%.1f%%)"

-- Housing Favor Bar
Locales["HOUSE_FAVOR"] = "Haus-Gunst"
Locales["ENABLE_HOUSE_XP_BAR"] = "Haus-Gunst-Leiste aktivieren"
Locales["HOUSE_XP"] = "Haus-Gunst"
Locales["HOUSE_BAR_HEIGHT"] = "Hausleistenhöhe"
Locales["HOUSE_LEVEL_FORMAT"] = "%s Stufe %d | %s / %s (%.1f%%)"
Locales["HOUSE_LEVEL_ABS"]    = "%s Stufe %d | %s / %s"
Locales["HOUSE_LEVEL_PCT"]    = "%s Stufe %d | (%.1f%%)"
Locales["HOUSE_LEVEL_SIMPLE"] = "%s Stufe %d"
Locales["HOUSE_UPGRADES_AVAILABLE"] = "HAUSAUSBAU VERFÜGBAR FÜR %s"

-- Appearance Tab
Locales["TEXT_AND_FONT"] = "Text und Schriftart"
Locales["LAYOUT_MODE"] = "Layout-Modus"
Locales["ALL_IN_ONE_LINE"] = "Alles in einer Zeile"
Locales["MULTIPLE_LINES"] = "Mehrere Zeilen"
Locales["TEXT_FOLLOWS_BAR"] = "Text folgt der Leiste"
Locales["TEXT_FOLLOWS_BAR_DESC"] = "Textgruppe 1 folgt der Position der untersten aktiven Leiste."
Locales["FONT_SIZE"] = "Schriftgröße"
Locales["GLOBAL_TEXT_COLOR"] = "Globale Textfarbe"
Locales["TEXT_GROUP_POSITIONS"] = "Positionen der Textgruppen"
Locales["DETACH_GROUP"] = "Gruppe %d lösen"
Locales["DETACH_GROUP_DESC"] = "Erlaubt es, Gruppe %d unabhängig zu positionieren."
Locales["GROUP_X"] = "Gruppe %d Versatz X"
Locales["GROUP_Y"] = "Gruppe %d Versatz Y"
Locales["TEXT_MANAGEMENT"] = "Textverwaltung"
Locales["TEXT_SIZE"] = "Textgröße"
Locales["GROUP_1"] = "Gruppe 1"
Locales["GROUP_2"] = "Gruppe 2"
Locales["GROUP_3"] = "Gruppe 3"

-- Behavior Tab
Locales["AUTO_HIDE_LOGIC"] = "Auto-Ausblenden-Logik"
Locales["SHOW_ON_MOUSEOVER"] = "Bei Mouseover zeigen"
Locales["HIDE_IN_COMBAT"] = "Im Kampf ausblenden"
Locales["HIDE_AT_MAX_LEVEL"] = "Auf Maximalstufe ausblenden"
Locales["DATA_DISPLAY"] = "Datenanzeige"
Locales["SHOW_PERCENTAGE"] = "Prozentanzeige"
Locales["SHOW_ABSOLUTE_VALUES"] = "Absolute Werte anzeigen"
Locales["SHOW_SPARK"] = "Funken anzeigen"

-- Colors Tab
Locales["USE_CLASS_COLOR"] = "Klassenfarbe verwenden"
Locales["CUSTOM_XP_COLOR"] = "Benutzerdefinierte XP-Farbe"
Locales["SHOW_RESTED_BAR"] = "Erholungsleiste anzeigen"
Locales["RESTED_COLOR"] = "Erholungsfarbe"
Locales["USE_REACTION_COLORS"] = "Fraktionsfarben verwenden"
Locales["CUSTOM_REP_COLOR"] = "Benutzerdefinierte Ruffarbe"
Locales["HONOR_COLOR"] = "Ehrenfarbe"
Locales["HOUSE_XP_COLOR"] = "Haus-Gunst-Farbe"
Locales["HOUSE_REWARD_COLOR"] = "Haus-Belohnungstextfarbe"
Locales["HOUSE_REWARD_Y_OFFSET"] = "Haus-Belohnung Versatz Y"
Locales["AZERITE_COLOR"] = "Azeritfarbe"

-- Reputation Standings
Locales["HATED"] = "Hasserfüllt"
Locales["HOSTILE"] = "Feindselig"
Locales["UNFRIENDLY"] = "Unfreundlich"
Locales["NEUTRAL"] = "Neutral"
Locales["FRIENDLY"] = "Freundlich"
Locales["HONORED"] = "Wohlwollend"
Locales["REVERED"] = "Respektvoll"
Locales["EXALTED"] = "Ehrfürchtig"
Locales["MAXED"] = "Maximum"
Locales["RENOWN"] = "Ruhm"
Locales["RANK_NUM"] = "Rang %d"

-- Paragon Alerts
Locales["ALERT_STYLING"] = "Warnungs-Stil"
Locales["SHOW_ON_TOP"] = "Oben anzeigen"
Locales["SPLIT_LINES"] = "Zeilen teilen"
Locales["VERTICAL_OFFSET_Y"] = "Vertikaler Versatz Y"
Locales["ALERT_COLOR"] = "Warnungsfarbe"
Locales["REWARD_AVAILABLE"] = "BELOHNUNG ABHOLBEREIT"
Locales["REWARD_ON_CHAR"] = "BELOHNUNG VERFÜGBAR AUF %s"
Locales["PARAGON_TEXT_SIZE"] = "Warnungstextgröße"
Locales["PARAGON_TEXT_Y"] = "Warnung Versatz Y"
Locales["PARAGON_ON_TOP"] = "Warnung am oberen Bildschirmrand anzeigen"

-- Config/Preview Strings
Locales["CONFIG_FACTION_A_REWARD"] = "[KONFIG] FRAKTION A BELOHNUNG"
Locales["CONFIG_FACTION_B_REWARD"] = "[KONFIG] FRAKTION B BELOHNUNG"
Locales["CONFIG_MULTIPLE_REWARDS"] = "[KONFIG] MEHRERE BELOHNUNGEN VERFÜGBAR!"