-------------------------------------------------------------------------------
-- Project: AscensionBars
-- Author: Aka-DoctorCode
-- File: esES.lua
-- Version: @project-version@
-------------------------------------------------------------------------------
-- Copyright (c) 2025–2026 Aka-DoctorCode. All Rights Reserved.
--
-- This software and its source code are the exclusive property of the author.
-- No part of this file may be copied, modified, redistributed, or used in
-- derivative works without express written permission.
-------------------------------------------------------------------------------

local _, addonTable = ...
local Locales = LibStub("AceLocale-3.0"):NewLocale("AscensionBars", "esES") or
    LibStub("AceLocale-3.0"):NewLocale("AscensionBars", "esMX")

if not Locales then return end

-- General Configuration
Locales["ADDON_NAME"] = "Ascension Bars"
Locales["CONFIG_MODE"] = "Modo Configuración"
Locales["CONFIG_MODE_DESC"] = "Muestra barras de prueba para visualizar cambios en tiempo real."
Locales["FACTION_STANDINGS_RESET"] = "Restablecer valores predeterminados"
Locales["EMPTY"] = "(Vacío)"
Locales["AND"] = " Y "
Locales["CONFIG_MODULE_MISSING"] = "AscensionBars: Módulo de configuración no encontrado."
Locales["TOGGLE_CONFIG_WINDOW"] = "Alternar ventana de configuración"

-- Tabs
Locales["TAB_BARS_LAYOUT"] = "Diseño de Barras"
Locales["TAB_TEXT_LAYOUT"] = "Diseño de Texto"
Locales["TAB_BEHAVIOR"] = "Comportamiento"
Locales["TAB_COLORS"] = "Colores"
Locales["TAB_PARAGON_ALERTS"] = "Alertas de Paragon"

-- UI Controls & Labels
Locales["ENABLE"] = "Habilitar"
Locales["ANCHOR"] = "Ancla"
Locales["TOP"] = "Arriba"
Locales["BOTTOM"] = "Abajo"
Locales["FREE"] = "Libre"
Locales["ORDER"] = "Orden"
Locales["WIDTH"] = "Ancho"
Locales["HEIGHT"] = "Altura"
Locales["POS_X"] = "Posición X"
Locales["POS_Y"] = "Posición Y"
Locales["TXT_X"] = "Desplazamiento X del texto"
Locales["TXT_Y"] = "Desplazamiento Y del texto"
Locales["GLOBAL_BLOCKS_OFFSET"] = "Desplazamiento global de bloques"
Locales["GLOBAL_BAR_HEIGHT"] = "Altura global de la barra"
Locales["GLOBAL_OFFSET"] = "Desplazamiento global"
Locales["BAR_MANAGEMENT"] = "Gestión de barras"
Locales["TOP_BLOCK"] = "Bloque superior"
Locales["BOTTOM_BLOCK"] = "Bloque inferior"
Locales["FREE_MODE"] = "Modo libre"

-- Experience Bar
Locales["EXPERIENCE"] = "Experiencia"
Locales["XP_BAR_DATA"] = "Datos de la barra de experiencia | 0/0 (0.0%)"
Locales["XP_BAR_CONFIG_TEXT"] = "Experiencia: 75% (Descanso)"
Locales["RESTED_XP"] = "Experiencia de descanso"
Locales["LEVEL_TEXT"] = "Nivel %d"
Locales["LEVEL_TEXT_PCT"] = "%d | %d%%"
Locales["LEVEL_TEXT_ABS"] = "%d | %s / %s"
Locales["LEVEL_TEXT_ABS_PCT"] = "%d | %s / %s (%d%%)"
Locales["RESTED_TEXT"] = " (+%d%%)"

-- Reputation Bar
Locales["REPUTATION"] = "Reputación"
Locales["REP_BAR_DATA"] = "Datos de la barra de reputación | 0/0 (0.0%)"
Locales["PARAGON"] = "Paragon"
Locales["RENOWN_LEVEL"] = "Nivel de Renombre"
Locales["REWARD_PENDING_STATUS"] = "Recompensa pendiente"
Locales["REWARD_PENDING_SINGLE"] = " ¡RECOMPENSA PENDIENTE!"
Locales["REWARD_PENDING_PLURAL"] = " ¡RECOMPENSAS PENDIENTES!"

-- Reputation Display Patterns
Locales["REP_LABEL_FORMAT"] = "%s (%s)"
Locales["REP_VALUE_FORMAT_FULL"] = "%s / %s (%.1f%%)"
Locales["REP_VALUE_FORMAT_PCT"] = "(%.1f%%)"

-- Honor Bar
Locales["HONOR"] = "Honor"
Locales["ENABLE_HONOR_BAR"] = "Habilitar barra de honor"
Locales["HONOR_BAR_DATA"] = "Honor: 0%"
Locales["HONOR_BAR_HEIGHT"] = "Altura de la barra de honor"
Locales["HONOR_LEVEL_FORMAT"] = "Nivel de honor %d | %s/%s (%.1f%%)"

-- Azerite Bar
Locales["AZERITE"] = "Azerite"
Locales["ENABLE_AZERITE_BAR"] = "Habilitar barra de Azerit"
Locales["AZERITE_BAR_DATA"] = "Poder de Azerit: 0%"
Locales["AZERITE_BAR_HEIGHT"] = "Altura de la barra de Azerit"
Locales["AZERITE_LEVEL_FORMAT"] = "Nivel de Azerit %d | %s/%s (%.1f%%)"

-- Housing Favor Bar
Locales["HOUSE_FAVOR"] = "Favor de la casa"
Locales["ENABLE_HOUSE_XP_BAR"] = "Habilitar barra de experiencia de la casa"
Locales["HOUSE_XP"] = "Favor de la casa"
Locales["HOUSE_BAR_HEIGHT"] = "Altura de la barra de la casa"
Locales["HOUSE_LEVEL_FORMAT"] = "%s | Nivel %d | %s / %s (%.1f%%)"
Locales["HOUSE_LEVEL_SIMPLE"] = "%s | Nivel %d"
Locales["HOUSE_UPGRADES_AVAILABLE"] = "MEJORAS DE CASA DISPONIBLES PARA %s"

-- Appearance Tab
Locales["TEXT_AND_FONT"] = "Texto y fuente"
Locales["LAYOUT_MODE"] = "Modo de diseño"
Locales["ALL_IN_ONE_LINE"] = "Todo en una línea"
Locales["MULTIPLE_LINES"] = "Múltiples líneas"
Locales["TEXT_FOLLOWS_BAR"] = "El texto sigue a la barra"
Locales["TEXT_FOLLOWS_BAR_DESC"] = "El grupo de texto 1 seguirá la posición de la barra activa más baja."
Locales["FONT_SIZE"] = "Tamaño de fuente"
Locales["GLOBAL_TEXT_COLOR"] = "Color de texto global"
Locales["TEXT_GROUP_POSITIONS"] = "Posiciones del grupo de texto"
Locales["DETACH_GROUP"] = "Desvincular grupo %d"
Locales["DETACH_GROUP_DESC"] = "Permitir que el grupo %d se posicione de forma independiente."
Locales["GROUP_X"] = "Desplazamiento X del grupo %d"
Locales["GROUP_Y"] = "Desplazamiento Y del grupo %d"
Locales["TEXT_SIZE"] = "Tamaño de fuente"
Locales["TEXT_MANAGEMENT"] = "Gestión de texto"
Locales["GROUP_1"] = "Grupo 1"
Locales["GROUP_2"] = "Grupo 2"
Locales["GROUP_3"] = "Grupo 3"

-- Behavior Tab
Locales["AUTO_HIDE_LOGIC"] = "Lógica de ocultación automática"
Locales["SHOW_ON_MOUSEOVER"] = "Mostrar al pasar el mouse"
Locales["HIDE_IN_COMBAT"] = "Ocultar en combate"
Locales["HIDE_AT_MAX_LEVEL"] = "Ocultar al nivel máximo"
Locales["DATA_DISPLAY"] = "Visualización de datos"
Locales["SHOW_PERCENTAGE"] = "Mostrar porcentaje"
Locales["SHOW_ABSOLUTE_VALUES"] = "Mostrar valores absolutos"
Locales["SHOW_SPARK"] = "Mostrar chispa"

-- Colors Tab
Locales["USE_CLASS_COLOR"] = "Usar color de clase"
Locales["CUSTOM_XP_COLOR"] = "Color de experiencia personalizado"
Locales["SHOW_RESTED_BAR"] = "Mostrar barra de descanso"
Locales["RESTED_COLOR"] = "Color de descanso"
Locales["USE_REACTION_COLORS"] = "Usar colores de reacción"
Locales["CUSTOM_REP_COLOR"] = "Color de reputación personalizado"
Locales["HONOR_COLOR"] = "Color de honor"
Locales["HOUSE_XP_COLOR"] = "Color de favor de la casa"
Locales["HOUSE_REWARD_COLOR"] = "Color de texto de recompensa de la casa"
Locales["HOUSE_REWARD_Y_OFFSET"] = "Desplazamiento Y de recompensa de la casa"
Locales["AZERITE_COLOR"] = "Color de Azerit"

-- Reputation Standings
Locales["HATED"] = "Odiado"
Locales["HOSTILE"] = "Hostil"
Locales["UNFRIENDLY"] = "No amigable"
Locales["NEUTRAL"] = "Neutral"
Locales["FRIENDLY"] = "Amistoso"
Locales["HONORED"] = "Honrado"
Locales["REVERED"] = "Reverenciado"
Locales["EXALTED"] = "Exaltado"
Locales["MAXED"] = "Al Máximo"
Locales["RENOWN"] = "Renombre"
Locales["RANK_NUM"] = "Rango %d"

-- Paragon Alerts
Locales["ALERT_STYLING"] = "Estilo de alerta"
Locales["SHOW_ON_TOP"] = "Mostrar arriba"
Locales["SPLIT_LINES"] = "Dividir líneas"
Locales["VERTICAL_OFFSET_Y"] = "Desplazamiento vertical Y"
Locales["ALERT_COLOR"] = "Color de alerta"
Locales["REWARD_AVAILABLE"] = "RECOMPENSA DISPONIBLE PARA SER RECOGIDA"
Locales["REWARD_ON_CHAR"] = "RECOMPENSA DISPONIBLE EN %s"
Locales["PARAGON_TEXT_SIZE"] = "Tamaño de texto de alerta"
Locales["PARAGON_TEXT_Y"] = "Desplazamiento Y de alerta"
Locales["PARAGON_ON_TOP"] = "Mostrar alerta en la parte superior de la pantalla"

-- Config/Preview Strings
Locales["CONFIG_FACTION_A_REWARD"] = "[CONFIG] RECOMPENSA DE FACCIÓN A"
Locales["CONFIG_FACTION_B_REWARD"] = "[CONFIG] RECOMPENSA DE FACCIÓN B"
Locales["CONFIG_MULTIPLE_REWARDS"] = "[CONFIG] ¡MÚLTIPLES RECOMPENSAS PENDIENTES!"