-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
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
local Locales = _G.LibStub("AceLocale-3.0"):NewLocale("AscensionBars", "deDE")

if not Locales then return end

-- General Configuration
Locales["ADDON_NAME"] = "Ascension Progress Data Bars"
Locales["CONFIG_MODE"] = "Konfigurationsmodus"
Locales["CONFIG_MODE_DESC"] = "Zeigt Testleisten an, um Änderungen in Echtzeit zu visualisieren."
Locales["FACTION_STANDINGS_RESET"] = "Standardwerte wiederherstellen"
Locales["EMPTY"] = "Leer"
Locales["AND"] = " UND "
Locales["CONFIG_MODULE_MISSING"] = "AscensionBars: Konfigurationsmodul nicht gefunden."
Locales["TOGGLE_CONFIG_WINDOW"] = "Konfigurationsfenster umschalten"

-- Tabs
Locales["TAB_BARS_LAYOUT"] = "Leistenlayout"
Locales["TAB_TEXT_LAYOUT"] = "Textlayout"
Locales["TAB_BEHAVIOR"] = "Verhalten"
Locales["TAB_COLORS"] = "Farben"
Locales["TAB_PARAGON_ALERTS"] = "Warnungen"
Locales["TAB_PROFILES"] = "Profile"

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
Locales["GLOBAL_BLOCKS_OFFSET"] = "Globaler Blockversatz"
Locales["GLOBAL_BAR_HEIGHT"] = "Globale Leistenhöhe"
Locales["GLOBAL_OFFSET"] = "Globaler Versatz"
Locales["GLOBAL_SETTINGS"] = "Globale Einstellungen"
Locales["PER_BLOCK_OFFSET"] = "Versatz pro Block verwenden"
Locales["PER_BLOCK_GAP"] = "Abstand pro Block verwenden"
Locales["BAR_GAP"] = "Globaler Abstand zwischen Leisten"
Locales["TOP_OFFSET"] = "Versatz des oberen Blocks"
Locales["BOTTOM_OFFSET"] = "Versatz des unteren Blocks"
Locales["BLOCK_HEIGHT"] = "Blockleistenhöhe"
Locales["USE_PER_BLOCK_HEIGHT"] = "Höhe pro Block verwenden"
Locales["USE_CUSTOM_HEIGHT"] = "Benutzerdefinierte Höhe verwenden"
Locales["CUSTOM_HEIGHT"] = "Benutzerdefinierte Höhe"
Locales["USE_PER_GROUP_SIZE"] = "Größe pro Gruppe verwenden"
Locales["USE_PER_GROUP_COLOR"] = "Farbe pro Gruppe verwenden"
Locales["USE_CUSTOM_TEXT_SIZE"] = "Benutzerdefinierte Textgröße verwenden"
Locales["USE_CUSTOM_TEXT_COLOR"] = "Benutzerdefinierte Textfarbe verwenden"
Locales["GROUP_SIZE"] = "Gruppentextgröße"
Locales["GROUP_COLOR"] = "Gruppentextfarbe"
Locales["CUSTOM_TEXT_SIZE"] = "Benutzerdefinierte Textgröße"
Locales["CUSTOM_TEXT_COLOR"] = "Benutzerdefinierte Textfarbe"
Locales["TOP_GAP"] = "Abstand des oberen Blocks"
Locales["BOTTOM_GAP"] = "Abstand des unteren Blocks"
Locales["BAR_MANAGEMENT"] = "Leistenverwaltung"
Locales["TOP_BLOCK"] = "Oberer Block"
Locales["BOTTOM_BLOCK"] = "Unterer Block"
Locales["FREE_MODE"] = "Freier Modus"
Locales["DIM_ALPHA"] = "Abgedunkelte Transparenz"
Locales["CAROUSEL_OPTIONS"] = "Karussell-Optionen"
Locales["CAROUSEL_X_OFFSET"] = "X-Versatz"
Locales["CAROUSEL_Y_OFFSET"] = "Y-Versatz"
Locales["CAROUSEL_BG_ALPHA"] = "Hintergrundtransparenz"

-- Experience Bar
Locales["EXPERIENCE"] = "Erfahrung"
Locales["XP_BAR_DATA"] = "Erfahrungsleistendaten | 0/0 (0.0%)"
Locales["XP_BAR_CONFIG_TEXT"] = "Erfahrung: 75% (Erholt)"
Locales["RESTED_XP"] = "Erholte EP"
Locales["RESTED_TEXT"] = "Erholt"
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
Locales["REWARD_PENDING_SINGLE"] = " BELOHNUNG AUSSTEHEND!"
Locales["REWARD_PENDING_PLURAL"] = " BELOHNUNGEN AUSSTEHEND!"

-- Reputation Display Patterns
Locales["REP_LABEL_FORMAT"] = "%s (%s)"
Locales["REP_VALUE_FORMAT_FULL"] = "%s / %s (%.1f%%)"
Locales["REP_VALUE_FORMAT_PCT"] = "(%.1f%%)"

-- Honor Bar
Locales["HONOR"] = "Ehre"
Locales["HONOR_LEVEL_SIMPLE"] = "Ehrestufe %d"
Locales["ENABLE_HONOR_BAR"] = "Ehreleiste aktivieren"
Locales["HONOR_BAR_DATA"] = "Ehre: 0%"
Locales["HONOR_BAR_HEIGHT"] = "Ehreleistenhöhe"
Locales["HONOR_LEVEL_FORMAT"] = "Ehrestufe %d | %s/%s (%.1f%%)"

-- Azerite Bar
Locales["AZERITE"] = "Azerit"
Locales["ENABLE_AZERITE_BAR"] = "Azeritleiste aktivieren"
Locales["AZERITE_BAR_DATA"] = "Azeritmacht: 0%"
Locales["AZERITE_BAR_HEIGHT"] = "Azeritleistenhöhe"
Locales["AZERITE_LEVEL_FORMAT"] = "Azeritstufe %d | %s/%s (%.1f%%)"

-- Housing Favor Bar
Locales["HOUSE_FAVOR"] = "Haus-Gunststufe"
Locales["ENABLE_HOUSE_XP_BAR"] = "Haus-Gunstleiste aktivieren"
Locales["HOUSE_XP"] = "Haus-Gunst"
Locales["HOUSE_BAR_HEIGHT"] = "Haus-Leistenhöhe"
Locales["HOUSE_LEVEL_FORMAT"] = "%s Stufe %d | %s / %s (%.1f%%)"
Locales["HOUSE_LEVEL_ABS"]    = "%s Stufe %d | %s / %s"
Locales["HOUSE_LEVEL_PCT"]    = "%s Stufe %d | (%.1f%%)"
Locales["HOUSE_LEVEL_SIMPLE"] = "%s Stufe %d"
Locales["HOUSE_UPGRADES_AVAILABLE"] = "HAUSAUFWERTUNGEN VERFÜGBAR FÜR %s"

-- Appearance Tab
Locales["TEXT_AND_FONT"] = "Text und Schriftart"
Locales["LAYOUT_MODE"] = "Layout-Modus"
Locales["ALL_IN_ONE_LINE"] = "Alles in einer Zeile"
Locales["MULTIPLE_LINES"] = "Mehrere Zeilen"
Locales["TEXT_FOLLOWS_BAR"] = "Text folgt der Leiste"
Locales["TEXT_FOLLOWS_BAR_DESC"] = "Textgruppe 1 folgt der Position der untersten aktiven Leiste."
Locales["FONT_SIZE"] = "Schriftgröße"
Locales["GLOBAL_TEXT_COLOR"] = "Globale Textfarbe"
Locales["TEXT_GROUP_POSITIONS"] = "Textgruppenpositionen"
Locales["DETACH_GROUP"] = "Gruppe %d abtrennen"
Locales["DETACH_GROUP_DESC"] = "Ermöglicht die unabhängige Positionierung von Gruppe %d."
Locales["GROUP_X"] = "Gruppe %d X-Versatz"
Locales["GROUP_Y"] = "Gruppe %d Y-Versatz"
Locales["TEXT_MANAGEMENT"] = "Textverwaltung"
Locales["TEXT_SIZE"] = "Textgröße"
Locales["GROUP_1"] = "Gruppe 1"
Locales["GROUP_2"] = "Gruppe 2"
Locales["GROUP_3"] = "Gruppe 3"

-- Behavior Tab
Locales["AUTO_HIDE_LOGIC"] = "Auto-Verbergen-Logik"
Locales["SHOW_ON_MOUSEOVER"] = "Bei Mouseover anzeigen"
Locales["HIDE_IN_COMBAT"] = "Im Kampf verbergen"
Locales["HIDE_AT_MAX_LEVEL"] = "EP-Leiste auf Maximalstufe verbergen"
Locales["DATA_DISPLAY"] = "Datenanzeige"
Locales["SHOW_PERCENTAGE"] = "Prozentsatz anzeigen"
Locales["SHOW_ABSOLUTE_VALUES"] = "Absolute Werte anzeigen"
Locales["SHOW_SPARK"] = "Funken anzeigen"

-- Colors Tab
Locales["USE_CLASS_COLOR"] = "Klassenfarbe verwenden"
Locales["CUSTOM_XP_COLOR"] = "Benutzerdefinierte EP-Farbe"
Locales["SHOW_RESTED_BAR"] = "Erholungsleiste anzeigen"
Locales["RESTED_COLOR"] = "Erholungsfarbe"
Locales["USE_REACTION_COLORS"] = "Reaktionsfarben verwenden"
Locales["CUSTOM_REP_COLOR"] = "Benutzerdefinierte Ruffarbe"
Locales["HONOR_COLOR"] = "Ehrefarbe"
Locales["HOUSE_XP_COLOR"] = "Haus-Gunstfarbe"
Locales["HOUSE_REWARD_COLOR"] = "Farbe des Hausbelohnungstextes"
Locales["HOUSE_REWARD_Y_OFFSET"] = "Y-Versatz für Hausbelohnung"
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
Locales["MAXED"] = "Maximal"
Locales["RENOWN"] = "Ruhm"
Locales["RANK_NUM"] = "Rang %d"

-- Paragon Alerts
Locales["ALERT_STYLING"] = "Warnungsstil"
Locales["SHOW_ON_TOP"] = "Oben anzeigen"
Locales["SPLIT_LINES"] = "Zeilen teilen"
Locales["VERTICAL_OFFSET_Y"] = "Vertikaler Versatz Y"
Locales["ALERT_COLOR"] = "Warnungsfarbe"
Locales["REWARD_AVAILABLE"] = "BELOHNUNG VERFÜGBAR ZUM ABHOLEN"
Locales["REWARD_ON_CHAR"] = "BELOHNUNG VERFÜGBAR AUF %s"
Locales["PARAGON_TEXT_SIZE"] = "Warnungstextgröße"
Locales["PARAGON_TEXT_Y"] = "Warnung Y-Versatz"
Locales["PARAGON_ON_TOP"] = "Warnung oben auf dem Bildschirm anzeigen"

-- Text Layout Tab
Locales["BLOCK_TEXT_MODE"] = "Textverhalten"
Locales["TEXT_VISIBILITY_MODE"] = "Sichtbarkeitsmodus für Text"
Locales["FOCUS_MODE"] = "Bei Mouseover anzeigen"
Locales["GRID_DYNAMIC"] = "Immer sichtbar"
Locales["NONE"] = "Keine"
Locales["BASE_TYPOGRAPHY"] = "Grundtypografie"
Locales["FONT_OUTLINE"] = "Schriftkontur"
Locales["VISUAL_OPTIONS"] = "Visuelle Optionen"
Locales["SHOW_RESTED"] = "Erholte EP anzeigen"
Locales["USE_COMPACT_FORMAT"] = "Kompaktes Format"
Locales["EVENTS_VISIBILITY"] = "Sichtbarkeit"
Locales["ENABLE_CAROUSEL"] = "Ereigniskarussell aktivieren"
Locales["LATERAL_LEGEND"] = "Seitliche Legende aktivieren"
Locales["DYNAMIC_GRID_GAP"] = "Rasterabstand"
Locales["LEGEND_OPTIONS"] = "Legenden-Optionen"
Locales["LEGEND_TEXT_SIZE"] = "Legendentextgröße"
Locales["LEGEND_BG_ALPHA"] = "Hintergrundtransparenz"
Locales["LEGEND_FONT_OUTLINE"] = "Legendenschriftkontur"

-- Config/Preview Strings
Locales["CONFIG_FACTION_A_REWARD"] = "[CONFIG] BELOHNUNG FRAKTION A"
Locales["CONFIG_FACTION_B_REWARD"] = "[CONFIG] BELOHNUNG FRAKTION B"
Locales["CONFIG_MULTIPLE_REWARDS"] = "[CONFIG] MEHRERE BELOHNUNGEN AUSSTEHEND!"

-- Custom Grid Mode
Locales["CUSTOM_GRID_ENABLE"] = "Benutzerdefiniertes Rasterlayout aktivieren"
Locales["CUSTOM_GRID_DESC"] = "Aktivieren, um ein benutzerdefiniertes mehrspaltiges Layout zu erstellen. Wenn aktiviert, wird die Standardreihenfolge ignoriert und die Leisten werden in genau der zugewiesenen Zeile und Spalte platziert."
Locales["GRID_OPTIONS"] = "Rasterkonfiguration"
Locales["GRID_ROWS"] = "Gesamtzeilen"
Locales["GRID_COLS_FOR_ROW"] = "Spalten für Zeile %d"
Locales["GRID_CELL"] = "Zeile %d - Spalte %d"

-- Grid Layout Presets
Locales["GRID_PRESET"] = "Layout-Voreinstellung"
Locales["PRESET_CUSTOM"] = "Benutzerdefiniert"
Locales["PRESET_2X1"] = "2x1 (2 Zeilen, 1 Spalte)"
Locales["PRESET_2X2"] = "2x2 (2 Zeilen, 2 Spalten)"
Locales["PRESET_3X2"] = "3x2 (3 Zeilen, 2 Spalten)"
Locales["ASSIGN_BAR"] = "Leiste zuweisen"

-- Profiles Tab
Locales["PROFILES"] = "Profile"
Locales["PROFILE_DESC_1"] = "Du kannst das aktive Datenbankprofil ändern, um unterschiedliche Einstellungen für jeden Charakter zu haben."
Locales["PROFILE_DESC_2"] = "Setzt das aktuelle Profil auf die Standardwerte zurück."
Locales["RESET_PROFILE"] = "Profil zurücksetzen"
Locales["CURRENT_PROFILE"] = "Aktuelles Profil:"
Locales["PROFILE_DESC_3"] = "Erstelle ein neues Profil oder wähle ein vorhandenes aus."
Locales["NEW"] = "Neues Profil"
Locales["EXISTING_PROFILES"] = "Vorhandene Profile"
Locales["COPY_PROFILE_DESC"] = "Kopiert die Einstellungen von einem anderen Profil in das aktuelle."
Locales["COPY_FROM"] = "Kopieren von"
Locales["DELETE_PROFILE_DESC"] = "Löscht nicht verwendete Profile, um Platz zu sparen."
Locales["DELETE_PROFILE"] = "Profil löschen"
Locales["DELETE_PROFILE_CONFIRM"] = "Profil '%s' löschen?"
Locales["ACCEPT"] = "Akzeptieren"
Locales["CANCEL"] = "Abbrechen"
Locales["YES"] = "Ja"
Locales["NO"] = "Nein"
Locales["IMPORT_PROFILE"] = "Profil importieren"
Locales["EXPORT_PROFILE"] = "Profil exportieren"
Locales["IMPORT_EXPORT_DESC"] = "Teile deine Konfiguration mit anderen."
Locales["CLOSE"] = "Schließen"
Locales["IMPORT"] = "Importieren"
Locales["RESET_CONFIRM"] = "Bist du sicher, dass du das Profil '%s' auf die Standardwerte zurücksetzen möchtest?"