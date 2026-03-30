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
local Locales = _G.LibStub("AceLocale-3.0"):NewLocale("AscensionProgressDataBars", "deDE", true)
if not Locales then return end

-------------------------------------------------------------------------------
-- GENERAL
-------------------------------------------------------------------------------
Locales["ADDON_NAME"] = "Aufstiegsfortschrittsbalken"
Locales["CONFIG_MODE"] = "Konfigurationsmodus"
Locales["CONFIG_MODE_DESC"] = "Zeige Testbalken an, um Änderungen in Echtzeit zu visualisieren."
Locales["FACTION_STANDINGS_RESET"] = "Auf Standard zurücksetzen"
Locales["EMPTY"] = "Leer"
Locales["AND"] = " UND "
Locales["CONFIG_MODULE_MISSING"] = "AscensionBars: Konfigurationsmodul nicht gefunden."
Locales["TOGGLE_CONFIG_WINDOW"] = "Konfigurationsfenster umschalten"

-------------------------------------------------------------------------------
-- CAROUSEL GAINS
-------------------------------------------------------------------------------
Locales["Experience"] = "Erfahrung"
Locales["Reputation"] = "Ruf"
Locales["House XP"] = "Haus-EP"
Locales["Honor"] = "Ehre"
Locales["Azerite"] = "Azerit"

-------------------------------------------------------------------------------
-- TABS
-------------------------------------------------------------------------------
Locales["TAB_BARS_LAYOUT"] = "Balkenlayout"
Locales["TAB_CUSTOM_GRID"] = "Benutzerdefinierte Balken"
Locales["TAB_TEXT_LAYOUT"] = "Textlayout"
Locales["TAB_BEHAVIOR"] = "Verhalten"
Locales["TAB_COLORS"] = "Farben"
Locales["TAB_PARAGON_ALERTS"] = "Warnungen"
Locales["TAB_PROFILES"] = "Profile"

-------------------------------------------------------------------------------
-- UI CONTROLS & LABELS
-------------------------------------------------------------------------------
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
Locales["GLOBAL_BAR_HEIGHT"] = "Globale Balkenhöhe"
Locales["GLOBAL_OFFSET"] = "Globaler Versatz"
Locales["GLOBAL_SETTINGS"] = "Globale Einstellungen"
Locales["PER_BLOCK_OFFSET"] = "Versatz pro Block verwenden"
Locales["PER_BLOCK_GAP"] = "Abstand pro Block verwenden"
Locales["BAR_GAP"] = "Globaler Abstand zwischen Balken"
Locales["TOP_OFFSET"] = "Versatz oberer Block"
Locales["BOTTOM_OFFSET"] = "Versatz unterer Block"
Locales["BLOCK_HEIGHT"] = "Blockhöhe"
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
Locales["TOP_GAP"] = "Abstand oberer Block"
Locales["BOTTOM_GAP"] = "Abstand unterer Block"
Locales["BAR_MANAGEMENT"] = "Balkenverwaltung"
Locales["TOP_BLOCK"] = "Oberer Block"
Locales["BOTTOM_BLOCK"] = "Unterer Block"
Locales["FREE_MODE"] = "Freier Modus"
Locales["DIM_ALPHA"] = "Dunkelalpha"
Locales["CAROUSEL_OPTIONS"] = "Karussell-Optionen"
Locales["CAROUSEL_X_OFFSET"] = "X-Versatz"
Locales["CAROUSEL_Y_OFFSET"] = "Y-Versatz"
Locales["CAROUSEL_BG_ALPHA"] = "Hintergrundalpha"

-------------------------------------------------------------------------------
-- EXPERIENCE BAR
-------------------------------------------------------------------------------
Locales["EXPERIENCE"] = "Erfahrung"
Locales["XP_BAR_DATA"] = "Erfahrungsbalken-Daten | 0/0 (0,0%)"
Locales["XP_BAR_CONFIG_TEXT"] = "Erfahrung: 75 % (Ruhe)"
Locales["RESTED_XP"] = "Ruhe-EP"
Locales["RESTED_TEXT"] = "Ruhe"
Locales["LEVEL_TEXT"] = "Stufe %d"
Locales["LEVEL_TEXT_ABS_PCT"] = "Stufe %d | %s / %s (%.1f%%)"
Locales["LEVEL_TEXT_ABS"] = "Stufe %d | %s / %s"
Locales["LEVEL_TEXT_PCT"] = "Stufe %d | %.1f%%"
Locales["RESTED_LABEL"] = "Ruhe: %s"

-------------------------------------------------------------------------------
-- REPUTATION BAR
-------------------------------------------------------------------------------
Locales["REPUTATION"] = "Ruf"
Locales["REP_BAR_DATA"] = "Rufbalken-Daten | 0/0 (0,0%)"
Locales["PARAGON"] = "Paragon"
Locales["RENOWN_LEVEL"] = "Ansehensstufe"
Locales["REWARD_PENDING_STATUS"] = "Belohnung ausstehend"
Locales["REWARD_PENDING_SINGLE"] = " BELOHNUNG AUSSTEHEND!"
Locales["REWARD_PENDING_PLURAL"] = " BELOHNUNGEN AUSSTEHEND!"
Locales["ADD_CUSTOM_REPUTATION"] = "Benutzerdefinierten Ruf hinzufügen"
Locales["SEARCH_FACTION"] = "Fraktion suchen"
Locales["SELECT_FACTION"] = "Fraktion auswählen"
Locales["ADD"] = "Hinzufügen"
Locales["DELETE"] = "Löschen"

-- Reputation Display Patterns
Locales["REP_LABEL_FORMAT"] = "%s (%s)"
Locales["REP_VALUE_FORMAT_FULL"] = "%s / %s (%.1f%%)"
Locales["REP_VALUE_FORMAT_PCT"] = "(%.1f%%)"

-------------------------------------------------------------------------------
-- HONOR BAR
-------------------------------------------------------------------------------
Locales["HONOR"] = "Ehre"
Locales["HONOR_LEVEL_SIMPLE"] = "Ehrenstufe %d"
Locales["ENABLE_HONOR_BAR"] = "Ehrenbalken aktivieren"
Locales["HONOR_BAR_DATA"] = "Ehre: 0%"
Locales["HONOR_BAR_HEIGHT"] = "Höhe Ehrenbalken"
Locales["HONOR_LEVEL_FORMAT"] = "Ehrenstufe %d | %s/%s (%.1f%%)"

-------------------------------------------------------------------------------
-- AZERITE BAR
-------------------------------------------------------------------------------
Locales["AZERITE"] = "Azerit"
Locales["ENABLE_AZERITE_BAR"] = "Azeritbalken aktivieren"
Locales["AZERITE_BAR_DATA"] = "Azeritkraft: 0%"
Locales["AZERITE_BAR_HEIGHT"] = "Höhe Azeritbalken"
Locales["AZERITE_LEVEL_FORMAT"] = "Azeritstufe %d | %s/%s (%.1f%%)"

-------------------------------------------------------------------------------
-- HOUSING FAVOR BAR
-------------------------------------------------------------------------------
Locales["HOUSE_FAVOR"] = "Hausgunststufe"
Locales["ENABLE_HOUSE_XP_BAR"] = "Hausgunstbalken aktivieren"
Locales["HOUSE_XP"] = "Hausgunst"
Locales["HOUSE_BAR_HEIGHT"] = "Höhe Hausbalken"
Locales["HOUSE_LEVEL_FORMAT"] = "%s Stufe %d | %s / %s (%.1f%%)"
Locales["HOUSE_LEVEL_ABS"]    = "%s Stufe %d | %s / %s"
Locales["HOUSE_LEVEL_PCT"]    = "%s Stufe %d | (%.1f%%)"
Locales["HOUSE_LEVEL_SIMPLE"] = "%s Stufe %d"
Locales["HOUSE_UPGRADES_AVAILABLE"] = "HAUSVERBESSERUNGEN VERFÜGBAR FÜR %s"

-------------------------------------------------------------------------------
-- TEXT LAYOUT TAB
-------------------------------------------------------------------------------
Locales["TEXT_AND_FONT"] = "Text und Schriftart"
Locales["LAYOUT_MODE"] = "Layout-Modus"
Locales["ALL_IN_ONE_LINE"] = "Alles in einer Zeile"
Locales["MULTIPLE_LINES"] = "Mehrere Zeilen"
Locales["TEXT_FOLLOWS_BAR"] = "Text folgt Balken"
Locales["TEXT_FOLLOWS_BAR_DESC"] = "Textgruppe 1 folgt der Position des untersten aktiven Balkens."
Locales["FONT_SIZE"] = "Schriftgröße"
Locales["GLOBAL_TEXT_COLOR"] = "Globale Textfarbe"
Locales["TEXT_GROUP_POSITIONS"] = "Positionen der Textgruppen"
Locales["DETACH_GROUP"] = "Gruppe %d abkoppeln"
Locales["DETACH_GROUP_DESC"] = "Ermöglicht die unabhängige Positionierung von Gruppe %d."
Locales["GROUP_X"] = "X-Versatz Gruppe %d"
Locales["GROUP_Y"] = "Y-Versatz Gruppe %d"
Locales["TEXT_MANAGEMENT"] = "Textverwaltung"
Locales["TEXT_SIZE"] = "Textgröße"
Locales["GROUP_1"] = "Gruppe 1"
Locales["GROUP_2"] = "Gruppe 2"
Locales["GROUP_3"] = "Gruppe 3"

-------------------------------------------------------------------------------
-- BEHAVIOR TAB
-------------------------------------------------------------------------------
Locales["AUTO_HIDE_LOGIC"] = "Automatisches Ausblenden"
Locales["SHOW_ON_MOUSEOVER"] = "Bei Mauskontakt anzeigen"
Locales["HIDE_IN_COMBAT"] = "Im Kampf ausblenden"
Locales["HIDE_AT_MAX_LEVEL"] = "EP-Balken bei Maximalstufe ausblenden"
Locales["DATA_DISPLAY"] = "Datenanzeige"
Locales["SHOW_PERCENTAGE"] = "Prozentsatz anzeigen"
Locales["SHOW_ABSOLUTE_VALUES"] = "Absolute Werte anzeigen"
Locales["SHOW_SPARK"] = "Glanz anzeigen"

-------------------------------------------------------------------------------
-- COLORS TAB
-------------------------------------------------------------------------------
Locales["USE_CLASS_COLOR"] = "Klassenfarbe verwenden"
Locales["CUSTOM_XP_COLOR"] = "Benutzerdefinierte EP-Farbe"
Locales["SHOW_RESTED_BAR"] = "Ruhebalken anzeigen"
Locales["RESTED_COLOR"] = "Ruhefarbe"
Locales["USE_REACTION_COLORS"] = "Reaktionsfarben verwenden"
Locales["CUSTOM_REP_COLOR"] = "Benutzerdefinierte Ruf-Farbe"
Locales["HONOR_COLOR"] = "Ehrenfarbe"
Locales["HOUSE_XP_COLOR"] = "Farbe Hausgunst"
Locales["HOUSE_REWARD_COLOR"] = "Farbe Hausbelohnungstext"
Locales["HOUSE_REWARD_Y_OFFSET"] = "Y-Versatz Hausbelohnung"
Locales["AZERITE_COLOR"] = "Azeritfarbe"

-------------------------------------------------------------------------------
-- REPUTATION STANDINGS
-------------------------------------------------------------------------------
Locales["HATED"] = "Gehasst"
Locales["HOSTILE"] = "Feindselig"
Locales["UNFRIENDLY"] = "Unfreundlich"
Locales["NEUTRAL"] = "Neutral"
Locales["FRIENDLY"] = "Freundlich"
Locales["HONORED"] = "Respektvoll"
Locales["REVERED"] = "Ehrfürchtig"
Locales["EXALTED"] = "Erhaben"
Locales["MAXED"] = "Maximal"
Locales["RENOWN"] = "Ansehen"
Locales["RANK_NUM"] = "Rang %d"

-------------------------------------------------------------------------------
-- PARAGON ALERTS
-------------------------------------------------------------------------------
Locales["ALERT_STYLING"] = "Warnungsstil"
Locales["SPLIT_LINES"] = "Zeilen teilen"
Locales["ALERT_COLOR"] = "Warnungsfarbe"
Locales["REWARD_AVAILABLE"] = "BELOHNUNG ZUM ABHOLEN BEREIT"
Locales["REWARD_ON_CHAR"] = "BELOHNUNG AUF %s VERFÜGBAR"
Locales["PARAGON_TEXT_SIZE"] = "Warnungstextgröße"

-------------------------------------------------------------------------------
-- CUSTOM GRID MODE
-------------------------------------------------------------------------------
Locales["CUSTOM_GRID"] = "Benutzerdefinierte Balken"
Locales["CUSTOM_GRID_ENABLE"] = "Benutzerdefiniertes Rasterlayout aktivieren"
Locales["CUSTOM_GRID_DESC"] = "Aktivieren, um ein mehrspaltiges Layout zu erstellen. Wenn aktiviert, wird die Standardreihenfolge der Balken ignoriert und die Balken werden genau in der von Ihnen zugewiesenen Zeile und Spalte platziert."
Locales["ENABLE_ADVANCED_GRID"] = "Benutzerdefiniertes Raster (Erweitert) aktivieren"
Locales["CUSTOM_GRID_DISABLED_MSG"] = "Benutzerdefiniertes Raster (Erweitert) oben aktivieren, um benutzerdefinierte Layouts zu konfigurieren."
Locales["GRID_OPTIONS"] = "Rasterkonfiguration"
Locales["GRID_ROWS"] = "Gesamtzeilen"
Locales["GRID_COLS_FOR_ROW"] = "Spalten für Zeile %d"
Locales["GRID_CELL"] = "Zeile %d - Spalte %d"
Locales["GRID_PRESET"] = "Layout-Voreinstellung"
Locales["PRESET_CUSTOM"] = "Benutzerdefiniert"
Locales["PRESET_2X1"] = "2x1 (2 Zeilen, 1 Spalte)"
Locales["PRESET_2X2"] = "2x2 (2 Zeilen, 2 Spalten)"
Locales["PRESET_3X2"] = "3x2 (3 Zeilen, 2 Spalten)"
Locales["ASSIGN_BAR"] = "Balken zuweisen"

-------------------------------------------------------------------------------
-- TEXT LAYOUT (additional)
-------------------------------------------------------------------------------
Locales["BLOCK_TEXT_MODE"] = "Textverhalten"
Locales["TEXT_VISIBILITY_MODE"] = "Textsichtbarkeitsmodus"
Locales["FOCUS_MODE"] = "Bei Mauskontakt anzeigen"
Locales["GRID_DYNAMIC"] = "Immer sichtbar"
Locales["NONE"] = "Keine"
Locales["BASE_TYPOGRAPHY"] = "Basistypografie"
Locales["FONT_OUTLINE"] = "Schriftkontur"
Locales["VISUAL_OPTIONS"] = "Visuelle Optionen"
Locales["SHOW_RESTED"] = "Ruhe-EP anzeigen"
Locales["USE_COMPACT_FORMAT"] = "Kompaktes Format"
Locales["EVENTS_VISIBILITY"] = "Sichtbarkeit"
Locales["ENABLE_CAROUSEL"] = "Ereignis-Karussell aktivieren"
Locales["LATERAL_LEGEND"] = "Seitliche Legende aktivieren"
Locales["DYNAMIC_GRID_GAP"] = "Rasterabstand"
Locales["LEGEND_OPTIONS"] = "Legendenoptionen"
Locales["LEGEND_TEXT_SIZE"] = "Legendentextgröße"
Locales["LEGEND_BG_ALPHA"] = "Hintergrundalpha"
Locales["LEGEND_FONT_OUTLINE"] = "Legenden-Schriftkontur"

-------------------------------------------------------------------------------
-- CONFIG / PREVIEW STRINGS
-------------------------------------------------------------------------------
Locales["CONFIG_FACTION_A_REWARD"] = "[KONFIG] BELOHNUNG FRAKTION A"
Locales["CONFIG_FACTION_B_REWARD"] = "[KONFIG] BELOHNUNG FRAKTION B"
Locales["CONFIG_MULTIPLE_REWARDS"] = "[KONFIG] MEHRERE BELOHNUNGEN AUSSTEHEND"

-------------------------------------------------------------------------------
-- PROFILES TAB
-------------------------------------------------------------------------------
Locales["PROFILES"] = "Profile"
Locales["PROFILE_DESC_1"] = "Sie können das aktive Datenbankprofil ändern, um unterschiedliche Einstellungen für jeden Charakter zu haben."
Locales["PROFILE_DESC_2"] = "Setzt das aktuelle Profil auf seine Standardwerte zurück."
Locales["RESET_PROFILE"] = "Profil zurücksetzen"
Locales["CURRENT_PROFILE"] = "Aktuelles Profil:"
Locales["PROFILE_DESC_3"] = "Erstellen Sie ein neues Profil oder wählen Sie ein vorhandenes."
Locales["NEW"] = "Neues Profil"
Locales["EXISTING_PROFILES"] = "Vorhandene Profile"
Locales["COPY_PROFILE_DESC"] = "Einstellungen von einem anderen Profil in das aktuelle kopieren."
Locales["COPY_FROM"] = "Kopieren von"
Locales["DELETE_PROFILE_DESC"] = "Löschen Sie nicht verwendete Profile, um Speicherplatz zu sparen."
Locales["DELETE_PROFILE"] = "Profil löschen"
Locales["DELETE_PROFILE_CONFIRM"] = "Profil '%s' löschen?"
Locales["ACCEPT"] = "Akzeptieren"
Locales["CANCEL"] = "Abbrechen"
Locales["YES"] = "Ja"
Locales["NO"] = "Nein"
Locales["IMPORT_PROFILE"] = "Profil importieren"
Locales["EXPORT_PROFILE"] = "Profil exportieren"
Locales["IMPORT_EXPORT_DESC"] = "Teilen Sie Ihre Konfiguration mit anderen."
Locales["CLOSE"] = "Schließen"
Locales["IMPORT"] = "Importieren"
Locales["RESET_CONFIRM"] = "Sind Sie sicher, dass Sie das Profil '%s' auf die Standardwerte zurücksetzen möchten?"