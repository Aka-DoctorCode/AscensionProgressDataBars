-------------------------------------------------------------------------------
-- Project: AscensionBars
-- Author: Aka-DoctorCode
-- File: ptBR.lua
-- Version: @project-version@
-------------------------------------------------------------------------------
-- Copyright (c) 2025–2026 Aka-DoctorCode. All Rights Reserved.
--
-- This software and its source code are the exclusive property of the author.
-- No part of this file may be copied, modified, redistributed, or used in
-- derivative works without express written permission.
-------------------------------------------------------------------------------

local Locales = LibStub("AceLocale-3.0"):NewLocale("AscensionBars", "ptBR", true)

if not Locales then return end

-- General Configuration
Locales["ADDON_NAME"] = "Ascension Bars"
Locales["CONFIG_MODE"] = "Modo de Configuração"
Locales["CONFIG_MODE_DESC"] = "Mostra barras dummy para visualizar mudanças em tempo real."
Locales["FACTION_STANDINGS_RESET"] = "Resetar Padrões"
Locales["EMPTY"] = "(Vazio)"
Locales["AND"] = " E "
Locales["CONFIG_MODULE_MISSING"] = "AscensionBars: Módulo de configuração não encontrado."
Locales["TOGGLE_CONFIG_WINDOW"] = "Alternar Janela de Configuração"

-- Tabs
Locales["TAB_BARS_LAYOUT"] = "Layout das Barras"
Locales["TAB_TEXT_LAYOUT"] = "Layout do Texto"
Locales["TAB_BEHAVIOR"] = "Comportamento"
Locales["TAB_COLORS"] = "Cores"
Locales["TAB_PARAGON_ALERTS"] = "Alertas de Paragon"

-- UI Controls & Labels
Locales["ENABLE"] = "Ativar"
Locales["ANCHOR"] = "Âncora"
Locales["TOP"] = "Topo"
Locales["BOTTOM"] = "Base"
Locales["FREE"] = "Livre"
Locales["ORDER"] = "Ordem"
Locales["WIDTH"] = "Largura"
Locales["HEIGHT"] = "Altura"
Locales["POS_X"] = "Posição X"
Locales["POS_Y"] = "Posição Y"
Locales["TXT_X"] = "Deslocamento X do Texto"
Locales["TXT_Y"] = "Deslocamento Y do Texto"
Locales["GLOBAL_BLOCKS_OFFSET"] = "Deslocamento Global dos Blocos"
Locales["GLOBAL_BAR_HEIGHT"] = "Altura Global da Barra"
Locales["GLOBAL_OFFSET"] = "Deslocamento Global"
Locales["BAR_MANAGEMENT"] = "Gerenciamento de Barras"
Locales["TOP_BLOCK"] = "Bloco Superior"
Locales["BOTTOM_BLOCK"] = "Bloco Inferior"
Locales["FREE_MODE"] = "Modo Livre"

-- Experience Bar
Locales["EXPERIENCE"] = "Experiência"
Locales["XP_BAR_DATA"] = "Dados da Barra de Experiência | 0/0 (0.0%)"
Locales["XP_BAR_CONFIG_TEXT"] = "Experiência: 75% (Descanso)"
Locales["RESTED_XP"] = "XP de Descanso"
Locales["LEVEL_TEXT"] = "Nível %d"
Locales["LEVEL_TEXT_PCT"] = "%d | %d%%"
Locales["LEVEL_TEXT_ABS"] = "%d | %s / %s"
Locales["LEVEL_TEXT_ABS_PCT"] = "%d | %s / %s (%d%%)"
Locales["RESTED_TEXT"] = " (+%d%%)"

-- Reputation Bar
Locales["REPUTATION"] = "Reputação"
Locales["REP_BAR_DATA"] = "Dados da Barra de Reputação | 0/0 (0.0%)"
Locales["PARAGON"] = "Paragon"
Locales["RENOWN_LEVEL"] = "Nível de Renome"
Locales["REWARD_PENDING_STATUS"] = "Recompensa Pendente"
Locales["REWARD_PENDING_SINGLE"] = " RECOMPENSA PENDENTE!"
Locales["REWARD_PENDING_PLURAL"] = " RECOMPENSAS PENDENTES!"

-- Reputation Display Patterns
Locales["REP_LABEL_FORMAT"] = "%s (%s)"
Locales["REP_VALUE_FORMAT_FULL"] = "%s / %s (%.1f%%)"
Locales["REP_VALUE_FORMAT_PCT"] = "(%.1f%%)"

-- Honor Bar
Locales["HONOR"] = "Honra"
Locales["ENABLE_HONOR_BAR"] = "Ativar Barra de Honra"
Locales["HONOR_BAR_DATA"] = "Honra: 0%"
Locales["HONOR_BAR_HEIGHT"] = "Altura da Barra de Honra"
Locales["HONOR_LEVEL_FORMAT"] = "Nível de Honra %d | %s/%s (%.1f%%)"

-- Azerite Bar
Locales["AZERITE"] = "Azerite"
Locales["ENABLE_AZERITE_BAR"] = "Ativar Barra de Azerite"
Locales["AZERITE_BAR_DATA"] = "Poder de Azerite: 0%"
Locales["AZERITE_BAR_HEIGHT"] = "Altura da Barra de Azerite"
Locales["AZERITE_LEVEL_FORMAT"] = "Nível de Azerite %d | %s/%s (%.1f%%)"

-- Housing Favor Bar
Locales["HOUSE_FAVOR"] = "Favor da Casa"
Locales["ENABLE_HOUSE_XP_BAR"] = "Ativar Barra de Favor da Casa"
Locales["HOUSE_XP"] = "Favor da Casa"
Locales["HOUSE_BAR_HEIGHT"] = "Altura da Barra da Casa"
Locales["HOUSE_LEVEL_FORMAT"] = "%s | Nvl %d | %s / %s (%.1f%%)"
Locales["HOUSE_LEVEL_SIMPLE"] = "%s | Nível %d"
Locales["HOUSE_UPGRADES_AVAILABLE"] = "HOUSE UPGRADES AVAILABLE FOR %s"

-- Appearance Tab
Locales["TEXT_AND_FONT"] = "Texto e Fonte"
Locales["LAYOUT_MODE"] = "Modo de Layout"
Locales["ALL_IN_ONE_LINE"] = "Tudo em uma linha"
Locales["MULTIPLE_LINES"] = "Múltiplas linhas"
Locales["TEXT_FOLLOWS_BAR"] = "Texto segue a barra"
Locales["TEXT_FOLLOWS_BAR_DESC"] = "O Grupo de Texto 1 seguirá a posição da barra ativa mais baixa."
Locales["FONT_SIZE"] = "Tamanho da Fonte"
Locales["GLOBAL_TEXT_COLOR"] = "Cor Global do Texto"
Locales["TEXT_GROUP_POSITIONS"] = "Posições dos Grupos de Texto"
Locales["DETACH_GROUP"] = "Desvincular Grupo %d"
Locales["DETACH_GROUP_DESC"] = "Permitir que o Grupo %d seja posicionado independentemente."
Locales["GROUP_X"] = "Deslocamento X do Grupo %d"
Locales["GROUP_Y"] = "Deslocamento Y do Grupo %d"
Locales["TEXT_SIZE"] = "Tamanho do Texto"
    
Locales["TEXT_MANAGEMENT"] = "Gerenciamento de Texto"
Locales["GROUP_1"] = "Grupo 1"
Locales["GROUP_2"] = "Grupo 2"
Locales["GROUP_3"] = "Grupo 3"

-- Behavior Tab
Locales["AUTO_HIDE_LOGIC"] = "Lógica de Auto-Ocultar"
Locales["SHOW_ON_MOUSEOVER"] = "Mostrar ao Passar o Mouse"
Locales["HIDE_IN_COMBAT"] = "Ocultar em Combate"
Locales["HIDE_AT_MAX_LEVEL"] = "Ocultar no Nível Máximo"
Locales["DATA_DISPLAY"] = "Exibição de Dados"
Locales["SHOW_PERCENTAGE"] = "Mostrar Porcentagem"
Locales["SHOW_ABSOLUTE_VALUES"] = "Mostrar Valores Absolutos"
Locales["SHOW_SPARK"] = "Mostrar Spark"

-- Colors Tab
Locales["USE_CLASS_COLOR"] = "Usar Cor da Classe"
Locales["CUSTOM_XP_COLOR"] = "Cor Personalizada de XP"
Locales["SHOW_RESTED_BAR"] = "Mostrar Barra de Descanso"
Locales["RESTED_COLOR"] = "Cor de Descanso"
Locales["USE_REACTION_COLORS"] = "Usar Cores de Reação"
Locales["CUSTOM_REP_COLOR"] = "Cor Personalizada de Reputação"
Locales["HONOR_COLOR"] = "Cor de Honra"
Locales["HOUSE_XP_COLOR"] = "Cor de Favor da Casa"
Locales["HOUSE_REWARD_COLOR"] = "Cor do Texto de Recompensa da Casa"
Locales["HOUSE_REWARD_Y_OFFSET"] = "Deslocamento Y da Recompensa da Casa"
Locales["AZERITE_COLOR"] = "Cor de Azerite"

-- Reputation Standings
Locales["HATED"] = "Detestado"
Locales["HOSTILE"] = "Hostil"
Locales["UNFRIENDLY"] = "Inimigo"
Locales["NEUTRAL"] = "Neutro"
Locales["FRIENDLY"] = "Amigável"
Locales["HONORED"] = "Honrado"
Locales["REVERED"] = "Reverenciado"
Locales["EXALTED"] = "Exaltado"
Locales["MAXED"] = "No limite"
Locales["RENOWN"] = "Renome"
Locales["RANK_NUM"] = "Rank %d"

-- Paragon Alerts
Locales["ALERT_STYLING"] = "Estilo do Alerta"
Locales["SHOW_ON_TOP"] = "Mostrar no Topo"
Locales["SPLIT_LINES"] = "Dividir Linhas"
Locales["VERTICAL_OFFSET_Y"] = "Deslocamento Vertical Y"
Locales["ALERT_COLOR"] = "Cor do Alerta"
Locales["REWARD_AVAILABLE"] = "RECOMPENSA DISPONÍVEL PARA SER COLETADA"
Locales["REWARD_ON_CHAR"] = "RECOMPENSA DISPONÍVEL EM %s"
Locales["PARAGON_TEXT_SIZE"] = "Tamanho do Texto do Alerta"
Locales["PARAGON_TEXT_Y"] = "Deslocamento Y do Alerta"
Locales["PARAGON_ON_TOP"] = "Mostrar Alerta no Topo da Tela"

-- Config/Preview Strings
Locales["CONFIG_FACTION_A_REWARD"] = "[CONFIG] RECOMPENSA DA FACÇÃO A"
Locales["CONFIG_FACTION_B_REWARD"] = "[CONFIG] RECOMPENSA DA FACÇÃO B"
Locales["CONFIG_MULTIPLE_REWARDS"] = "[CONFIG] MÚLTIPLAS RECOMPENSAS PENDENTES!"