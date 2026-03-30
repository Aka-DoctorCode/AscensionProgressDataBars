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
local Locales = _G.LibStub("AceLocale-3.0"):NewLocale("AscensionProgressDataBars", "ptBR", true)
if not Locales then return end

-------------------------------------------------------------------------------
-- GENERAL
-------------------------------------------------------------------------------
Locales["ADDON_NAME"] = "Barras de Progresso da Ascensão"
Locales["CONFIG_MODE"] = "Modo Configuração"
Locales["CONFIG_MODE_DESC"] = "Mostra barras de teste para visualizar alterações em tempo real."
Locales["FACTION_STANDINGS_RESET"] = "Restaurar Padrões"
Locales["EMPTY"] = "Vazio"
Locales["AND"] = " E "
Locales["CONFIG_MODULE_MISSING"] = "AscensionBars: Módulo de configuração não encontrado."
Locales["TOGGLE_CONFIG_WINDOW"] = "Alternar janela de configuração"

-------------------------------------------------------------------------------
-- CAROUSEL GAINS
-------------------------------------------------------------------------------
Locales["Experience"] = "Experiência"
Locales["Reputation"] = "Reputação"
Locales["House XP"] = "Experiência de Casa"
Locales["Honor"] = "Honra"
Locales["Azerite"] = "Azerita"

-------------------------------------------------------------------------------
-- TABS
-------------------------------------------------------------------------------
Locales["TAB_BARS_LAYOUT"] = "Layout das Barras"
Locales["TAB_CUSTOM_GRID"] = "Barras Personalizadas"
Locales["TAB_TEXT_LAYOUT"] = "Layout do Texto"
Locales["TAB_BEHAVIOR"] = "Comportamento"
Locales["TAB_COLORS"] = "Cores"
Locales["TAB_PARAGON_ALERTS"] = "Alertas"
Locales["TAB_PROFILES"] = "Perfis"

-------------------------------------------------------------------------------
-- UI CONTROLS & LABELS
-------------------------------------------------------------------------------
Locales["ENABLE"] = "Ativar"
Locales["ANCHOR"] = "Âncora"
Locales["TOP"] = "Superior"
Locales["BOTTOM"] = "Inferior"
Locales["FREE"] = "Livre"
Locales["ORDER"] = "Ordem"
Locales["WIDTH"] = "Largura"
Locales["HEIGHT"] = "Altura"
Locales["POS_X"] = "Posição X"
Locales["POS_Y"] = "Posição Y"
Locales["TXT_X"] = "Deslocamento X do Texto"
Locales["TXT_Y"] = "Deslocamento Y do Texto"
Locales["GLOBAL_BLOCKS_OFFSET"] = "Deslocamento Global dos Blocos"
Locales["GLOBAL_BAR_HEIGHT"] = "Altura Global das Barras"
Locales["GLOBAL_OFFSET"] = "Deslocamento Global"
Locales["GLOBAL_SETTINGS"] = "Configurações Globais"
Locales["PER_BLOCK_OFFSET"] = "Usar deslocamento por bloco"
Locales["PER_BLOCK_GAP"] = "Usar espaçamento por bloco"
Locales["BAR_GAP"] = "Espaçamento Global entre Barras"
Locales["TOP_OFFSET"] = "Deslocamento do Bloco Superior"
Locales["BOTTOM_OFFSET"] = "Deslocamento do Bloco Inferior"
Locales["BLOCK_HEIGHT"] = "Altura do Bloco"
Locales["USE_PER_BLOCK_HEIGHT"] = "Usar altura por bloco"
Locales["USE_CUSTOM_HEIGHT"] = "Usar altura personalizada"
Locales["CUSTOM_HEIGHT"] = "Altura personalizada"
Locales["USE_PER_GROUP_SIZE"] = "Usar tamanho por grupo"
Locales["USE_PER_GROUP_COLOR"] = "Usar cor por grupo"
Locales["USE_CUSTOM_TEXT_SIZE"] = "Usar tamanho de texto personalizado"
Locales["USE_CUSTOM_TEXT_COLOR"] = "Usar cor de texto personalizada"
Locales["GROUP_SIZE"] = "Tamanho do texto do grupo"
Locales["GROUP_COLOR"] = "Cor do texto do grupo"
Locales["CUSTOM_TEXT_SIZE"] = "Tamanho de texto personalizado"
Locales["CUSTOM_TEXT_COLOR"] = "Cor de texto personalizada"
Locales["TOP_GAP"] = "Espaçamento do Bloco Superior"
Locales["BOTTOM_GAP"] = "Espaçamento do Bloco Inferior"
Locales["BAR_MANAGEMENT"] = "Gerenciamento de Barras"
Locales["TOP_BLOCK"] = "Bloco Superior"
Locales["BOTTOM_BLOCK"] = "Bloco Inferior"
Locales["FREE_MODE"] = "Modo Livre"
Locales["DIM_ALPHA"] = "Alfa de Atenuação"
Locales["CAROUSEL_OPTIONS"] = "Opções do Carrrossel"
Locales["CAROUSEL_X_OFFSET"] = "Deslocamento X"
Locales["CAROUSEL_Y_OFFSET"] = "Deslocamento Y"
Locales["CAROUSEL_BG_ALPHA"] = "Alfa do Fundo"

-------------------------------------------------------------------------------
-- EXPERIENCE BAR
-------------------------------------------------------------------------------
Locales["EXPERIENCE"] = "Experiência"
Locales["XP_BAR_DATA"] = "Dados da Barra de Experiência | 0/0 (0.0%)"
Locales["XP_BAR_CONFIG_TEXT"] = "Experiência: 75% (Descanso)"
Locales["RESTED_XP"] = "Descanso"
Locales["RESTED_TEXT"] = "Descanso"
Locales["LEVEL_TEXT"] = "Nível %d"
Locales["LEVEL_TEXT_ABS_PCT"] = "Nível %d | %s / %s (%.1f%%)"
Locales["LEVEL_TEXT_ABS"] = "Nível %d | %s / %s"
Locales["LEVEL_TEXT_PCT"] = "Nível %d | %.1f%%"
Locales["RESTED_LABEL"] = "Descanso: %s"

-------------------------------------------------------------------------------
-- REPUTATION BAR
-------------------------------------------------------------------------------
Locales["REPUTATION"] = "Reputação"
Locales["REP_BAR_DATA"] = "Dados da Barra de Reputação | 0/0 (0.0%)"
Locales["PARAGON"] = "Paragon"
Locales["RENOWN_LEVEL"] = "Nível de Renome"
Locales["REWARD_PENDING_STATUS"] = "Recompensa Pendente"
Locales["REWARD_PENDING_SINGLE"] = " RECOMPENSA PENDENTE!"
Locales["REWARD_PENDING_PLURAL"] = " RECOMPENSAS PENDENTES!"
Locales["ADD_CUSTOM_REPUTATION"] = "Adicionar Reputação Personalizada"
Locales["SEARCH_FACTION"] = "Pesquisar Facção"
Locales["SELECT_FACTION"] = "Selecionar Facção"
Locales["ADD"] = "Adicionar"
Locales["DELETE"] = "Excluir"

-- Reputation Display Patterns
Locales["REP_LABEL_FORMAT"] = "%s (%s)"
Locales["REP_VALUE_FORMAT_FULL"] = "%s / %s (%.1f%%)"
Locales["REP_VALUE_FORMAT_PCT"] = "(%.1f%%)"

-------------------------------------------------------------------------------
-- HONOR BAR
-------------------------------------------------------------------------------
Locales["HONOR"] = "Honra"
Locales["HONOR_LEVEL_SIMPLE"] = "Nível de Honra %d"
Locales["ENABLE_HONOR_BAR"] = "Ativar Barra de Honra"
Locales["HONOR_BAR_DATA"] = "Honra: 0%"
Locales["HONOR_BAR_HEIGHT"] = "Altura da Barra de Honra"
Locales["HONOR_LEVEL_FORMAT"] = "Nível de Honra %d | %s/%s (%.1f%%)"

-------------------------------------------------------------------------------
-- AZERITE BAR
-------------------------------------------------------------------------------
Locales["AZERITE"] = "Azerita"
Locales["ENABLE_AZERITE_BAR"] = "Ativar Barra de Azerita"
Locales["AZERITE_BAR_DATA"] = "Poder de Azerita: 0%"
Locales["AZERITE_BAR_HEIGHT"] = "Altura da Barra de Azerita"
Locales["AZERITE_LEVEL_FORMAT"] = "Nível de Azerita %d | %s/%s (%.1f%%)"

-------------------------------------------------------------------------------
-- HOUSING FAVOR BAR
-------------------------------------------------------------------------------
Locales["HOUSE_FAVOR"] = "Nível de Favor da Casa"
Locales["ENABLE_HOUSE_XP_BAR"] = "Ativar Barra de Favor da Casa"
Locales["HOUSE_XP"] = "Favor da Casa"
Locales["HOUSE_BAR_HEIGHT"] = "Altura da Barra da Casa"
Locales["HOUSE_LEVEL_FORMAT"] = "%s Nível %d | %s / %s (%.1f%%)"
Locales["HOUSE_LEVEL_ABS"]    = "%s Nível %d | %s / %s"
Locales["HOUSE_LEVEL_PCT"]    = "%s Nível %d | (%.1f%%)"
Locales["HOUSE_LEVEL_SIMPLE"] = "%s Nível %d"
Locales["HOUSE_UPGRADES_AVAILABLE"] = "MELHORIAS DE CASA DISPONÍVEIS PARA %s"

-------------------------------------------------------------------------------
-- TEXT LAYOUT TAB
-------------------------------------------------------------------------------
Locales["TEXT_AND_FONT"] = "Texto e Fonte"
Locales["LAYOUT_MODE"] = "Modo de Layout"
Locales["ALL_IN_ONE_LINE"] = "Tudo em uma linha"
Locales["MULTIPLE_LINES"] = "Múltiplas linhas"
Locales["TEXT_FOLLOWS_BAR"] = "Texto segue a barra"
Locales["TEXT_FOLLOWS_BAR_DESC"] = "O Grupo de Texto 1 seguirá a posição da barra ativa mais baixa."
Locales["FONT_SIZE"] = "Tamanho da Fonte"
Locales["GLOBAL_TEXT_COLOR"] = "Cor do Texto Global"
Locales["TEXT_GROUP_POSITIONS"] = "Posições dos Grupos de Texto"
Locales["DETACH_GROUP"] = "Desvincular Grupo %d"
Locales["DETACH_GROUP_DESC"] = "Permite que o Grupo %d seja posicionado independentemente."
Locales["GROUP_X"] = "Deslocamento X do Grupo %d"
Locales["GROUP_Y"] = "Deslocamento Y do Grupo %d"
Locales["TEXT_MANAGEMENT"] = "Gerenciamento de Texto"
Locales["TEXT_SIZE"] = "Tamanho do Texto"
Locales["GROUP_1"] = "Grupo 1"
Locales["GROUP_2"] = "Grupo 2"
Locales["GROUP_3"] = "Grupo 3"

-------------------------------------------------------------------------------
-- BEHAVIOR TAB
-------------------------------------------------------------------------------
Locales["AUTO_HIDE_LOGIC"] = "Lógica de Auto-ocultação"
Locales["SHOW_ON_MOUSEOVER"] = "Mostrar ao passar o mouse"
Locales["HIDE_IN_COMBAT"] = "Ocultar em combate"
Locales["HIDE_AT_MAX_LEVEL"] = "Ocultar Barra de XP no Nível Máximo"
Locales["DATA_DISPLAY"] = "Exibição de Dados"
Locales["SHOW_PERCENTAGE"] = "Mostrar porcentagem"
Locales["SHOW_ABSOLUTE_VALUES"] = "Mostrar valores absolutos"
Locales["SHOW_SPARK"] = "Mostrar brilho"

-------------------------------------------------------------------------------
-- COLORS TAB
-------------------------------------------------------------------------------
Locales["USE_CLASS_COLOR"] = "Usar cor da classe"
Locales["CUSTOM_XP_COLOR"] = "Cor personalizada de XP"
Locales["SHOW_RESTED_BAR"] = "Mostrar barra de descanso"
Locales["RESTED_COLOR"] = "Cor de descanso"
Locales["USE_REACTION_COLORS"] = "Usar cores conforme reação"
Locales["CUSTOM_REP_COLOR"] = "Cor personalizada de reputação"
Locales["HONOR_COLOR"] = "Cor da honra"
Locales["HOUSE_XP_COLOR"] = "Cor do favor da casa"
Locales["HOUSE_REWARD_COLOR"] = "Cor do texto de recompensa da casa"
Locales["HOUSE_REWARD_Y_OFFSET"] = "Deslocamento Y da recompensa da casa"
Locales["AZERITE_COLOR"] = "Cor da azerita"

-------------------------------------------------------------------------------
-- REPUTATION STANDINGS
-------------------------------------------------------------------------------
Locales["HATED"] = "Odiado"
Locales["HOSTILE"] = "Hostil"
Locales["UNFRIENDLY"] = "Inimigável"
Locales["NEUTRAL"] = "Neutro"
Locales["FRIENDLY"] = "Amigável"
Locales["HONORED"] = "Honrado"
Locales["REVERED"] = "Reverenciado"
Locales["EXALTED"] = "Exaltado"
Locales["MAXED"] = "Máximo"
Locales["RENOWN"] = "Renome"
Locales["RANK_NUM"] = "Nível %d"

-------------------------------------------------------------------------------
-- PARAGON ALERTS
-------------------------------------------------------------------------------
Locales["ALERT_STYLING"] = "Estilo de Alerta"
Locales["SPLIT_LINES"] = "Dividir linhas"
Locales["ALERT_COLOR"] = "Cor do Alerta"
Locales["REWARD_AVAILABLE"] = "RECOMPENSA DISPONÍVEL PARA COLETAR"
Locales["REWARD_ON_CHAR"] = "RECOMPENSA DISPONÍVEL EM %s"
Locales["PARAGON_TEXT_SIZE"] = "Tamanho do Texto do Alerta"

-------------------------------------------------------------------------------
-- CUSTOM GRID MODE
-------------------------------------------------------------------------------
Locales["CUSTOM_GRID"] = "Barras Personalizadas"
Locales["CUSTOM_GRID_ENABLE"] = "Ativar layout de grade personalizada"
Locales["CUSTOM_GRID_DESC"] = "Ativar para criar um layout de várias colunas. Quando ativado, a ordem padrão das barras é ignorada e as barras são colocadas exatamente na linha e coluna que você designar."
Locales["ENABLE_ADVANCED_GRID"] = "Ativar grade personalizada (avançada)"
Locales["CUSTOM_GRID_DISABLED_MSG"] = "Ative a grade personalizada (avançada) acima para configurar layouts personalizados."
Locales["GRID_OPTIONS"] = "Configuração da Grade"
Locales["GRID_ROWS"] = "Total de Linhas"
Locales["GRID_COLS_FOR_ROW"] = "Colunas para a linha %d"
Locales["GRID_CELL"] = "Linha %d - Col %d"
Locales["GRID_PRESET"] = "Predefinição de Layout"
Locales["PRESET_CUSTOM"] = "Personalizado"
Locales["PRESET_2X1"] = "2x1 (2 linhas, 1 coluna)"
Locales["PRESET_2X2"] = "2x2 (2 linhas, 2 colunas)"
Locales["PRESET_3X2"] = "3x2 (3 linhas, 2 colunas)"
Locales["ASSIGN_BAR"] = "Atribuir Barra"

-------------------------------------------------------------------------------
-- TEXT LAYOUT (additional)
-------------------------------------------------------------------------------
Locales["BLOCK_TEXT_MODE"] = "Comportamento do Texto"
Locales["TEXT_VISIBILITY_MODE"] = "Modo de Visibilidade do Texto"
Locales["FOCUS_MODE"] = "Mostrar ao passar o mouse"
Locales["GRID_DYNAMIC"] = "Sempre visível"
Locales["NONE"] = "Nenhum"
Locales["BASE_TYPOGRAPHY"] = "Tipografia Base"
Locales["FONT_OUTLINE"] = "Contorno da Fonte"
Locales["VISUAL_OPTIONS"] = "Opções Visuais"
Locales["SHOW_RESTED"] = "Mostrar XP de descanso"
Locales["USE_COMPACT_FORMAT"] = "Formato compacto"
Locales["EVENTS_VISIBILITY"] = "Visibilidade"
Locales["ENABLE_CAROUSEL"] = "Ativar Carrrossel de Eventos"
Locales["LATERAL_LEGEND"] = "Ativar Legenda Lateral"
Locales["DYNAMIC_GRID_GAP"] = "Espaçamento da Grade"
Locales["LEGEND_OPTIONS"] = "Opções da Legenda"
Locales["LEGEND_TEXT_SIZE"] = "Tamanho do Texto da Legenda"
Locales["LEGEND_BG_ALPHA"] = "Alfa do Fundo"
Locales["LEGEND_FONT_OUTLINE"] = "Contorno da Fonte da Legenda"

-------------------------------------------------------------------------------
-- CONFIG / PREVIEW STRINGS
-------------------------------------------------------------------------------
Locales["CONFIG_FACTION_A_REWARD"] = "[CONFIG] RECOMPENSA DA FACÇÃO A"
Locales["CONFIG_FACTION_B_REWARD"] = "[CONFIG] RECOMPENSA DA FACÇÃO B"
Locales["CONFIG_MULTIPLE_REWARDS"] = "[CONFIG] MÚLTIPLAS RECOMPENSAS PENDENTES"

-------------------------------------------------------------------------------
-- PROFILES TAB
-------------------------------------------------------------------------------
Locales["PROFILES"] = "Perfis"
Locales["PROFILE_DESC_1"] = "Você pode alterar o perfil ativo do banco de dados para ter configurações diferentes para cada personagem."
Locales["PROFILE_DESC_2"] = "Restaura o perfil atual para seus valores padrão."
Locales["RESET_PROFILE"] = "Restaurar Perfil"
Locales["CURRENT_PROFILE"] = "Perfil atual:"
Locales["PROFILE_DESC_3"] = "Crie um novo perfil ou escolha um existente."
Locales["NEW"] = "Novo Perfil"
Locales["EXISTING_PROFILES"] = "Perfis Existentes"
Locales["COPY_PROFILE_DESC"] = "Copiar configurações de outro perfil para o atual."
Locales["COPY_FROM"] = "Copiar de"
Locales["DELETE_PROFILE_DESC"] = "Excluir perfis não utilizados para economizar espaço."
Locales["DELETE_PROFILE"] = "Excluir um Perfil"
Locales["DELETE_PROFILE_CONFIRM"] = "Excluir o perfil '%s'?"
Locales["ACCEPT"] = "Aceitar"
Locales["CANCEL"] = "Cancelar"
Locales["YES"] = "Sim"
Locales["NO"] = "Não"
Locales["IMPORT_PROFILE"] = "Importar Perfil"
Locales["EXPORT_PROFILE"] = "Exportar Perfil"
Locales["IMPORT_EXPORT_DESC"] = "Compartilhe sua configuração com outras pessoas."
Locales["CLOSE"] = "Fechar"
Locales["IMPORT"] = "Importar"
Locales["RESET_CONFIRM"] = "Tem certeza de que deseja restaurar o perfil '%s' aos valores padrão?"