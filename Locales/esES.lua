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
Locales["CONFIG_MODE"] = "Modo de Configuración"
Locales["CONFIG_MODE_DESC"] = "Muestra barras de prueba para visualizar los cambios en tiempo real."
Locales["FACTION_STANDINGS_RESET"] = "Restablecer Valores"
Locales["EMPTY"] = "(Vacío)"
Locales["AND"] = " Y "
Locales["CONFIG_MODULE_MISSING"] = "AscensionBars: Módulo de configuración no encontrado."
Locales["TOGGLE_CONFIG_WINDOW"] = "Alternar Ventana de Configuración"

-- Tabs
Locales["TAB_BARS_LAYOUT"] = "Diseño de Barras"
Locales["TAB_TEXT_LAYOUT"] = "Diseño de Texto"
Locales["TAB_BEHAVIOR"] = "Comportamiento"
Locales["TAB_COLORS"] = "Colores"
Locales["TAB_PARAGON_ALERTS"] = "Alertas"

-- UI Controls & Labels
Locales["ENABLE"] = "Habilitar"
Locales["ANCHOR"] = "Anclaje"
Locales["TOP"] = "Superior"
Locales["BOTTOM"] = "Inferior"
Locales["FREE"] = "Libre"
Locales["ORDER"] = "Orden"
Locales["WIDTH"] = "Ancho"
Locales["HEIGHT"] = "Alto"
Locales["POS_X"] = "Posición X"
Locales["POS_Y"] = "Posición Y"
Locales["TXT_X"] = "Desplazamiento X del Texto"
Locales["TXT_Y"] = "Desplazamiento Y del Texto"
Locales["GLOBAL_BLOCKS_OFFSET"] = "Desplazamiento Global de Bloques"
Locales["GLOBAL_BAR_HEIGHT"] = "Altura Global de Barra"
Locales["GLOBAL_OFFSET"] = "Desplazamiento Global"
Locales["GLOBAL_SETTINGS"] = "Configuración Global"
Locales["PER_BLOCK_OFFSET"] = "Usar Desplazamiento por Bloque"
Locales["PER_BLOCK_GAP"] = "Usar Separación por Bloque"
Locales["BAR_GAP"] = "Separación Global entre Barras"
Locales["TOP_OFFSET"] = "Desplazamiento del Bloque Superior"
Locales["BOTTOM_OFFSET"] = "Desplazamiento del Bloque Inferior"
Locales["BLOCK_HEIGHT"] = "Altura del Bloque"
Locales["USE_CUSTOM_HEIGHT"] = "Usar Altura Personalizada"
Locales["CUSTOM_HEIGHT"] = "Altura Personalizada"
Locales["TOP_GAP"] = "Separación del Bloque Superior"
Locales["BOTTOM_GAP"] = "Separación del Bloque Inferior"
Locales["BAR_MANAGEMENT"] = "Gestión de Barras"
Locales["TOP_BLOCK"] = "Bloque Superior"
Locales["BOTTOM_BLOCK"] = "Bloque Inferior"
Locales["FREE_MODE"] = "Modo Libre"

-- Experience Bar
Locales["EXPERIENCE"] = "Experiencia"
Locales["XP_BAR_DATA"] = "Datos de Barra de Experiencia | 0/0 (0.0%)"
Locales["XP_BAR_CONFIG_TEXT"] = "Experiencia: 75% (Descansado)"
Locales["RESTED_XP"] = "Experiencia Descansada"
Locales["LEVEL_TEXT"] = "Nivel %d"
Locales["LEVEL_TEXT_ABS_PCT"] = "Nivel %d | %s / %s (%.1f%%)"
Locales["LEVEL_TEXT_ABS"] = "Nivel %d | %s / %s"
Locales["LEVEL_TEXT_PCT"] = "Nivel %d | %.1f%%"
Locales["RESTED_LABEL"] = "Descanso: %s"

-- Reputation Bar
Locales["REPUTATION"] = "Reputación"
Locales["REP_BAR_DATA"] = "Datos de Barra de Reputación | 0/0 (0.0%)"
Locales["PARAGON"] = "Baluarte"
Locales["RENOWN_LEVEL"] = "Nivel de Renombre"
Locales["REWARD_PENDING_STATUS"] = "Recompensa Pendiente"
Locales["REWARD_PENDING_SINGLE"] = " ¡RECOMPENSA PENDIENTE!"
Locales["REWARD_PENDING_PLURAL"] = " ¡RECOMPENSAS PENDIENTES!"

-- Reputation Display Patterns
Locales["REP_LABEL_FORMAT"] = "%s (%s)"
Locales["REP_VALUE_FORMAT_FULL"] = "%s / %s (%.1f%%)"
Locales["REP_VALUE_FORMAT_PCT"] = "(%.1f%%)"

-- Honor Bar
Locales["HONOR"] = "Honor"
Locales["ENABLE_HONOR_BAR"] = "Habilitar Barra de Honor"
Locales["HONOR_BAR_DATA"] = "Honor: 0%"
Locales["HONOR_BAR_HEIGHT"] = "Altura de Barra de Honor"
Locales["HONOR_LEVEL_FORMAT"] = "Nivel de Honor %d | %s/%s (%.1f%%)"

-- Azerite Bar
Locales["AZERITE"] = "Azerita"
Locales["ENABLE_AZERITE_BAR"] = "Habilitar Barra de Azerita"
Locales["AZERITE_BAR_DATA"] = "Poder de Azerita: 0%"
Locales["AZERITE_BAR_HEIGHT"] = "Altura de Barra de Azerita"
Locales["AZERITE_LEVEL_FORMAT"] = "Nivel de Azerita %d | %s/%s (%.1f%%)"

-- Housing Favor Bar
Locales["HOUSE_FAVOR"] = "Favor de la Casa"
Locales["ENABLE_HOUSE_XP_BAR"] = "Habilitar Barra de Favor"
Locales["HOUSE_XP"] = "Favor de la Casa"
Locales["HOUSE_BAR_HEIGHT"] = "Altura de Barra de Casa"
Locales["HOUSE_LEVEL_FORMAT"] = "%s Nivel %d | %s / %s (%.1f%%)"
Locales["HOUSE_LEVEL_ABS"]    = "%s Nivel %d | %s / %s"
Locales["HOUSE_LEVEL_PCT"]    = "%s Nivel %d | (%.1f%%)"
Locales["HOUSE_LEVEL_SIMPLE"] = "%s Nivel %d"
Locales["HOUSE_UPGRADES_AVAILABLE"] = "MEJORAS DE CASA DISPONIBLES PARA %s"

-- Appearance Tab
Locales["TEXT_AND_FONT"] = "Texto y Fuente"
Locales["LAYOUT_MODE"] = "Modo de Diseño"
Locales["ALL_IN_ONE_LINE"] = "Todo en una línea"
Locales["MULTIPLE_LINES"] = "Múltiples líneas"
Locales["TEXT_FOLLOWS_BAR"] = "Texto sigue a la barra"
Locales["TEXT_FOLLOWS_BAR_DESC"] = "El Grupo de Texto 1 seguirá la posición de la barra activa más baja."
Locales["FONT_SIZE"] = "Tamaño de Fuente"
Locales["GLOBAL_TEXT_COLOR"] = "Color de Texto Global"
Locales["TEXT_GROUP_POSITIONS"] = "Posiciones de Grupos de Texto"
Locales["DETACH_GROUP"] = "Separar Grupo %d"
Locales["DETACH_GROUP_DESC"] = "Permite que el Grupo %d se posicione independientemente."
Locales["GROUP_X"] = "Desplazamiento X Grupo %d"
Locales["GROUP_Y"] = "Desplazamiento Y Grupo %d"
Locales["TEXT_MANAGEMENT"] = "Gestión de Texto"
Locales["TEXT_SIZE"] = "Tamaño del Texto"
Locales["GROUP_1"] = "Grupo 1"
Locales["GROUP_2"] = "Grupo 2"
Locales["GROUP_3"] = "Grupo 3"

-- Behavior Tab
Locales["AUTO_HIDE_LOGIC"] = "Lógica de Ocultado Automático"
Locales["SHOW_ON_MOUSEOVER"] = "Mostrar al pasar el ratón"
Locales["HIDE_IN_COMBAT"] = "Ocultar en Combate"
Locales["HIDE_AT_MAX_LEVEL"] = "Ocultar la barra de XP en el nivel máximo"
Locales["DATA_DISPLAY"] = "Visualización de Datos"
Locales["SHOW_PERCENTAGE"] = "Mostrar Porcentaje"
Locales["SHOW_ABSOLUTE_VALUES"] = "Mostrar Valores Absolutos"
Locales["SHOW_SPARK"] = "Mostrar Chispa"

-- Colors Tab
Locales["USE_CLASS_COLOR"] = "Usar Color de Clase"
Locales["CUSTOM_XP_COLOR"] = "Color de XP Personalizado"
Locales["SHOW_RESTED_BAR"] = "Mostrar Barra de Descanso"
Locales["RESTED_COLOR"] = "Color de Descanso"
Locales["USE_REACTION_COLORS"] = "Usar Colores de Reacción"
Locales["CUSTOM_REP_COLOR"] = "Color de Reputación Personalizado"
Locales["HONOR_COLOR"] = "Color de Honor"
Locales["HOUSE_XP_COLOR"] = "Color de Favor de Casa"
Locales["HOUSE_REWARD_COLOR"] = "Color de Texto de Recompensa de Casa"
Locales["HOUSE_REWARD_Y_OFFSET"] = "Desplazamiento Y de Recompensa de Casa"
Locales["AZERITE_COLOR"] = "Color de Azerita"

-- Reputation Standings
Locales["HATED"] = "Odiado"
Locales["HOSTILE"] = "Hostil"
Locales["UNFRIENDLY"] = "Poco amistoso"
Locales["NEUTRAL"] = "Neutral"
Locales["FRIENDLY"] = "Amistoso"
Locales["HONORED"] = "Honorable"
Locales["REVERED"] = "Venerado"
Locales["EXALTED"] = "Exaltado"
Locales["MAXED"] = "Máximo"
Locales["RENOWN"] = "Renombre"
Locales["RANK_NUM"] = "Rango %d"

-- Paragon Alerts
Locales["ALERT_STYLING"] = "Estilo de Alerta"
Locales["SHOW_ON_TOP"] = "Mostrar Arriba"
Locales["SPLIT_LINES"] = "Dividir Líneas"
Locales["VERTICAL_OFFSET_Y"] = "Desplazamiento Vertical Y"
Locales["ALERT_COLOR"] = "Color de Alerta"
Locales["REWARD_AVAILABLE"] = "RECOMPENSA DISPONIBLE PARA RECOGER"
Locales["REWARD_ON_CHAR"] = "RECOMPENSA DISPONIBLE EN %s"
Locales["PARAGON_TEXT_SIZE"] = "Tamaño de Texto de Alerta"
Locales["PARAGON_TEXT_Y"] = "Desplazamiento Y de Alerta"
Locales["PARAGON_ON_TOP"] = "Mostrar Alerta en la parte superior de la pantalla"

-- Config/Preview Strings
Locales["CONFIG_FACTION_A_REWARD"] = "[CONFIG] RECOMPENSA FACCIÓN A"
Locales["CONFIG_FACTION_B_REWARD"] = "[CONFIG] RECOMPENSA FACCIÓN B"
Locales["CONFIG_MULTIPLE_REWARDS"] = "[CONFIG] ¡MÚLTIPLES RECOMPENSAS PENDIENTES!"