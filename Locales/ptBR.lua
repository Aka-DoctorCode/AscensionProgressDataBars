-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
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

local _, addonTable = ...
local Locales = LibStub("AceLocale-3.0"):NewLocale("AscensionBars", "ptBR")

if not Locales then return end

-- General Configuration
Locales["ADDON_NAME"] = "Ascension Bars"
Locales["CONFIG_MODE"] = "Modo de Configuração"
Locales["CONFIG_MODE_DESC"] = "Mostra barras de teste para visualizar as mudanças em tempo real."
Locales["FACTION_STANDINGS_RESET"] = "Redefinir Padrões"
Locales["EMPTY"] = "(Vazio)"
Locales["AND"] = " E "
Locales["CONFIG_MODULE_MISSING"] = "AscensionBars: Módulo de configuração não encontrado."
Locales["TOGGLE_CONFIG_WINDOW"] = "Abrir/Fechar Janela de Configuração"

-- Tabs
Locales["TAB_BARS_LAYOUT"] = "Layout das Barras"
Locales["TAB_TEXT_LAYOUT"] = "Layout do Texto"
Locales["TAB_BEHAVIOR"] = "Comportamento"
Locales["TAB_COLORS"] = "Cores"
Locales["TAB_PARAGON_ALERTS"] = "Alertas"

-- UI Controls & Labels
Locales["ENABLE"] = "Habilitar"
Locales["ANCHOR"] = "Âncora"
Locales["TOP"] = "Superior"
Locales["BOTTOM"] = "Inferior"
Locales["FREE"] = "Livre"
Locales["ORDER"] = "Ordem"
Locales["WIDTH"] = "Largura"
Locales["HEIGHT"] = "Altura"
Locales["POS_X"] = "Posição X"
Locales["POS_Y"] = "Posição Y"
Locales["TXT_X"] = "Ajuste X do Texto"
Locales["TXT_Y"] = "Ajuste Y do Texto"
Locales["GLOBAL_BLOCKS_OFFSET"] = "Ajuste Global de Blocos"
Locales["GLOBAL_BAR_HEIGHT"] = "Altura Global da Barra"
Locales["GLOBAL_OFFSET"] = "Ajuste Global"
Locales["GLOBAL_SETTINGS"] = "Configurações Globais"
Locales["PER_BLOCK_OFFSET"] = "Usar Ajuste por Bloco"
Locales["PER_BLOCK_GAP"] = "Usar Separação por Bloco"
Locales["BAR_GAP"] = "Espaçamento Global entre Barras"
Locales["TOP_OFFSET"] = "Ajuste do Bloco Superior"
Locales["BOTTOM_OFFSET"] = "Ajuste do Bloco Inferior"
Locales["BLOCK_HEIGHT"] = "Altura do Bloco"
Locales["USE_PER_BLOCK_HEIGHT"] = "Usar Altura por Bloco"
Locales["USE_CUSTOM_HEIGHT"] = "Usar Altura Personalizada"
Locales["CUSTOM_HEIGHT"] = "Altura Personalizada"
Locales["USE_PER_GROUP_SIZE"] = "Usar Tamanho por Grupo"
Locales["USE_PER_GROUP_COLOR"] = "Usar Color por Grupo"
Locales["USE_CUSTOM_TEXT_SIZE"] = "Usar Tamanho de Texto Personalizado"
Locales["USE_CUSTOM_TEXT_COLOR"] = "Usar Color de Texto Personalizado"
Locales["GROUP_SIZE"] = "Tamanho de Texto do Grupo"
Locales["GROUP_COLOR"] = "Color de Texto do Grupo"
Locales["CUSTOM_TEXT_SIZE"] = "Tamanho de Texto Personalizado"
Locales["CUSTOM_TEXT_COLOR"] = "Cor do Texto Personalizada"
Locales["TOP_GAP"] = "Espaçamento do Bloco Superior"
Locales["BOTTOM_GAP"] = "Espaçamento do Bloco Inferior"
Locales["BAR_MANAGEMENT"] = "Gerenciamento de Barras"
Locales["TOP_BLOCK"] = "Bloco Superior"
Locales["BOTTOM_BLOCK"] = "Bloco Inferior"
Locales["FREE_MODE"] = "Modo Livre"
Locales["DIM_ALPHA"] = "Atenuação"

-- Experience Bar
Locales["EXPERIENCE"] = "Experiência"
Locales["XP_BAR_DATA"] = "Dados da Barra de Experiência | 0/0 (0.0%)"
Locales["XP_BAR_CONFIG_TEXT"] = "Experiência: 75% (Descansado)"
Locales["RESTED_XP"] = "XP de Descanso"
Locales["RESTED_TEXT"] = "Descansado"
Locales["LEVEL_TEXT"] = "Nível %d"
Locales["LEVEL_TEXT_ABS_PCT"] = "Nível %d | %s / %s (%.1f%%)"
Locales["LEVEL_TEXT_ABS"] = "Nivel %d | %s / %s"
Locales["LEVEL_TEXT_PCT"] = "Nível %d | %.1f%%"
Locales["RESTED_LABEL"] = "Descanso: %s"

-- Reputation Bar
Locales["REPUTATION"] = "Reputação"
Locales["REP_BAR_DATA"] = "Dados da Barra de Reputação | 0/0 (0.0%)"
Locales["PARAGON"] = "Baluarte"
Locales["RENOWN_LEVEL"] = "Nível de Renome"
Locales["REWARD_PENDING_STATUS"] = "Recompensa Pendente"
Locales["REWARD_PENDING_SINGLE"] = " ¡RECOMPENSA PENDENTE!"
Locales["REWARD_PENDING_PLURAL"] = " ¡RECOMPENSAS PENDENTES!"

-- Reputation Display Patterns
Locales["REP_LABEL_FORMAT"] = "%s (%s)"
Locales["REP_VALUE_FORMAT_FULL"] = "%s / %s (%.1f%%)"
Locales["REP_VALUE_FORMAT_PCT"] = "(%.1f%%)"

-- Honor Bar
Locales["HONOR"] = "Honra"
Locales["HONOR_LEVEL_SIMPLE"] = "Nível de Honra %d"
Locales["ENABLE_HONOR_BAR"] = "Habilitar Barra de Honra"
Locales["HONOR_BAR_DATA"] = "Honra: 0%"
Locales["HONOR_BAR_HEIGHT"] = "Altura da Barra de Honra"
Locales["HONOR_LEVEL_FORMAT"] = "Nível de Honra %d | %s/%s (%.1f%%)"

-- Azerite Bar
Locales["AZERITE"] = "Azerita"
Locales["ENABLE_AZERITE_BAR"] = "Habilitar Barra de Azerita"
Locales["AZERITE_BAR_DATA"] = "Poder de Azerita: 0%"
Locales["AZERITE_BAR_HEIGHT"] = "Altura da Barra de Azerita"
Locales["AZERITE_LEVEL_FORMAT"] = "Nível de Azerita %d | %s/%s (%.1f%%)"

-- Housing Favor Bar
Locales["HOUSE_FAVOR"] = "Favor da Casa"
Locales["ENABLE_HOUSE_XP_BAR"] = "Habilitar Barra de Favor"
Locales["HOUSE_XP"] = "Favor da Casa"
Locales["HOUSE_BAR_HEIGHT"] = "Altura da Barra da Casa"
Locales["HOUSE_LEVEL_FORMAT"] = "%s Nível %d | %s / %s (%.1f%%)"
Locales["HOUSE_LEVEL_ABS"]    = "%s Nível %d | %s / %s"
Locales["HOUSE_LEVEL_PCT"]    = "%s Nível %d | (%.1f%%)"
Locales["HOUSE_LEVEL_SIMPLE"] = "%s Nível %d"
Locales["HOUSE_UPGRADES_AVAILABLE"] = "MELHORIAS DE CASA DISPONÍVEIS PARA %s"

-- Appearance Tab (some keys still present but not used in new UI – kept for compatibility)
Locales["TEXT_AND_FONT"] = "Texto e Fonte"
Locales["LAYOUT_MODE"] = "Modo de Layout"
Locales["ALL_IN_ONE_LINE"] = "Tudo em uma linha"
Locales["MULTIPLE_LINES"] = "Múltiplas linhas"
Locales["TEXT_FOLLOWS_BAR"] = "Texto segue a barra"
Locales["TEXT_FOLLOWS_BAR_DESC"] = "O Grupo de Texto 1 seguirá a posição da barra ativa mais baixa."
Locales["FONT_SIZE"] = "Tamanho da Fonte"
Locales["GLOBAL_TEXT_COLOR"] = "Color de Texto Global"
Locales["TEXT_GROUP_POSITIONS"] = "Posições dos Grupos de Texto"
Locales["DETACH_GROUP"] = "Destacar Grupo %d"
Locales["DETACH_GROUP_DESC"] = "Permite que o Grupo %d seja posicionado independentemente."
Locales["GROUP_X"] = "Ajuste X do Grupo %d"
Locales["GROUP_Y"] = "Ajuste Y do Grupo %d"
Locales["TEXT_MANAGEMENT"] = "Gerenciamento de Texto"
Locales["TEXT_SIZE"] = "Tamanho do Texto"
Locales["GROUP_1"] = "Grupo 1"
Locales["GROUP_2"] = "Grupo 2"
Locales["GROUP_3"] = "Grupo 3"

-- Behavior Tab
Locales["AUTO_HIDE_LOGIC"] = "Lógica de Ocultar"
Locales["SHOW_ON_MOUSEOVER"] = "Mostrar ao passar o mouse"
Locales["HIDE_IN_COMBAT"] = "Ocultar em Combate"
Locales["HIDE_AT_MAX_LEVEL"] = "Ocultar barra XP no nível máximo"
Locales["DATA_DISPLAY"] = "Exibição de Dados"
Locales["SHOW_PERCENTAGE"] = "Mostrar Porcentagem"
Locales["SHOW_ABSOLUTE_VALUES"] = "Mostrar Valores Absolutos"
Locales["SHOW_SPARK"] = "Mostrar Faísca"

-- Colors Tab
Locales["USE_CLASS_COLOR"] = "Usar Cor da Classe"
Locales["CUSTOM_XP_COLOR"] = "Cor de XP Personalizada"
Locales["SHOW_RESTED_BAR"] = "Mostrar Barra de Descanso"
Locales["RESTED_COLOR"] = "Cor de Descanso"
Locales["USE_REACTION_COLORS"] = "Usar Cores de Reação"
Locales["CUSTOM_REP_COLOR"] = "Cor de Reputação Personalizada"
Locales["HONOR_COLOR"] = "Cor de Honra"
Locales["HOUSE_XP_COLOR"] = "Cor de Favor da Casa"
Locales["HOUSE_REWARD_COLOR"] = "Cor do Texto de Recompensa da Casa"
Locales["HOUSE_REWARD_Y_OFFSET"] = "Ajuste Y da Recompensa da Casa"
Locales["AZERITE_COLOR"] = "Cor de Azerita"

-- Reputation Standings
Locales["HATED"] = "Odiado"
Locales["HOSTILE"] = "Hostil"
Locales["UNFRIENDLY"] = "Hostil"
Locales["NEUTRAL"] = "Neutro"
Locales["FRIENDLY"] = "Amigável"
Locales["HONORED"] = "Honrado"
Locales["REVERED"] = "Reverenciado"
Locales["EXALTED"] = "Exaltado"
Locales["MAXED"] = "Máximo"
Locales["RENOWN"] = "Renome"
Locales["RANK_NUM"] = "Ranque %d"

-- Paragon Alerts
Locales["ALERT_STYLING"] = "Estilo do Alerta"
Locales["SHOW_ON_TOP"] = "Mostrar no Topo"
Locales["SPLIT_LINES"] = "Dividir Linhas"
Locales["VERTICAL_OFFSET_Y"] = "Ajuste Vertical Y"
Locales["ALERT_COLOR"] = "Cor do Alerta"
Locales["REWARD_AVAILABLE"] = "RECOMPENSA DISPONÍVEL PARA COLETAR"
Locales["REWARD_ON_CHAR"] = "RECOMPENSA DISPONÍVEL EM %s"
Locales["PARAGON_TEXT_SIZE"] = "Tamanho do Texto do Alerta"
Locales["PARAGON_TEXT_Y"] = "Ajuste Y do Alerta"
Locales["PARAGON_ON_TOP"] = "Mostrar Alerta no Topo da Tela"

-- Text Layout Tab (Updated)
Locales["BLOCK_TEXT_MODE"] = "Comportamento do texto"
Locales["TEXT_VISIBILITY_MODE"] = "Modo de visibilidade do texto"
Locales["FOCUS_MODE"] = "Mostrar ao passar o mouse"
Locales["GRID_DYNAMIC"] = "Sempre visível"
Locales["NONE"] = "Nenhum"
Locales["BASE_TYPOGRAPHY"] = "Tipografia base"
Locales["FONT_OUTLINE"] = "Contorno da fonte"
Locales["VISUAL_OPTIONS"] = "Opções visuais"
Locales["SHOW_RESTED"] = "Mostrar XP descansada"
Locales["USE_COMPACT_FORMAT"] = "Formato compacto"
Locales["EVENTS_VISIBILITY"] = "Eventos e visibilidade"
Locales["ENABLE_CAROUSEL"] = "Ativar carrossel de eventos"
Locales["REST_OPACITY"] = "Opacidade de fundo"
Locales["LATERAL_LEGEND"] = "Legenda lateral"
Locales["DYNAMIC_GRID_GAP"] = "Espaçamento da grade"

-- Config/Preview Strings
Locales["CONFIG_FACTION_A_REWARD"] = "[CONFIG] RECOMPENSA FACÇÃO A"
Locales["CONFIG_FACTION_B_REWARD"] = "[CONFIG] RECOMPENSA FACÇÃO B"
Locales["CONFIG_MULTIPLE_REWARDS"] = "[CONFIG] ¡MÚLTIPLAS RECOMPENSAS PENDENTES!"