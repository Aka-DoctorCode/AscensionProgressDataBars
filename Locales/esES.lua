-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
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
local Locales = _G.LibStub("AceLocale-3.0"):NewLocale("AscensionProgressDataBars", "esES", true)
if not Locales then return end

-------------------------------------------------------------------------------
-- GENERAL
-------------------------------------------------------------------------------
Locales["ADDON_NAME"] = "Barras de Progreso de Ascensión"
Locales["CONFIG_MODE"] = "Modo Configuración"
Locales["CONFIG_MODE_DESC"] = "Muestra barras de prueba para visualizar los cambios en tiempo real."
Locales["FACTION_STANDINGS_RESET"] = "Restablecer valores predeterminados"
Locales["EMPTY"] = "Vacío"
Locales["AND"] = " Y "
Locales["CONFIG_MODULE_MISSING"] = "AscensionBars: Módulo de configuración no encontrado."
Locales["TOGGLE_CONFIG_WINDOW"] = "Alternar ventana de configuración"

-------------------------------------------------------------------------------
-- CAROUSEL GAINS
-------------------------------------------------------------------------------
Locales["Experience"] = "Experiencia"
Locales["Reputation"] = "Reputación"
Locales["House XP"] = "Experiencia de Casa"
Locales["Honor"] = "Honor"
Locales["Azerite"] = "Azerita"

-------------------------------------------------------------------------------
-- TABS
-------------------------------------------------------------------------------
Locales["TAB_BARS_LAYOUT"] = "Diseño de Barras"
Locales["TAB_CUSTOM_GRID"] = "Barras Personalizadas"
Locales["TAB_TEXT_LAYOUT"] = "Diseño de Texto"
Locales["TAB_BEHAVIOR"] = "Comportamiento"
Locales["TAB_COLORS"] = "Colores"
Locales["TAB_PARAGON_ALERTS"] = "Alertas"
Locales["TAB_PROFILES"] = "Perfiles"

-------------------------------------------------------------------------------
-- UI CONTROLS & LABELS
-------------------------------------------------------------------------------
Locales["ENABLE"] = "Activar"
Locales["ANCHOR"] = "Anclaje"
Locales["TOP"] = "Arriba"
Locales["BOTTOM"] = "Abajo"
Locales["FREE"] = "Libre"
Locales["ORDER"] = "Orden"
Locales["WIDTH"] = "Ancho"
Locales["HEIGHT"] = "Alto"
Locales["POS_X"] = "Posición X"
Locales["POS_Y"] = "Posición Y"
Locales["TXT_X"] = "Desplazamiento Texto X"
Locales["TXT_Y"] = "Desplazamiento Texto Y"
Locales["GLOBAL_BLOCKS_OFFSET"] = "Desplazamiento Global de Bloques"
Locales["GLOBAL_BAR_HEIGHT"] = "Altura Global de Barras"
Locales["GLOBAL_OFFSET"] = "Desplazamiento Global"
Locales["GLOBAL_SETTINGS"] = "Ajustes Globales"
Locales["PER_BLOCK_OFFSET"] = "Usar desplazamiento por bloque"
Locales["PER_BLOCK_GAP"] = "Usar separación por bloque"
Locales["BAR_GAP"] = "Separación Global entre Barras"
Locales["TOP_OFFSET"] = "Desplazamiento Bloque Superior"
Locales["BOTTOM_OFFSET"] = "Desplazamiento Bloque Inferior"
Locales["BLOCK_HEIGHT"] = "Altura de Bloque"
Locales["USE_PER_BLOCK_HEIGHT"] = "Usar altura por bloque"
Locales["USE_CUSTOM_HEIGHT"] = "Usar altura personalizada"
Locales["CUSTOM_HEIGHT"] = "Altura personalizada"
Locales["USE_PER_GROUP_SIZE"] = "Usar tamaño por grupo"
Locales["USE_PER_GROUP_COLOR"] = "Usar color por grupo"
Locales["USE_CUSTOM_TEXT_SIZE"] = "Usar tamaño de texto personalizado"
Locales["USE_CUSTOM_TEXT_COLOR"] = "Usar color de texto personalizado"
Locales["GROUP_SIZE"] = "Tamaño de texto del grupo"
Locales["GROUP_COLOR"] = "Color de texto del grupo"
Locales["CUSTOM_TEXT_SIZE"] = "Tamaño de texto personalizado"
Locales["CUSTOM_TEXT_COLOR"] = "Color de texto personalizado"
Locales["TOP_GAP"] = "Separación Bloque Superior"
Locales["BOTTOM_GAP"] = "Separación Bloque Inferior"
Locales["BAR_MANAGEMENT"] = "Gestión de Barras"
Locales["TOP_BLOCK"] = "Bloque Superior"
Locales["BOTTOM_BLOCK"] = "Bloque Inferior"
Locales["FREE_MODE"] = "Modo Libre"
Locales["DIM_ALPHA"] = "Alfa de atenuación"
Locales["CAROUSEL_OPTIONS"] = "Opciones de Carrusel"
Locales["CAROUSEL_X_OFFSET"] = "Desplazamiento X"
Locales["CAROUSEL_Y_OFFSET"] = "Desplazamiento Y"
Locales["CAROUSEL_BG_ALPHA"] = "Alfa del fondo"

-------------------------------------------------------------------------------
-- EXPERIENCE BAR
-------------------------------------------------------------------------------
Locales["EXPERIENCE"] = "Experiencia"
Locales["XP_BAR_DATA"] = "Datos Barra de Experiencia | 0/0 (0.0%)"
Locales["XP_BAR_CONFIG_TEXT"] = "Experiencia: 75% (Descanso)"
Locales["RESTED_XP"] = "Descanso"
Locales["RESTED_TEXT"] = "Descanso"
Locales["LEVEL_TEXT"] = "Nivel %d"
Locales["LEVEL_TEXT_ABS_PCT"] = "Nivel %d | %s / %s (%.1f%%)"
Locales["LEVEL_TEXT_ABS"] = "Nivel %d | %s / %s"
Locales["LEVEL_TEXT_PCT"] = "Nivel %d | %.1f%%"
Locales["RESTED_LABEL"] = "Descanso: %s"

-------------------------------------------------------------------------------
-- REPUTATION BAR
-------------------------------------------------------------------------------
Locales["REPUTATION"] = "Reputación"
Locales["REP_BAR_DATA"] = "Datos Barra de Reputación | 0/0 (0.0%)"
Locales["PARAGON"] = "Paragón"
Locales["RENOWN_LEVEL"] = "Nivel de Renombre"
Locales["REWARD_PENDING_STATUS"] = "Recompensa pendiente"
Locales["REWARD_PENDING_SINGLE"] = " ¡RECOMPENSA PENDIENTE!"
Locales["REWARD_PENDING_PLURAL"] = " ¡RECOMPENSAS PENDIENTES!"
Locales["ADD_CUSTOM_REPUTATION"] = "Añadir reputación personalizada"
Locales["SEARCH_FACTION"] = "Buscar facción"
Locales["SELECT_FACTION"] = "Seleccionar facción"
Locales["ADD"] = "Añadir"
Locales["DELETE"] = "Eliminar"

-- Reputation Display Patterns
Locales["REP_LABEL_FORMAT"] = "%s (%s)"
Locales["REP_VALUE_FORMAT_FULL"] = "%s / %s (%.1f%%)"
Locales["REP_VALUE_FORMAT_PCT"] = "(%.1f%%)"

-------------------------------------------------------------------------------
-- HONOR BAR
-------------------------------------------------------------------------------
Locales["HONOR"] = "Honor"
Locales["HONOR_LEVEL_SIMPLE"] = "Nivel de Honor %d"
Locales["ENABLE_HONOR_BAR"] = "Activar barra de honor"
Locales["HONOR_BAR_DATA"] = "Honor: 0%"
Locales["HONOR_BAR_HEIGHT"] = "Altura barra de honor"
Locales["HONOR_LEVEL_FORMAT"] = "Nivel de Honor %d | %s/%s (%.1f%%)"

-------------------------------------------------------------------------------
-- AZERITE BAR
-------------------------------------------------------------------------------
Locales["AZERITE"] = "Azerita"
Locales["ENABLE_AZERITE_BAR"] = "Activar barra de azerita"
Locales["AZERITE_BAR_DATA"] = "Poder de azerita: 0%"
Locales["AZERITE_BAR_HEIGHT"] = "Altura barra de azerita"
Locales["AZERITE_LEVEL_FORMAT"] = "Nivel de Azerita %d | %s/%s (%.1f%%)"

-------------------------------------------------------------------------------
-- HOUSING FAVOR BAR
-------------------------------------------------------------------------------
Locales["HOUSE_FAVOR"] = "Nivel de Favor de Casa"
Locales["ENABLE_HOUSE_XP_BAR"] = "Activar barra de favor de casa"
Locales["HOUSE_XP"] = "Favor de Casa"
Locales["HOUSE_BAR_HEIGHT"] = "Altura barra de casa"
Locales["HOUSE_LEVEL_FORMAT"] = "%s Nivel %d | %s / %s (%.1f%%)"
Locales["HOUSE_LEVEL_ABS"]    = "%s Nivel %d | %s / %s"
Locales["HOUSE_LEVEL_PCT"]    = "%s Nivel %d | (%.1f%%)"
Locales["HOUSE_LEVEL_SIMPLE"] = "%s Nivel %d"
Locales["HOUSE_UPGRADES_AVAILABLE"] = "MEJORAS DE CASA DISPONIBLES PARA %s"

-------------------------------------------------------------------------------
-- TEXT LAYOUT TAB
-------------------------------------------------------------------------------
Locales["TEXT_AND_FONT"] = "Texto y Fuente"
Locales["LAYOUT_MODE"] = "Modo de diseño"
Locales["ALL_IN_ONE_LINE"] = "Todo en una línea"
Locales["MULTIPLE_LINES"] = "Múltiples líneas"
Locales["TEXT_FOLLOWS_BAR"] = "El texto sigue a la barra"
Locales["TEXT_FOLLOWS_BAR_DESC"] = "El Grupo de Texto 1 seguirá la posición de la barra activa más baja."
Locales["FONT_SIZE"] = "Tamaño de fuente"
Locales["GLOBAL_TEXT_COLOR"] = "Color de texto global"
Locales["TEXT_GROUP_POSITIONS"] = "Posiciones de grupos de texto"
Locales["DETACH_GROUP"] = "Desvincular Grupo %d"
Locales["DETACH_GROUP_DESC"] = "Permite que el Grupo %d se posicione independientemente."
Locales["GROUP_X"] = "Desplazamiento X Grupo %d"
Locales["GROUP_Y"] = "Desplazamiento Y Grupo %d"
Locales["TEXT_MANAGEMENT"] = "Gestión de texto"
Locales["TEXT_SIZE"] = "Tamaño de texto"
Locales["GROUP_1"] = "Grupo 1"
Locales["GROUP_2"] = "Grupo 2"
Locales["GROUP_3"] = "Grupo 3"

-------------------------------------------------------------------------------
-- BEHAVIOR TAB
-------------------------------------------------------------------------------
Locales["AUTO_HIDE_LOGIC"] = "Lógica de auto-ocultación"
Locales["SHOW_ON_MOUSEOVER"] = "Mostrar al pasar el ratón"
Locales["HIDE_IN_COMBAT"] = "Ocultar en combate"
Locales["HIDE_AT_MAX_LEVEL"] = "Ocultar barra de experiencia al nivel máximo"
Locales["DATA_DISPLAY"] = "Visualización de datos"
Locales["SHOW_PERCENTAGE"] = "Mostrar porcentaje"
Locales["SHOW_ABSOLUTE_VALUES"] = "Mostrar valores absolutos"
Locales["SHOW_SPARK"] = "Mostrar destello"

-------------------------------------------------------------------------------
-- COLORS TAB
-------------------------------------------------------------------------------
Locales["USE_CLASS_COLOR"] = "Usar color de clase"
Locales["CUSTOM_XP_COLOR"] = "Color de experiencia personalizado"
Locales["SHOW_RESTED_BAR"] = "Mostrar barra de descanso"
Locales["RESTED_COLOR"] = "Color de descanso"
Locales["USE_REACTION_COLORS"] = "Usar colores según reacción"
Locales["CUSTOM_REP_COLOR"] = "Color de reputación personalizado"
Locales["HONOR_COLOR"] = "Color de honor"
Locales["HOUSE_XP_COLOR"] = "Color de favor de casa"
Locales["HOUSE_REWARD_COLOR"] = "Color de texto de recompensa de casa"
Locales["HOUSE_REWARD_Y_OFFSET"] = "Desplazamiento Y de recompensa de casa"
Locales["AZERITE_COLOR"] = "Color de azerita"

-------------------------------------------------------------------------------
-- REPUTATION STANDINGS
-------------------------------------------------------------------------------
Locales["HATED"] = "Odiado"
Locales["HOSTILE"] = "Hostil"
Locales["UNFRIENDLY"] = "Antipático"
Locales["NEUTRAL"] = "Neutral"
Locales["FRIENDLY"] = "Amistoso"
Locales["HONORED"] = "Honrado"
Locales["REVERED"] = "Reverenciado"
Locales["EXALTED"] = "Exaltado"
Locales["MAXED"] = "Máximo"
Locales["RENOWN"] = "Renombre"
Locales["RANK_NUM"] = "Rango %d"

-------------------------------------------------------------------------------
-- PARAGON ALERTS
-------------------------------------------------------------------------------
Locales["ALERT_STYLING"] = "Estilo de alerta"
Locales["SPLIT_LINES"] = "Dividir líneas"
Locales["ALERT_COLOR"] = "Color de alerta"
Locales["REWARD_AVAILABLE"] = "RECOMPENSA DISPONIBLE PARA RECOGER"
Locales["REWARD_ON_CHAR"] = "RECOMPENSA DISPONIBLE EN %s"
Locales["PARAGON_TEXT_SIZE"] = "Tamaño de texto de alerta"

-------------------------------------------------------------------------------
-- CUSTOM GRID MODE
-------------------------------------------------------------------------------
Locales["CUSTOM_GRID"] = "Barras Personalizadas"
Locales["CUSTOM_GRID_ENABLE"] = "Activar diseño de cuadrícula personalizada"
Locales["CUSTOM_GRID_DESC"] = "Activar para crear un diseño de varias columnas. Cuando está activo, se ignora el orden estándar de las barras y se colocan exactamente en la fila y columna asignadas."
Locales["ENABLE_ADVANCED_GRID"] = "Activar cuadrícula personalizada (avanzada)"
Locales["CUSTOM_GRID_DISABLED_MSG"] = "Activar cuadrícula personalizada (avanzada) arriba para configurar diseños personalizados."
Locales["GRID_OPTIONS"] = "Configuración de cuadrícula"
Locales["GRID_ROWS"] = "Filas totales"
Locales["GRID_COLS_FOR_ROW"] = "Columnas para fila %d"
Locales["GRID_CELL"] = "Fila %d - Col %d"
Locales["GRID_PRESET"] = "Diseño predefinido"
Locales["PRESET_CUSTOM"] = "Personalizado"
Locales["PRESET_2X1"] = "2x1 (2 filas, 1 columna)"
Locales["PRESET_2X2"] = "2x2 (2 filas, 2 columnas)"
Locales["PRESET_3X2"] = "3x2 (3 filas, 2 columnas)"
Locales["ASSIGN_BAR"] = "Asignar barra"

-------------------------------------------------------------------------------
-- TEXT LAYOUT (additional)
-------------------------------------------------------------------------------
Locales["BLOCK_TEXT_MODE"] = "Comportamiento del texto"
Locales["TEXT_VISIBILITY_MODE"] = "Modo de visibilidad del texto"
Locales["FOCUS_MODE"] = "Mostrar al pasar el ratón"
Locales["GRID_DYNAMIC"] = "Siempre visible"
Locales["NONE"] = "Ninguno"
Locales["BASE_TYPOGRAPHY"] = "Tipografía base"
Locales["FONT_OUTLINE"] = "Contorno de fuente"
Locales["VISUAL_OPTIONS"] = "Opciones visuales"
Locales["SHOW_RESTED"] = "Mostrar XP de descanso"
Locales["USE_COMPACT_FORMAT"] = "Formato compacto"
Locales["EVENTS_VISIBILITY"] = "Visibilidad"
Locales["ENABLE_CAROUSEL"] = "Activar carrusel de eventos"
Locales["LATERAL_LEGEND"] = "Activar leyenda lateral"
Locales["DYNAMIC_GRID_GAP"] = "Separación de cuadrícula"
Locales["LEGEND_OPTIONS"] = "Opciones de leyenda"
Locales["LEGEND_TEXT_SIZE"] = "Tamaño de texto de leyenda"
Locales["LEGEND_BG_ALPHA"] = "Alfa del fondo"
Locales["LEGEND_FONT_OUTLINE"] = "Contorno de fuente de leyenda"

-------------------------------------------------------------------------------
-- CONFIG / PREVIEW STRINGS
-------------------------------------------------------------------------------
Locales["CONFIG_FACTION_A_REWARD"] = "[CONFIG] RECOMPENSA FACCIÓN A"
Locales["CONFIG_FACTION_B_REWARD"] = "[CONFIG] RECOMPENSA FACCIÓN B"
Locales["CONFIG_MULTIPLE_REWARDS"] = "[CONFIG] MÚLTIPLES RECOMPENSAS PENDIENTES"

-------------------------------------------------------------------------------
-- PROFILES TAB
-------------------------------------------------------------------------------
Locales["PROFILES"] = "Perfiles"
Locales["PROFILE_DESC_1"] = "Puedes cambiar el perfil activo de la base de datos, así puedes tener diferentes ajustes para cada personaje."
Locales["PROFILE_DESC_2"] = "Restablece el perfil actual a sus valores predeterminados."
Locales["RESET_PROFILE"] = "Restablecer perfil"
Locales["CURRENT_PROFILE"] = "Perfil actual:"
Locales["PROFILE_DESC_3"] = "Crear un nuevo perfil o elegir uno existente."
Locales["NEW"] = "Nuevo perfil"
Locales["EXISTING_PROFILES"] = "Perfiles existentes"
Locales["COPY_PROFILE_DESC"] = "Copiar ajustes de otro perfil al actual."
Locales["COPY_FROM"] = "Copiar desde"
Locales["DELETE_PROFILE_DESC"] = "Eliminar perfiles no utilizados para ahorrar espacio."
Locales["DELETE_PROFILE"] = "Eliminar un perfil"
Locales["DELETE_PROFILE_CONFIRM"] = "¿Eliminar el perfil '%s'?"
Locales["ACCEPT"] = "Aceptar"
Locales["CANCEL"] = "Cancelar"
Locales["YES"] = "Sí"
Locales["NO"] = "No"
Locales["IMPORT_PROFILE"] = "Importar perfil"
Locales["EXPORT_PROFILE"] = "Exportar perfil"
Locales["IMPORT_EXPORT_DESC"] = "Comparte tu configuración con otros."
Locales["CLOSE"] = "Cerrar"
Locales["IMPORT"] = "Importar"
Locales["RESET_CONFIRM"] = "¿Estás seguro de que quieres restablecer el perfil '%s' a los valores predeterminados?"