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

local Locales = LibStub("AceLocale-3.0"):NewLocale("AscensionBars", "esES") or
    LibStub("AceLocale-3.0"):NewLocale("AscensionBars", "esMX")
if not Locales then return end

-- General Configuration
Locales["ADDON_NAME"] = "Ascension Bars"
Locales["CONFIG_MODE"] = "Modo de Configuración"
Locales["CONFIG_MODE_DESC"] = "Muestra barras de prueba para visualizar cambios en tiempo real."
Locales["FACTION_STANDINGS_RESET"] = "Restablecer Valores"
Locales["EMPTY"] = "(Vacío)"

-- Tabs
Locales["TAB_BARS_LAYOUT"] = "Diseño de Barras"
Locales["TAB_TEXT_LAYOUT"] = "Diseño de Texto"
Locales["TAB_BEHAVIOR"] = "Comportamiento"
Locales["TAB_COLORS"] = "Colores"
Locales["TAB_PARAGON_ALERTS"] = "Alertas de Paragon"

-- Global Controls
Locales["ENABLE"] = "Habilitar"
Locales["ORDER"] = "Orden"
Locales["ANCHOR"] = "Anclaje"
Locales["TOP"] = "Arriba"
Locales["BOTTOM"] = "Abajo"
Locales["FREE"] = "Libre"
Locales["WIDTH"] = "Ancho"
Locales["HEIGHT"] = "Alto"
Locales["POS_X"] = "Pos X"
Locales["POS_Y"] = "Pos Y"
Locales["TXT_X"] = "Txt X"
Locales["TXT_Y"] = "Txt Y"

-- Layout Tab
Locales["GLOBAL_POSITIONING"] = "Posicionamiento Global"
Locales["GLOBAL_BLOCKS_OFFSET"] = "Desplazamiento Global de Bloques"
Locales["GLOBAL_BAR_HEIGHT"] = "Altura Global de Barras"
Locales["BAR_MANAGEMENT"] = "Gestión de Barras"
Locales["TOP_BLOCK"] = "Bloque Superior"
Locales["BOTTOM_BLOCK"] = "Bloque Inferior"
Locales["FREE_MODE"] = "Modo Libre"

-- Appearance / Text Layout Tab
Locales["TEXT_AND_FONT"] = "Texto y Fuente"
Locales["LAYOUT_MODE"] = "Modo de Diseño"
Locales["ALL_IN_ONE_LINE"] = "Todo en una línea"
Locales["MULTIPLE_LINES"] = "Múltiples líneas"
Locales["TEXT_FOLLOWS_BAR"] = "El texto sigue a su barra"
Locales["TEXT_FOLLOWS_BAR_DESC"] = "Si se desactiva, el texto se anclará al centro global."
Locales["FONT_SIZE"] = "Tamaño de Fuente"
Locales["GLOBAL_TEXT_COLOR"] = "Color Global del Texto"
Locales["TEXT_GROUP_POSITIONS"] = "Posiciones de Grupos de Texto"
Locales["DETACH_GROUP"] = "Separar %d"
Locales["DETACH_GROUP_DESC"] = "Anclar el grupo %d globalmente en lugar de a las barras."
Locales["GROUP_X"] = "Grupo %d X"
Locales["GROUP_Y"] = "Grupo %d Y"
Locales["TEXT_MANAGEMENT"] = "Gestión de Texto"
Locales["GROUP_1"] = "Grupo 1"
Locales["GROUP_2"] = "Grupo 2"
Locales["GROUP_3"] = "Grupo 3"

-- Behavior Tab
Locales["AUTO_HIDE_LOGIC"] = "Lógica de Ocultamiento Automático"
Locales["SHOW_ON_MOUSEOVER"] = "Mostrar al pasar el ratón"
Locales["HIDE_IN_COMBAT"] = "Ocultar en combate"
Locales["HIDE_AT_MAX_LEVEL"] = "Ocultar barra de XP al nivel máximo"
Locales["DATA_DISPLAY"] = "Visualización de Datos"
Locales["SHOW_PERCENTAGE"] = "Mostrar porcentaje"
Locales["SHOW_ABSOLUTE_VALUES"] = "Mostrar valores absolutos"
Locales["SHOW_SPARK"] = "Mostrar chispa"

-- Colors Tab
Locales["EXPERIENCE"] = "Experiencia"
Locales["USE_CLASS_COLOR"] = "Usar color de clase"
Locales["CUSTOM_XP_COLOR"] = "Color de XP personalizado"
Locales["SHOW_RESTED_BAR"] = "Mostrar barra de descanso"
Locales["RESTED_COLOR"] = "Color de descanso"
Locales["REPUTATION"] = "Reputación"
Locales["USE_REACTION_COLORS"] = "Usar colores de reacción"
Locales["CUSTOM_REP_COLOR"] = "Color de reputación personalizado"
Locales["HONOR"] = "Honor"
Locales["HONOR_COLOR"] = "Color de honor"
Locales["HOUSE_FAVOR"] = "Favor de la casa"
Locales["HOUSE_XP_COLOR"] = "Color de favor de la casa"
Locales["HOUSE_REWARD_COLOR"] = "Color del texto de recompensa"
Locales["HOUSE_REWARD_Y_OFFSET"] = "Offset Y del texto de recompensa"
Locales["AZERITE"] = "Artefacto/Azerita"
Locales["AZERITE_COLOR"] = "Color de artefacto"
Locales["RANK_NUM"] = "Rango %d"

-- Paragon Alerts Tab
Locales["ALERT_STYLING"] = "Estilo de Alertas"
Locales["SHOW_ON_TOP"] = "Mostrar arriba"
Locales["SPLIT_LINES"] = "Dividir líneas"
Locales["TEXT_SIZE"] = "Tamaño de texto"
Locales["VERTICAL_OFFSET_Y"] = "Desplazamiento vertical (Y)"
Locales["ALERT_COLOR"] = "Color de alerta"

-- Standing Data
Locales["HATED"] = "Odiado"
Locales["HOSTILE"] = "Hostil"
Locales["UNFRIENDLY"] = "No amigable"
Locales["NEUTRAL"] = "Neutral"
Locales["FRIENDLY"] = "Amistoso"
Locales["HONORED"] = "Honrado"
Locales["REVERED"] = "Reverenciado"
Locales["EXALTED"] = "Exaltado"
Locales["PARAGON"] = "Paragon"
Locales["MAXED"] = "Máximo"
Locales["RENOWN"] = "Renombre"
Locales["UNKNOWN_FACTION"] = "Facción desconocida"
Locales["UNKNOWN_STANDING"] = "???"

-- Formats
Locales["LEVEL_TEXT_ABS_PCT"] = "Nivel %d | %s/%s (%.1f%%)"
Locales["LEVEL_TEXT_ABS"] = "Nivel %d | %s/%s"
Locales["LEVEL_TEXT_PCT"] = "Nivel %d | %.1f%%"
Locales["LEVEL_TEXT"] = "Nivel %d"
Locales["RESTED_TEXT"] = " | Descanso %.1f%%"
Locales["RENOWN_LEVEL"] = "Renombre %d"

-- Other Legacy Keys
Locales["APPEARANCE"] = "Apariencia"
Locales["BAR_ANCHOR"] = "Posición de la Barra"
Locales["BAR_GAP"] = "Espacio entre barras"
Locales["BAR_GAP_DESC"] = "Espacio entre barras."
Locales["ANCHOR_TOP"] = "Superior (Por defecto)"
Locales["ANCHOR_BOTTOM"] = "Inferior"
Locales["ANCHOR_DESC"] = "Controla el punto de anclaje de las barras. Parte superior: barras arriba, texto abajo. Parte inferior: barras abajo, texto arriba."
Locales["POSITION_SIZE"] = "Posición y Tamaño"
Locales["VERTICAL_POSITION"] = "Posición Vertical (Y)"
Locales["TEXT_GAP"] = "Espacio del Texto"
Locales["XP_BAR_HEIGHT"] = "Altura Barra de XP"
Locales["REP_BAR_HEIGHT"] = "Altura Barra de Reputación"
Locales["VISIBILITY"] = "Visibilidad"
Locales["COLORS"] = "Colores"
Locales["PARAGON_ALERTS"] = "Alertas de Paragon"
Locales["FACTION_COLORS"] = "Colores de facción"
Locales["ADVANCED"] = "Avanzado"
Locales["REWARD_PENDING"] = " ¡RECOMPENSA PENDIENTE!"
Locales["AND"] = " Y "
Locales["REWARD_PENDING_SINGLE"] = " ¡RECOMPENSA PENDIENTE!"
Locales["REWARD_PENDING_PLURAL"] = " ¡RECOMPENSAS PENDIENTES!"
Locales["XP_BAR_DATA"] = "Datos de la barra de experiencia | 0/0 (0.0%)"
Locales["REP_BAR_DATA"] = "Datos de la barra de reputación | 0/0 (0.0%)"
Locales["CONFIG_FACTION_A_REWARD"] = "[CONFIG] RECOMPENSA FACCIÓN A"
Locales["CONFIG_FACTION_B_REWARD"] = "[CONFIG] RECOMPENSA FACCIÓN B"
Locales["CONFIG_MULTIPLE_REWARDS"] = "[CONFIG] ¡MÚLTIPLES RECOMPENSAS PENDIENTES!"
Locales["REWARD_PENDING_STATUS"] = "Recompensa pendiente"
Locales["OPTIONAL_BARS"] = "Barras opcionales"
Locales["ENABLE_HONOR_BAR"] = "Habilitar barra de honor"
Locales["HONOR_BAR_DATA"] = "Honor: 0%"
Locales["HONOR_BAR_HEIGHT"] = "Altura de la barra de honor"
Locales["ENABLE_HOUSE_XP_BAR"] = "Habilitar barra de favor de la casa"
Locales["HOUSE_XP"] = "Favor de la casa"
Locales["HOUSE_XP_BAR_DATA"] = "Casa Nivel 0 | 0/0 (0.0%)"
Locales["ENABLE_AZERITE_BAR"] = "Habilitar barra de artefacto"
Locales["AZERITE_BAR_DATA"] = "Azerita: 0%"
Locales["AZERITE_BAR_HEIGHT"] = "Altura de la barra de artefacto"
Locales["HOUSE_BAR_HEIGHT"] = "Altura de la barra de la casa"
Locales["ENABLE_BAR"] = "Habilitar Barra"
Locales["LAYOUT_BLOCK"] = "Bloque de Ubicación"
Locales["BAR_ORDER"] = "Posición"
Locales["BAR_WIDTH"] = "Ancho"
Locales["BAR_HEIGHT"] = "Alto"
Locales["LAYOUT"] = "Diseño"
Locales["HOUSING_FAVOR"] = "Favor de Vivienda"
Locales["HOUSING_READY"] = "Listo"
Locales["HOUSING_UPGRADE_READY"] = "MEJORA DE CASA DISPONIBLE"
Locales["REWARD_AVAILABLE"] = "Recompensa lista para recoger"
Locales["REWARD_ON_CHAR"] = "Recompensa disponible en %s"