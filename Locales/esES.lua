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
local Locales = _G.LibStub("AceLocale-3.0"):NewLocale("AscensionBars", "esES") or _G.LibStub("AceLocale-3.0"):NewLocale("AscensionBars", "esMX")

if not Locales then return end

-- General Configuration
Locales["ADDON_NAME"] = "Ascension Progress Data Bars"
Locales["CONFIG_MODE"] = "Modo de Configuración"
Locales["CONFIG_MODE_DESC"] = "Muestra barras de prueba para visualizar los cambios en tiempo real."
Locales["FACTION_STANDINGS_RESET"] = "Restablecer Valores por Defecto"
Locales["EMPTY"] = "Vacío"
Locales["AND"] = " Y "
Locales["CONFIG_MODULE_MISSING"] = "AscensionBars: Módulo de configuración no encontrado."
Locales["TOGGLE_CONFIG_WINDOW"] = "Alternar Ventana de Configuración"

-- Tabs
Locales["TAB_BARS_LAYOUT"] = "Diseño de Barras"
Locales["TAB_TEXT_LAYOUT"] = "Diseño de Texto"
Locales["TAB_BEHAVIOR"] = "Comportamiento"
Locales["TAB_COLORS"] = "Colores"
Locales["TAB_PARAGON_ALERTS"] = "Alertas"
Locales["TAB_PROFILES"] = "Perfiles"

-- UI Controls & Labels
Locales["ENABLE"] = "Habilitar"
Locales["ANCHOR"] = "Anclaje"
Locales["TOP"] = "Arriba"
Locales["BOTTOM"] = "Abajo"
Locales["FREE"] = "Libre"
Locales["ORDER"] = "Orden"
Locales["WIDTH"] = "Ancho"
Locales["HEIGHT"] = "Alto"
Locales["POS_X"] = "Posición X"
Locales["POS_Y"] = "Posición Y"
Locales["TXT_X"] = "Desplazamiento X del Texto"
Locales["TXT_Y"] = "Desplazamiento Y del Texto"
Locales["GLOBAL_BLOCKS_OFFSET"] = "Desplazamiento Global de Bloques"
Locales["GLOBAL_BAR_HEIGHT"] = "Altura Global de Barras"
Locales["GLOBAL_OFFSET"] = "Desplazamiento Global"
Locales["GLOBAL_SETTINGS"] = "Configuración Global"
Locales["PER_BLOCK_OFFSET"] = "Usar Desplazamiento por Bloque"
Locales["PER_BLOCK_GAP"] = "Usar Espaciado por Bloque"
Locales["BAR_GAP"] = "Espacio Global entre Barras"
Locales["TOP_OFFSET"] = "Desplazamiento del Bloque Superior"
Locales["BOTTOM_OFFSET"] = "Desplazamiento del Bloque Inferior"
Locales["BLOCK_HEIGHT"] = "Altura de Barra del Bloque"
Locales["USE_PER_BLOCK_HEIGHT"] = "Usar Altura por Bloque"
Locales["USE_CUSTOM_HEIGHT"] = "Usar Altura Personalizada"
Locales["CUSTOM_HEIGHT"] = "Altura Personalizada"
Locales["USE_PER_GROUP_SIZE"] = "Usar Tamaño por Grupo"
Locales["USE_PER_GROUP_COLOR"] = "Usar Color por Grupo"
Locales["USE_CUSTOM_TEXT_SIZE"] = "Usar Tamaño de Texto Personalizado"
Locales["USE_CUSTOM_TEXT_COLOR"] = "Usar Color de Texto Personalizado"
Locales["GROUP_SIZE"] = "Tamaño de Texto del Grupo"
Locales["GROUP_COLOR"] = "Color de Texto del Grupo"
Locales["CUSTOM_TEXT_SIZE"] = "Tamaño de Texto Personalizado"
Locales["CUSTOM_TEXT_COLOR"] = "Color de Texto Personalizado"
Locales["TOP_GAP"] = "Espaciado del Bloque Superior"
Locales["BOTTOM_GAP"] = "Espaciado del Bloque Inferior"
Locales["BAR_MANAGEMENT"] = "Gestión de Barras"
Locales["TOP_BLOCK"] = "Bloque Superior"
Locales["BOTTOM_BLOCK"] = "Bloque Inferior"
Locales["FREE_MODE"] = "Modo Libre"
Locales["DIM_ALPHA"] = "Opacidad Atenuada"
Locales["CAROUSEL_OPTIONS"] = "Opciones del Carrusel"
Locales["CAROUSEL_X_OFFSET"] = "Desplazamiento X"
Locales["CAROUSEL_Y_OFFSET"] = "Desplazamiento Y"
Locales["CAROUSEL_BG_ALPHA"] = "Opacidad del Fondo"

-- Experience Bar
Locales["EXPERIENCE"] = "Experiencia"
Locales["XP_BAR_DATA"] = "Datos de la Barra de Experiencia | 0/0 (0.0%)"
Locales["XP_BAR_CONFIG_TEXT"] = "Experiencia: 75% (Descansando)"
Locales["RESTED_XP"] = "XP por Descanso"
Locales["RESTED_TEXT"] = "Descansado"
Locales["LEVEL_TEXT"] = "Nivel %d"
Locales["LEVEL_TEXT_ABS_PCT"] = "Nivel %d | %s / %s (%.1f%%)"
Locales["LEVEL_TEXT_ABS"] = "Nivel %d | %s / %s"
Locales["LEVEL_TEXT_PCT"] = "Nivel %d | %.1f%%"
Locales["RESTED_LABEL"] = "Descansado: %s"

-- Reputation Bar
Locales["REPUTATION"] = "Reputación"
Locales["REP_BAR_DATA"] = "Datos de la Barra de Reputación | 0/0 (0.0%)"
Locales["PARAGON"] = "Dechado"
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
Locales["HONOR_LEVEL_SIMPLE"] = "Nivel de Honor %d"
Locales["ENABLE_HONOR_BAR"] = "Habilitar Barra de Honor"
Locales["HONOR_BAR_DATA"] = "Honor: 0%"
Locales["HONOR_BAR_HEIGHT"] = "Altura de la Barra de Honor"
Locales["HONOR_LEVEL_FORMAT"] = "Nivel de Honor %d | %s/%s (%.1f%%)"

-- Azerite Bar
Locales["AZERITE"] = "Azerita"
Locales["ENABLE_AZERITE_BAR"] = "Habilitar Barra de Azerita"
Locales["AZERITE_BAR_DATA"] = "Poder de Azerita: 0%"
Locales["AZERITE_BAR_HEIGHT"] = "Altura de la Barra de Azerita"
Locales["AZERITE_LEVEL_FORMAT"] = "Nivel de Azerita %d | %s/%s (%.1f%%)"

-- Housing Favor Bar
Locales["HOUSE_FAVOR"] = "Nivel de Favor de la Casa"
Locales["ENABLE_HOUSE_XP_BAR"] = "Habilitar Barra de Favor de la Casa"
Locales["HOUSE_XP"] = "Favor de la Casa"
Locales["HOUSE_BAR_HEIGHT"] = "Altura de la Barra de la Casa"
Locales["HOUSE_LEVEL_FORMAT"] = "Nivel de %s %d | %s / %s (%.1f%%)"
Locales["HOUSE_LEVEL_ABS"]    = "Nivel de %s %d | %s / %s"
Locales["HOUSE_LEVEL_PCT"]    = "Nivel de %s %d | (%.1f%%)"
Locales["HOUSE_LEVEL_SIMPLE"] = "Nivel de %s %d"
Locales["HOUSE_UPGRADES_AVAILABLE"] = "MEJORAS DE CASA DISPONIBLES PARA %s"

-- Appearance Tab
Locales["TEXT_AND_FONT"] = "Texto y Fuente"
Locales["LAYOUT_MODE"] = "Modo de Diseño"
Locales["ALL_IN_ONE_LINE"] = "Todo en una línea"
Locales["MULTIPLE_LINES"] = "Múltiples líneas"
Locales["TEXT_FOLLOWS_BAR"] = "El texto sigue a la barra"
Locales["TEXT_FOLLOWS_BAR_DESC"] = "El Grupo de Texto 1 seguirá la posición de la barra activa más baja."
Locales["FONT_SIZE"] = "Tamaño de Fuente"
Locales["GLOBAL_TEXT_COLOR"] = "Color de Texto Global"
Locales["TEXT_GROUP_POSITIONS"] = "Posiciones de los Grupos de Texto"
Locales["DETACH_GROUP"] = "Separar Grupo %d"
Locales["DETACH_GROUP_DESC"] = "Permite que el Grupo %d se posicione de forma independiente."
Locales["GROUP_X"] = "Desplazamiento X del Grupo %d"
Locales["GROUP_Y"] = "Desplazamiento Y del Grupo %d"
Locales["TEXT_MANAGEMENT"] = "Gestión de Texto"
Locales["TEXT_SIZE"] = "Tamaño del Texto"
Locales["GROUP_1"] = "Grupo 1"
Locales["GROUP_2"] = "Grupo 2"
Locales["GROUP_3"] = "Grupo 3"

-- Behavior Tab
Locales["AUTO_HIDE_LOGIC"] = "Lógica de Ocultamiento Automático"
Locales["SHOW_ON_MOUSEOVER"] = "Mostrar al pasar el ratón"
Locales["HIDE_IN_COMBAT"] = "Ocultar en Combate"
Locales["HIDE_AT_MAX_LEVEL"] = "Ocultar Barra de XP a Nivel Máximo"
Locales["DATA_DISPLAY"] = "Visualización de Datos"
Locales["SHOW_PERCENTAGE"] = "Mostrar Porcentaje"
Locales["SHOW_ABSOLUTE_VALUES"] = "Mostrar Valores Absolutos"
Locales["SHOW_SPARK"] = "Mostrar Destello"

-- Colors Tab
Locales["USE_CLASS_COLOR"] = "Usar Color de Clase"
Locales["CUSTOM_XP_COLOR"] = "Color de XP Personalizado"
Locales["SHOW_RESTED_BAR"] = "Mostrar Barra de Descanso"
Locales["RESTED_COLOR"] = "Color de Descanso"
Locales["USE_REACTION_COLORS"] = "Usar Colores de Reacción"
Locales["CUSTOM_REP_COLOR"] = "Color de Reputación Personalizado"
Locales["HONOR_COLOR"] = "Color de Honor"
Locales["HOUSE_XP_COLOR"] = "Color de Favor de la Casa"
Locales["HOUSE_REWARD_COLOR"] = "Color del Texto de Recompensa de Casa"
Locales["HOUSE_REWARD_Y_OFFSET"] = "Desplazamiento Y de Recompensa de Casa"
Locales["AZERITE_COLOR"] = "Color de Azerita"

-- Reputation Standings
Locales["HATED"] = "Odiado"
Locales["HOSTILE"] = "Hostil"
Locales["UNFRIENDLY"] = "Adverso"
Locales["NEUTRAL"] = "Neutral"
Locales["FRIENDLY"] = "Amistoso"
Locales["HONORED"] = "Honorable"
Locales["REVERED"] = "Reverenciado"
Locales["EXALTED"] = "Exaltado"
Locales["MAXED"] = "Al Máximo"
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
Locales["PARAGON_TEXT_SIZE"] = "Tamaño del Texto de Alerta"
Locales["PARAGON_TEXT_Y"] = "Desplazamiento Y de la Alerta"
Locales["PARAGON_ON_TOP"] = "Mostrar Alerta en la parte superior de la pantalla"

-- Text Layout Tab
Locales["BLOCK_TEXT_MODE"] = "Comportamiento del Texto"
Locales["TEXT_VISIBILITY_MODE"] = "Modo de Visibilidad del Texto"
Locales["FOCUS_MODE"] = "Mostrar al pasar el ratón"
Locales["GRID_DYNAMIC"] = "Siempre Visible"
Locales["NONE"] = "Ninguno"
Locales["BASE_TYPOGRAPHY"] = "Tipografía Base"
Locales["FONT_OUTLINE"] = "Contorno de Fuente"
Locales["VISUAL_OPTIONS"] = "Opciones Visuales"
Locales["SHOW_RESTED"] = "Mostrar XP de Descanso"
Locales["USE_COMPACT_FORMAT"] = "Formato Compacto"
Locales["EVENTS_VISIBILITY"] = "Visibilidad"
Locales["ENABLE_CAROUSEL"] = "Habilitar Carrusel de Eventos"
Locales["LATERAL_LEGEND"] = "Habilitar Leyenda Lateral"
Locales["DYNAMIC_GRID_GAP"] = "Espacio de la Cuadrícula"
Locales["LEGEND_OPTIONS"] = "Opciones de Leyenda"
Locales["LEGEND_TEXT_SIZE"] = "Tamaño de Texto de la Leyenda"
Locales["LEGEND_BG_ALPHA"] = "Opacidad del Fondo"
Locales["LEGEND_FONT_OUTLINE"] = "Contorno de Fuente de la Leyenda"

-- Config/Preview Strings
Locales["CONFIG_FACTION_A_REWARD"] = "[CONFIG] RECOMPENSA DE FACCIÓN A"
Locales["CONFIG_FACTION_B_REWARD"] = "[CONFIG] RECOMPENSA DE FACCIÓN B"
Locales["CONFIG_MULTIPLE_REWARDS"] = "[CONFIG] ¡MÚLTIPLES RECOMPENSAS PENDIENTES!"

-- Custom Grid Mode
Locales["CUSTOM_GRID_ENABLE"] = "Habilitar Diseño de Cuadrícula Personalizada"
Locales["CUSTOM_GRID_DESC"] = "Actívalo para construir un diseño personalizado de múltiples columnas. Al activarlo, se ignora el orden estándar y las barras se colocan en la fila y columna exactas asignadas."
Locales["GRID_OPTIONS"] = "Configuración de Cuadrícula"
Locales["GRID_ROWS"] = "Filas Totales"
Locales["GRID_COLS_FOR_ROW"] = "Columnas para la Fila %d"
Locales["GRID_CELL"] = "Fila %d - Columna %d"

-- Grid Layout Presets
Locales["GRID_PRESET"] = "Preajuste de Diseño"
Locales["PRESET_CUSTOM"] = "Personalizado"
Locales["PRESET_2X1"] = "2x1 (2 Filas, 1 Columna)"
Locales["PRESET_2X2"] = "2x2 (2 Filas, 2 Columnas)"
Locales["PRESET_3X2"] = "3x2 (3 Filas, 2 Columnas)"
Locales["ASSIGN_BAR"] = "Asignar Barra"

-- Profiles Tab
Locales["PROFILES"] = "Perfiles"
Locales["PROFILE_DESC_1"] = "Puedes cambiar el perfil activo de la base de datos, para tener configuraciones diferentes para cada personaje."
Locales["PROFILE_DESC_2"] = "Restablece el perfil actual a sus valores por defecto."
Locales["RESET_PROFILE"] = "Restablecer Perfil"
Locales["CURRENT_PROFILE"] = "Perfil Actual:"
Locales["PROFILE_DESC_3"] = "Crea un nuevo perfil o elige uno existente."
Locales["NEW"] = "Nuevo Perfil"
Locales["EXISTING_PROFILES"] = "Perfiles Existentes"
Locales["COPY_PROFILE_DESC"] = "Copia la configuración de otro perfil en el perfil actual."
Locales["COPY_FROM"] = "Copiar de"
Locales["DELETE_PROFILE_DESC"] = "Elimina perfiles no utilizados para ahorrar espacio."
Locales["DELETE_PROFILE"] = "Eliminar un Perfil"
Locales["DELETE_PROFILE_CONFIRM"] = "¿Eliminar el perfil '%s'?"
Locales["ACCEPT"] = "Aceptar"
Locales["CANCEL"] = "Cancelar"
Locales["YES"] = "Sí"
Locales["NO"] = "No"
Locales["IMPORT_PROFILE"] = "Importar Perfil"
Locales["EXPORT_PROFILE"] = "Exportar Perfil"
Locales["IMPORT_EXPORT_DESC"] = "Comparte tu configuración con otros."
Locales["CLOSE"] = "Cerrar"
Locales["IMPORT"] = "Importar"
Locales["RESET_CONFIRM"] = "¿Estás seguro de que deseas restablecer el perfil '%s' a los valores por defecto?"