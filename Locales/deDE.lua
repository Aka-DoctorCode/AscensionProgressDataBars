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
Locales["CONFIG_MODE"] = "Einstellungen"
Locales["CONFIG_MODE_DESC"] = "Zeigt eine Testbar, um die Veränderungen in Echtzeit zu sehen."
Locales["FACTION_STANDINGS_RESET"] = "Standardwerte"
Locales["EMPTY"] = "(Leer)"

-- Tabs
Locales["TAB_BARS_LAYOUT"] = "Balken-Layout"
Locales["TAB_TEXT_LAYOUT"] = "Text-Layout"
Locales["TAB_BEHAVIOR"] = "Verhalten"
Locales["TAB_COLORS"] = "Farben"
Locales["TAB_PARAGON_ALERTS"] = "Paragon-Benachrichtigungen"

-- Global Controls
Locales["ENABLE"] = "Aktivieren"
Locales["ORDER"] = "Reihenfolge"
Locales["ANCHOR"] = "Anker"
Locales["TOP"] = "Oben"
Locales["BOTTOM"] = "Unten"
Locales["FREE"] = "Frei"
Locales["WIDTH"] = "Breite"
Locales["HEIGHT"] = "Höhe"
Locales["POS_X"] = "Pos X"
Locales["POS_Y"] = "Pos Y"
Locales["TXT_X"] = "Txt X"
Locales["TXT_Y"] = "Txt Y"

-- Layout Tab
Locales["GLOBAL_POSITIONING"] = "Globale Positionierung"
Locales["GLOBAL_BLOCKS_OFFSET"] = "Globaler Block-Versatz"
Locales["GLOBAL_BAR_HEIGHT"] = "Globale Balkenhöhe"
Locales["BAR_MANAGEMENT"] = "Balken-Verwaltung"
Locales["TOP_BLOCK"] = "Oberer Block"
Locales["BOTTOM_BLOCK"] = "Unterer Block"
Locales["FREE_MODE"] = "Freier Modus"

-- Appearance / Text Layout Tab
Locales["TEXT_AND_FONT"] = "Text & Schriftart"
Locales["LAYOUT_MODE"] = "Layout-Modus"
Locales["ALL_IN_ONE_LINE"] = "Alles in einer Zeile"
Locales["MULTIPLE_LINES"] = "Mehrere Zeilen"
Locales["TEXT_FOLLOWS_BAR"] = "Text folgt seinem Balken"
Locales["TEXT_FOLLOWS_BAR_DESC"] = "Wenn deaktiviert, wird der Text am globalen Zentrum verankert."
Locales["FONT_SIZE"] = "Schriftgröße"
Locales["GLOBAL_TEXT_COLOR"] = "Globale Textfarbe"
Locales["TEXT_GROUP_POSITIONS"] = "Textgruppen-Positionen"
Locales["DETACH_GROUP"] = "Gruppe %d abtrennen"
Locales["DETACH_GROUP_DESC"] = "Gruppe %d global statt an den Balken verankern."
Locales["GROUP_X"] = "Gruppe %d X"
Locales["GROUP_Y"] = "Gruppe %d Y"
Locales["TEXT_MANAGEMENT"] = "Text-Verwaltung"
Locales["GROUP_1"] = "Gruppe 1"
Locales["GROUP_2"] = "Gruppe 2"
Locales["GROUP_3"] = "Gruppe 3"

-- Behavior Tab
Locales["AUTO_HIDE_LOGIC"] = "Auto-Verstecken Logik"
Locales["SHOW_ON_MOUSEOVER"] = "Zeigt nur bei Mouseover"
Locales["HIDE_IN_COMBAT"] = "Verstecke im Kampf"
Locales["HIDE_AT_MAX_LEVEL"] = "XP-Leiste bei maximalem Level ausblenden"
Locales["DATA_DISPLAY"] = "Datenanzeige"
Locales["SHOW_PERCENTAGE"] = "Zeige Prozente"
Locales["SHOW_ABSOLUTE_VALUES"] = "Zeige absolute Werte"
Locales["SHOW_SPARK"] = "Zeige Funken"

-- Colors Tab
Locales["EXPERIENCE"] = "Erfahrung"
Locales["USE_CLASS_COLOR"] = "Benutze Klassen Farben"
Locales["CUSTOM_XP_COLOR"] = "Benutzerdefinierte XP Farbe"
Locales["SHOW_RESTED_BAR"] = "Zeige Erholt Bar"
Locales["RESTED_COLOR"] = "Erholt Farbe"
Locales["REPUTATION"] = "Ruf"
Locales["USE_REACTION_COLORS"] = "Benutze Reaktions Farben"
Locales["CUSTOM_REP_COLOR"] = "Benutzerdefinierte Reaktions Farben"
Locales["HONOR"] = "Ehre"
Locales["HONOR_COLOR"] = "Ehre Farbe"
Locales["HOUSE_FAVOR"] = "Haus Ehrfahrung"
Locales["HOUSE_XP_COLOR"] = "Haus Ehrfahrungs Farbe"
Locales["HOUSE_REWARD_COLOR"] = "Belohnungs Text Farbe"
Locales["HOUSE_REWARD_Y_OFFSET"] = "Belohnungs Text Y-Offset"
Locales["AZERITE"] = "Azerite"
Locales["AZERITE_COLOR"] = "Azerite Farbe"
Locales["RANK_NUM"] = "Rang %d"

-- Paragon Alerts Tab
Locales["ALERT_STYLING"] = "Alarm-Stil"
Locales["SHOW_ON_TOP"] = "Zeige oben"
Locales["SPLIT_LINES"] = "Splitte die Linien"
Locales["TEXT_SIZE"] = "Text Größe"
Locales["VERTICAL_OFFSET_Y"] = "Vertikaler Versatz (Y)"
Locales["ALERT_COLOR"] = "Alarm Farbe"

-- Standing Data
Locales["HATED"] = "Hasserfüllt"
Locales["HOSTILE"] = "Feindselig"
Locales["UNFRIENDLY"] = "Unfreundlich"
Locales["NEUTRAL"] = "Neutral"
Locales["FRIENDLY"] = "Freundlich"
Locales["HONORED"] = "Wohlwollend"
Locales["REVERED"] = "Respektvoll"
Locales["EXALTED"] = "Ehrfürchtig"
Locales["PARAGON"] = "Paragon"
Locales["MAXED"] = "Ausgereizt"
Locales["RENOWN"] = "Bekanntheit"
Locales["UNKNOWN_FACTION"] = "Unbekannte Fraktion"
Locales["UNKNOWN_STANDING"] = "???"

-- Formats
Locales["LEVEL_TEXT_ABS_PCT"] = "Stufe %d | %s/%s (%.1f%%)"
Locales["LEVEL_TEXT_ABS"] = "Stufe %d | %s/%s"
Locales["LEVEL_TEXT_PCT"] = "Stufe %d | %.1f%%"
Locales["LEVEL_TEXT"] = "Stufe %d"
Locales["RESTED_TEXT"] = " | Erholt %.1f%%"
Locales["RENOWN_LEVEL"] = "Renown %d"

-- Other Legacy Keys
Locales["APPEARANCE"] = "Erscheinungsbild"
Locales["BAR_ANCHOR"] = "Balkenposition"
Locales["BAR_GAP"] = "Balkenabstand"
Locales["BAR_GAP_DESC"] = "Abstand zwischen Balken."
Locales["ANCHOR_TOP"] = "Oben (Standard)"
Locales["ANCHOR_BOTTOM"] = "Unten"
Locales["ANCHOR_DESC"] = "Kontrolliert den Ankerpunkt der Bars. Oben: Bar ist oben, Text unten. Unten: Bars sind unten, Text oben. "
Locales["POSITION_SIZE"] = "Position & Größe"
Locales["VERTICAL_POSITION"] = "Vertikale Position (Y)"
Locales["TEXT_GAP"] = "Text Lücke"
Locales["XP_BAR_HEIGHT"] = "XP Bar Höhe"
Locales["REP_BAR_HEIGHT"] = "Ruf Bar Höhe"
Locales["VISIBILITY"] = "Sichtbarkeit"
Locales["COLORS"] = "Farben"
Locales["PARAGON_ALERTS"] = "Paragon Benachrichtigung"
Locales["FACTION_COLORS"] = "Fraktions Farbe"
Locales["ADVANCED"] = "Fortgeschritten"
Locales["REWARD_PENDING"] = " 'BELOHNUNG AUSSTEHEND!"
Locales["AND"] = " UND "
Locales["REWARD_PENDING_SINGLE"] = " BELOHNUNG AUSSTEHEND!"
Locales["REWARD_PENDING_PLURAL"] = " BELOHNUNG AUSSTEHEND!"
Locales["XP_BAR_DATA"] = "Erfahrungs Bar Daten | 0/0 (0.0%)"
Locales["REP_BAR_DATA"] = "Ruf Bar Daten | 0/0 (0.0%)"
Locales["CONFIG_FACTION_A_REWARD"] = "[CONFIG] FRAKTION EINE BELOHNUNG"
Locales["CONFIG_FACTION_B_REWARD"] = "[CONFIG] FRAKTION ZWEI BELOHNUNG"
Locales["CONFIG_MULTIPLE_REWARDS"] = "[CONFIG] MEHRERE BELOHNUNGEN STEHEN AUS!"
Locales["REWARD_PENDING_STATUS"] = "Belohnung ausstehend"
Locales["OPTIONAL_BARS"] = "Optionale Bars"
Locales["ENABLE_HONOR_BAR"] = "Aktiviere Ehre Bar"
Locales["HONOR_BAR_DATA"] = "Ehre: 0%"
Locales["HONOR_BAR_HEIGHT"] = "Ehre Bar Höhe"
Locales["ENABLE_HOUSE_XP_BAR"] = "Aktiviere Ehre Favoriten Bar"
Locales["HOUSE_XP"] = "Haus Ehrfahrung"
Locales["HOUSE_XP_BAR_DATA"] = "Haus Level 0 | 0/0 (0.0%)"
Locales["ENABLE_AZERITE_BAR"] = "Aktiviere Azerite Bar"
Locales["AZERITE_BAR_DATA"] = "Azerite Stärke: 0%"
Locales["AZERITE_BAR_HEIGHT"] = "Azerite Bar Höhe"
Locales["HOUSE_BAR_HEIGHT"] = "Haus Bar Höhe"
Locales["ENABLE_BAR"] = "Aktiviere Barra"
Locales["LAYOUT_BLOCK"] = "Layout Block"
Locales["BAR_ORDER"] = "Position"
Locales["BAR_WIDTH"] = "Breite"
Locales["BAR_HEIGHT"] = "Höhe"
Locales["LAYOUT"] = "Layout"
Locales["HOUSING_FAVOR"] = "Haus Ehrfahrung"
Locales["READY"] = "Bereit"
Locales["REWARD_AVAILABLE"] = "Belohnung zum Abholen verfügbar"
Locales["REWARD_ON_CHAR"] = "Belohnung verfügbar auf %s"
Locales["HOUSING_UPGRADE_READY"] = "HAUS-UPGRADE BEREIT"