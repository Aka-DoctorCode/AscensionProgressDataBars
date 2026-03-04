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
Locales["CONFIG_MODE_DESC"] = "Mostra barras fictícias para visualizar alterações em tempo real."
Locales["FACTION_STANDINGS_RESET"] = "Redefinir Padrões"
Locales["EMPTY"] = "(Vazio)"

-- Tabs
Locales["TAB_BARS_LAYOUT"] = "Layout das Barras"
Locales["TAB_TEXT_LAYOUT"] = "Layout do Texto"
Locales["TAB_BEHAVIOR"] = "Comportamento"
Locales["TAB_COLORS"] = "Cores"
Locales["TAB_PARAGON_ALERTS"] = "Alertas de Paragon"

-- Global Controls
Locales["ENABLE"] = "Ativar"
Locales["ORDER"] = "Ordem"
Locales["ANCHOR"] = "Âncora"
Locales["TOP"] = "Topo"
Locales["BOTTOM"] = "Fundo"
Locales["FREE"] = "Livre"
Locales["WIDTH"] = "Largura"
Locales["HEIGHT"] = "Altura"
Locales["POS_X"] = "Pos X"
Locales["POS_Y"] = "Pos Y"
Locales["TXT_X"] = "Txt X"
Locales["TXT_Y"] = "Txt Y"

-- Layout Tab
Locales["GLOBAL_POSITIONING"] = "Posicionamento Global"
Locales["GLOBAL_BLOCKS_OFFSET"] = "Deslocamento Global de Blocos"
Locales["GLOBAL_BAR_HEIGHT"] = "Altura Global das Barras"
Locales["BAR_MANAGEMENT"] = "Gerenciamento de Barras"
Locales["TOP_BLOCK"] = "Bloco Superior"
Locales["BOTTOM_BLOCK"] = "Bloco Inferior"
Locales["FREE_MODE"] = "Modo Livre"

-- Appearance / Text Layout Tab
Locales["TEXT_AND_FONT"] = "Texto e Fonte"
Locales["LAYOUT_MODE"] = "Modo de Layout"
Locales["ALL_IN_ONE_LINE"] = "Tudo em uma linha"
Locales["MULTIPLE_LINES"] = "Múltiplas linhas"
Locales["TEXT_FOLLOWS_BAR"] = "O texto segue sua barra"
Locales["TEXT_FOLLOWS_BAR_DESC"] = "Se desativado, o texto será ancorado ao centro global."
Locales["FONT_SIZE"] = "Tamanho da Fonte"
Locales["GLOBAL_TEXT_COLOR"] = "Cor Global do Texto"
Locales["TEXT_GROUP_POSITIONS"] = "Posições dos Grupos de Texto"
Locales["DETACH_GROUP"] = "Desanexar %d"
Locales["DETACH_GROUP_DESC"] = "Ancorar o grupo %d globalmente em vez de às barras."
Locales["GROUP_X"] = "Grupo %d X"
Locales["GROUP_Y"] = "Grupo %d Y"
Locales["TEXT_MANAGEMENT"] = "Gerenciamento de Texto"
Locales["GROUP_1"] = "Grupo 1"
Locales["GROUP_2"] = "Grupo 2"
Locales["GROUP_3"] = "Grupo 3"

-- Behavior Tab
Locales["AUTO_HIDE_LOGIC"] = "Lógica de Ocultação Automática"
Locales["SHOW_ON_MOUSEOVER"] = "Mostrar ao passar o mouse"
Locales["HIDE_IN_COMBAT"] = "Ocultar em combate"
Locales["HIDE_AT_MAX_LEVEL"] = "Ocultar barra de XP no nível máximo"
Locales["DATA_DISPLAY"] = "Exibição de Dados"
Locales["SHOW_PERCENTAGE"] = "Mostrar porcentagem"
Locales["SHOW_ABSOLUTE_VALUES"] = "Mostrar valores absolutos"
Locales["SHOW_SPARK"] = "Mostrar brilho"

-- Colors Tab
Locales["EXPERIENCE"] = "Experiência"
Locales["USE_CLASS_COLOR"] = "Usar cor da classe"
Locales["CUSTOM_XP_COLOR"] = "Cor personalizada de XP"
Locales["SHOW_RESTED_BAR"] = "Mostrar barra de descanso"
Locales["RESTED_COLOR"] = "Cor de descanso"
Locales["REPUTATION"] = "Reputação"
Locales["USE_REACTION_COLORS"] = "Usar cores de reação"
Locales["CUSTOM_REP_COLOR"] = "Cor personalizada de reputação"
Locales["HONOR"] = "Honra"
Locales["HONOR_COLOR"] = "Cor de Honra"
Locales["HOUSE_FAVOR"] = "Favor da Casa"
Locales["HOUSE_XP_COLOR"] = "Cor de Favor da Casa"
Locales["HOUSE_REWARD_COLOR"] = "Cor do texto de recompensa"
Locales["HOUSE_REWARD_Y_OFFSET"] = "Offset Y do texto de recompensa"
Locales["AZERITE"] = "Artefato/Azerita"
Locales["AZERITE_COLOR"] = "Cor de Artefato"
Locales["RANK_NUM"] = "Rank %d"

-- Paragon Alerts Tab
Locales["ALERT_STYLING"] = "Estilo de Alertas"
Locales["SHOW_ON_TOP"] = "Mostrar no topo"
Locales["SPLIT_LINES"] = "Dividir linhas"
Locales["TEXT_SIZE"] = "Tamanho do texto"
Locales["VERTICAL_OFFSET_Y"] = "Deslocamento Vertical (Y)"
Locales["ALERT_COLOR"] = "Cor de alerta"

-- Standing Data
Locales["HATED"] = "Odiado"
Locales["HOSTILE"] = "Hostil"
Locales["UNFRIENDLY"] = "Indiferente"
Locales["NEUTRAL"] = "Neutro"
Locales["FRIENDLY"] = "Amigável"
Locales["HONORED"] = "Honrado"
Locales["REVERED"] = "Reverenciado"
Locales["EXALTED"] = "Exaltado"
Locales["PARAGON"] = "Paragon"
Locales["MAXED"] = "Máximo"
Locales["RENOWN"] = "Renome"
Locales["UNKNOWN_FACTION"] = "Facção Desconhecida"
Locales["UNKNOWN_STANDING"] = "???"

-- Formats
Locales["LEVEL_TEXT_ABS_PCT"] = "Nível %d | %s/%s (%.1f%%)"
Locales["LEVEL_TEXT_ABS"] = "Nível %d | %s/%s"
Locales["LEVEL_TEXT_PCT"] = "Nível %d | %.1f%%"
Locales["LEVEL_TEXT"] = "Nível %d"
Locales["RESTED_TEXT"] = " | Descanso %.1f%%"
Locales["RENOWN_LEVEL"] = "Renome %d"

-- Other Legacy Keys
Locales["APPEARANCE"] = "Aparência"
Locales["BAR_ANCHOR"] = "Posição da Barra"
Locales["BAR_GAP"] = "Espaço entre barras"
Locales["BAR_GAP_DESC"] = "Espaço entre barras."
Locales["ANCHOR_TOP"] = "Superior (Padrão)"
Locales["ANCHOR_BOTTOM"] = "Inferior"
Locales["ANCHOR_DESC"] = "Controla o ponto de ancoragem das barras. Parte superior: barras na parte superior, texto na parte inferior. Parte inferior: barras na parte inferior, texto na parte superior."
Locales["POSITION_SIZE"] = "Posição e Tamanho"
Locales["VERTICAL_POSITION"] = "Posição Vertical (Y)"
Locales["TEXT_GAP"] = "Espaço do Texto"
Locales["XP_BAR_HEIGHT"] = "Altura da Barra de XP"
Locales["REP_BAR_HEIGHT"] = "Altura da Barra de Reputação"
Locales["VISIBILITY"] = "Visibilidade"
Locales["COLORS"] = "Cores"
Locales["PARAGON_ALERTS"] = "Alertas de Paragon"
Locales["FACTION_COLORS"] = "Cores da facção"
Locales["ADVANCED"] = "Avançado"
Locales["REWARD_PENDING"] = " RECOMPENSA PENDENTE!"
Locales["AND"] = " E "
Locales["REWARD_PENDING_SINGLE"] = " RECOMPENSA PENDENTE!"
Locales["REWARD_PENDING_PLURAL"] = " RECOMPENSAS PENDENTES!"
Locales["XP_BAR_DATA"] = "Dados da barra de experiência | 0/0 (0.0%)"
Locales["REP_BAR_DATA"] = "Dados da barra de reputação | 0/0 (0.0%)"
Locales["CONFIG_FACTION_A_REWARD"] = "[CONFIG] RECOMPENSA FACÇÃO A"
Locales["CONFIG_FACTION_B_REWARD"] = "[CONFIG] RECOMPENSA FACÇÃO B"
Locales["CONFIG_MULTIPLE_REWARDS"] = "[CONFIG] MÚLTIPLES RECOMPENSAS PENDENTES!"
Locales["REWARD_PENDING_STATUS"] = "Recompensa Pendente"
Locales["OPTIONAL_BARS"] = "Barras Opcionais"
Locales["ENABLE_HONOR_BAR"] = "Ativar Barra de Honra"
Locales["HONOR_BAR_DATA"] = "Honra: 0%"
Locales["HONOR_BAR_HEIGHT"] = "Altura da barra de honra"
Locales["ENABLE_HOUSE_XP_BAR"] = "Ativar Barra de Favor da Casa"
Locales["HOUSE_XP_BAR_DATA"] = "Casa Nível 0 | 0/0 (0.0%)"
Locales["ENABLE_AZERITE_BAR"] = "Ativar Barra de Artefato"
Locales["AZERITE_BAR_DATA"] = "Poder de Artefato: 0%"
Locales["AZERITE_BAR_HEIGHT"] = "Altura da barra de artefato"
Locales["HOUSE_BAR_HEIGHT"] = "Altura da barra da casa"
Locales["ENABLE_BAR"] = "Ativar barra"
Locales["LAYOUT_BLOCK"] = "Bloco de Layout"
Locales["BAR_ORDER"] = "Posição"
Locales["BAR_WIDTH"] = "Largura"
Locales["BAR_HEIGHT"] = "Altura"
Locales["LAYOUT"] = "Layout"