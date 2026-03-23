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
local Locales = _G.LibStub("AceLocale-3.0"):NewLocale("AscensionBars", "ptBR")

if not Locales then return end

-- General Configuration
Locales["ADDON_NAME"] = "Ascension Progress Data Bars"
Locales["CONFIG_MODE"] = "Modo de Configuração"
Locales["CONFIG_MODE_DESC"] = "Mostra barras de teste para visualizar as mudanças em tempo real."
Locales["FACTION_STANDINGS_RESET"] = "Restaurar Padrões"
Locales["EMPTY"] = "Vazio"
Locales["AND"] = " E "
Locales["CONFIG_MODULE_MISSING"] = "AscensionBars: Módulo de configuração não encontrado."
Locales["TOGGLE_CONFIG_WINDOW"] = "Alternar Janela de Configuração"

-- Tabs
Locales["TAB_BARS_LAYOUT"] = "Layout das Barras"
Locales["TAB_TEXT_LAYOUT"] = "Layout do Texto"
Locales["TAB_BEHAVIOR"] = "Comportamento"
Locales["TAB_COLORS"] = "Cores"
Locales["TAB_PARAGON_ALERTS"] = "Alertas"
Locales["TAB_PROFILES"] = "Perfis"

-- UI Controls & Labels
Locales["ENABLE"] = "Ativar"
Locales["ANCHOR"] = "Âncora"
Locales["TOP"] = "Topo"
Locales["BOTTOM"] = "Fundo"
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
Locales["GLOBAL_SETTINGS"] = "Configurações Globais"
Locales["PER_BLOCK_OFFSET"] = "Usar Deslocamento por Bloco"
Locales["PER_BLOCK_GAP"] = "Usar Espaçamento por Bloco"
Locales["BAR_GAP"] = "Espaçamento Global entre Barras"
Locales["TOP_OFFSET"] = "Deslocamento do Bloco Superior"
Locales["BOTTOM_OFFSET"] = "Deslocamento do Bloco Inferior"
Locales["BLOCK_HEIGHT"] = "Altura da Barra do Bloco"
Locales["USE_PER_BLOCK_HEIGHT"] = "Usar Altura por Bloco"
Locales["USE_CUSTOM_HEIGHT"] = "Usar Altura Personalizada"
Locales["CUSTOM_HEIGHT"] = "Altura Personalizada"
Locales["USE_PER_GROUP_SIZE"] = "Usar Tamanho por Grupo"
Locales["USE_PER_GROUP_COLOR"] = "Usar Cor por Grupo"
Locales["USE_CUSTOM_TEXT_SIZE"] = "Usar Tamanho de Texto Personalizado"
Locales["USE_CUSTOM_TEXT_COLOR"] = "Usar Cor de Texto Personalizada"
Locales["GROUP_SIZE"] = "Tamanho do Texto do Grupo"
Locales["GROUP_COLOR"] = "Cor do Texto do Grupo"
Locales["CUSTOM_TEXT_SIZE"] = "Tamanho de Texto Personalizado"
Locales["CUSTOM_TEXT_COLOR"] = "Cor de Texto Personalizada"
Locales["TOP_GAP"] = "Espaçamento do Bloco Superior"
Locales["BOTTOM_GAP"] = "Espaçamento do Bloco Inferior"
Locales["BAR_MANAGEMENT"] = "Gerenciamento de Barras"
Locales["TOP_BLOCK"] = "Bloco Superior"
Locales["BOTTOM_BLOCK"] = "Bloco Inferior"
Locales["FREE_MODE"] = "Modo Livre"
Locales["DIM_ALPHA"] = "Opacidade Escurecida"
Locales["CAROUSEL_OPTIONS"] = "Opções de Carrossel"
Locales["CAROUSEL_X_OFFSET"] = "Deslocamento X"
Locales["CAROUSEL_Y_OFFSET"] = "Deslocamento Y"
Locales["CAROUSEL_BG_ALPHA"] = "Opacidade do Fundo"

-- Experience Bar
Locales["EXPERIENCE"] = "Experiência"
Locales["XP_BAR_DATA"] = "Dados da Barra de Experiência | 0/0 (0.0%)"
Locales["XP_BAR_CONFIG_TEXT"] = "Experiência: 75% (Descansando)"
Locales["RESTED_XP"] = "Bônus de Descanso"
Locales["RESTED_TEXT"] = "Descansado"
Locales["LEVEL_TEXT"] = "Nível %d"
Locales["LEVEL_TEXT_ABS_PCT"] = "Nível %d | %s / %s (%.1f%%)"
Locales["LEVEL_TEXT_ABS"] = "Nível %d | %s / %s"
Locales["LEVEL_TEXT_PCT"] = "Nível %d | %.1f%%"
Locales["RESTED_LABEL"] = "Descansado: %s"

-- Reputation Bar
Locales["REPUTATION"] = "Reputação"
Locales["REP_BAR_DATA"] = "Dados da Barra de Reputação | 0/0 (0.0%)"
Locales["PARAGON"] = "Baluarte"
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
Locales["HONOR_LEVEL_SIMPLE"] = "Nível de Honra %d"
Locales["ENABLE_HONOR_BAR"] = "Ativar Barra de Honra"
Locales["HONOR_BAR_DATA"] = "Honra: 0%"
Locales["HONOR_BAR_HEIGHT"] = "Altura da Barra de Honra"
Locales["HONOR_LEVEL_FORMAT"] = "Nível de Honra %d | %s/%s (%.1f%%)"

-- Azerite Bar
Locales["AZERITE"] = "Azerita"
Locales["ENABLE_AZERITE_BAR"] = "Ativar Barra de Azerita"
Locales["AZERITE_BAR_DATA"] = "Poder de Azerita: 0%"
Locales["AZERITE_BAR_HEIGHT"] = "Altura da Barra de Azerita"
Locales["AZERITE_LEVEL_FORMAT"] = "Nível de Azerita %d | %s/%s (%.1f%%)"

-- Housing Favor Bar
Locales["HOUSE_FAVOR"] = "Nível de Favor da Casa"
Locales["ENABLE_HOUSE_XP_BAR"] = "Ativar Barra de Favor da Casa"
Locales["HOUSE_XP"] = "Favor da Casa"
Locales["HOUSE_BAR_HEIGHT"] = "Altura da Barra da Casa"
Locales["HOUSE_LEVEL_FORMAT"] = "Nível de %s %d | %s / %s (%.1f%%)"
Locales["HOUSE_LEVEL_ABS"]    = "Nível de %s %d | %s / %s"
Locales["HOUSE_LEVEL_PCT"]    = "Nível de %s %d | (%.1f%%)"
Locales["HOUSE_LEVEL_SIMPLE"] = "Nível de %s %d"
Locales["HOUSE_UPGRADES_AVAILABLE"] = "MELHORIAS DE CASA DISPONÍVEIS PARA %s"

-- Appearance Tab
Locales["TEXT_AND_FONT"] = "Texto e Fonte"
Locales["LAYOUT_MODE"] = "Modo de Layout"
Locales["ALL_IN_ONE_LINE"] = "Tudo em uma linha"
Locales["MULTIPLE_LINES"] = "Múltiplas linhas"
Locales["TEXT_FOLLOWS_BAR"] = "Texto acompanha a barra"
Locales["TEXT_FOLLOWS_BAR_DESC"] = "O Grupo de Texto 1 acompanhará a posição da barra ativa mais baixa."
Locales["FONT_SIZE"] = "Tamanho da Fonte"
Locales["GLOBAL_TEXT_COLOR"] = "Cor Global do Texto"
Locales["TEXT_GROUP_POSITIONS"] = "Posições dos Grupos de Texto"
Locales["DETACH_GROUP"] = "Separar Grupo %d"
Locales["DETACH_GROUP_DESC"] = "Permitir que o Grupo %d seja posicionado de forma independente."
Locales["GROUP_X"] = "Deslocamento X do Grupo %d"
Locales["GROUP_Y"] = "Deslocamento Y do Grupo %d"
Locales["TEXT_MANAGEMENT"] = "Gerenciamento de Texto"
Locales["TEXT_SIZE"] = "Tamanho do Texto"
Locales["GROUP_1"] = "Grupo 1"
Locales["GROUP_2"] = "Grupo 2"
Locales["GROUP_3"] = "Grupo 3"

-- Behavior Tab
Locales["AUTO_HIDE_LOGIC"] = "Lógica de Ocultar Automaticamente"
Locales["SHOW_ON_MOUSEOVER"] = "Mostrar ao Passar o Mouse"
Locales["HIDE_IN_COMBAT"] = "Ocultar em Combate"
Locales["HIDE_AT_MAX_LEVEL"] = "Ocultar Barra de XP no Nível Máximo"
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
Locales["HOUSE_XP_COLOR"] = "Cor do Favor da Casa"
Locales["HOUSE_REWARD_COLOR"] = "Cor do Texto de Recompensa da Casa"
Locales["HOUSE_REWARD_Y_OFFSET"] = "Deslocamento Y de Recompensa da Casa"
Locales["AZERITE_COLOR"] = "Cor de Azerita"

-- Reputation Standings
Locales["HATED"] = "Odiado"
Locales["HOSTILE"] = "Hostil"
Locales["UNFRIENDLY"] = "Inamistoso"
Locales["NEUTRAL"] = "Neutro"
Locales["FRIENDLY"] = "Respeitado"
Locales["HONORED"] = "Honrado"
Locales["REVERED"] = "Reverenciado"
Locales["EXALTED"] = "Exaltado"
Locales["MAXED"] = "Máximo"
Locales["RENOWN"] = "Renome"
Locales["RANK_NUM"] = "Nível %d"

-- Paragon Alerts
Locales["ALERT_STYLING"] = "Estilo de Alerta"
Locales["SHOW_ON_TOP"] = "Mostrar no Topo"
Locales["SPLIT_LINES"] = "Dividir Linhas"
Locales["VERTICAL_OFFSET_Y"] = "Deslocamento Vertical Y"
Locales["ALERT_COLOR"] = "Cor do Alerta"
Locales["REWARD_AVAILABLE"] = "RECOMPENSA DISPONÍVEL PARA COLETAR"
Locales["REWARD_ON_CHAR"] = "RECOMPENSA DISPONÍVEL EM %s"
Locales["PARAGON_TEXT_SIZE"] = "Tamanho do Texto do Alerta"
Locales["PARAGON_TEXT_Y"] = "Deslocamento Y do Alerta"
Locales["PARAGON_ON_TOP"] = "Mostrar Alerta no Topo da Tela"

-- Text Layout Tab
Locales["BLOCK_TEXT_MODE"] = "Comportamento do Texto"
Locales["TEXT_VISIBILITY_MODE"] = "Modo de Visibilidade do Texto"
Locales["FOCUS_MODE"] = "Mostrar ao Passar o Mouse"
Locales["GRID_DYNAMIC"] = "Sempre Visível"
Locales["NONE"] = "Nenhum"
Locales["BASE_TYPOGRAPHY"] = "Tipografia Base"
Locales["FONT_OUTLINE"] = "Contorno da Fonte"
Locales["VISUAL_OPTIONS"] = "Opções Visuais"
Locales["SHOW_RESTED"] = "Mostrar Bônus de Descanso"
Locales["USE_COMPACT_FORMAT"] = "Formato Compacto"
Locales["EVENTS_VISIBILITY"] = "Visibilidade"
Locales["ENABLE_CAROUSEL"] = "Ativar Carrossel de Eventos"
Locales["LATERAL_LEGEND"] = "Ativar Legenda Lateral"
Locales["DYNAMIC_GRID_GAP"] = "Espaço da Grade"
Locales["LEGEND_OPTIONS"] = "Opções de Legenda"
Locales["LEGEND_TEXT_SIZE"] = "Tamanho do Texto da Legenda"
Locales["LEGEND_BG_ALPHA"] = "Opacidade do Fundo"
Locales["LEGEND_FONT_OUTLINE"] = "Contorno da Fonte da Legenda"

-- Config/Preview Strings
Locales["CONFIG_FACTION_A_REWARD"] = "[CONFIG] RECOMPENSA DE FACÇÃO A"
Locales["CONFIG_FACTION_B_REWARD"] = "[CONFIG] RECOMPENSA DE FACÇÃO B"
Locales["CONFIG_MULTIPLE_REWARDS"] = "[CONFIG] MÚLTIPLAS RECOMPENSAS PENDENTES!"

-- Custom Grid Mode
Locales["CUSTOM_GRID_ENABLE"] = "Ativar Layout de Grade Personalizado"
Locales["CUSTOM_GRID_DESC"] = "Ative para criar um layout de várias colunas personalizado. Quando ativado, a ordem padrão é ignorada e as barras são colocadas na linha e coluna exatas."
Locales["GRID_OPTIONS"] = "Configuração de Grade"
Locales["GRID_ROWS"] = "Total de Linhas"
Locales["GRID_COLS_FOR_ROW"] = "Colunas para a Linha %d"
Locales["GRID_CELL"] = "Linha %d - Coluna %d"

-- Grid Layout Presets
Locales["GRID_PRESET"] = "Predefinição de Layout"
Locales["PRESET_CUSTOM"] = "Personalizado"
Locales["PRESET_2X1"] = "2x1 (2 Linhas, 1 Coluna)"
Locales["PRESET_2X2"] = "2x2 (2 Linhas, 2 Colunas)"
Locales["PRESET_3X2"] = "3x2 (3 Linhas, 2 Colunas)"
Locales["ASSIGN_BAR"] = "Atribuir Barra"

-- Profiles Tab
Locales["PROFILES"] = "Perfis"
Locales["PROFILE_DESC_1"] = "Você pode alterar o perfil ativo no banco de dados, para ter configurações diferentes para cada personagem."
Locales["PROFILE_DESC_2"] = "Restaure o perfil atual para seus valores padrão."
Locales["RESET_PROFILE"] = "Restaurar Perfil"
Locales["CURRENT_PROFILE"] = "Perfil Atual:"
Locales["PROFILE_DESC_3"] = "Crie um novo perfil ou escolha um existente."
Locales["NEW"] = "Novo Perfil"
Locales["EXISTING_PROFILES"] = "Perfis Existentes"
Locales["COPY_PROFILE_DESC"] = "Copie as configurações de outro perfil para o atual."
Locales["COPY_FROM"] = "Copiar de"
Locales["DELETE_PROFILE_DESC"] = "Exclua perfis não utilizados para economizar espaço."
Locales["DELETE_PROFILE"] = "Excluir um Perfil"
Locales["DELETE_PROFILE_CONFIRM"] = "Excluir perfil '%s'?"
Locales["ACCEPT"] = "Aceitar"
Locales["CANCEL"] = "Cancelar"
Locales["YES"] = "Sim"
Locales["NO"] = "Não"
Locales["IMPORT_PROFILE"] = "Importar Perfil"
Locales["EXPORT_PROFILE"] = "Exportar Perfil"
Locales["IMPORT_EXPORT_DESC"] = "Compartilhe sua configuração com outros."
Locales["CLOSE"] = "Fechar"
Locales["IMPORT"] = "Importar"
Locales["RESET_CONFIRM"] = "Tem certeza de que deseja restaurar o perfil '%s' para os padrões?"