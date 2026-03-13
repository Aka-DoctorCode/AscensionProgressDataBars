-------------------------------------------------------------------------------
-- Project: AscensionBars
-- Author: Aka-DoctorCode
-- File: BarsLayout.lua
-- Version: @project-version@
-------------------------------------------------------------------------------
-- Copyright (c) 2025–2026 Aka-DoctorCode. All Rights Reserved.
--
-- This software and its source code are the exclusive property of the author.
-- No part of this file may be copied, modified, redistributed, or used in
-- derivative works without express written permission.
-------------------------------------------------------------------------------


local addonName, addonTable = ...
local ascensionBars = addonTable.main or LibStub("AceAddon-3.0"):GetAddon(addonName)
local locales = LibStub("AceLocale-3.0"):GetLocale("AscensionBars")

-- Use the shared utilities that will be defined in our main ConfigMain.lua
local colors = ascensionBars.colors
local menuStyle = ascensionBars.menuStyle

-- Object-Oriented module for the Bars Layout Tab
addonTable.barsLayoutTab = {}
local barsLayoutTab = addonTable.barsLayoutTab

function barsLayoutTab:createBarControls(layout, profile, barKey, displayName, panel, controlWidth, xOffset)
    if not profile or not profile.bars or not profile.bars[barKey] then return end
    local bar = profile.bars[barKey]

    layout:beginSection(xOffset, controlWidth)
    
    -- Título de la tarjeta
    layout:label("BarHeader_" .. barKey, displayName, xOffset + 5, colors.gold)
    
    local margin = 10
    local internalWidth = controlWidth - (margin * 2)
    
    -- VARIABLES GLOBALES DE LA FUNCIÓN (Para evitar errores de 'nil')
    local halfWidth = (internalWidth - 10) / 2
    local colWidth = (internalWidth - 20) / 3
    
    local col1X = xOffset + margin
    local col2X = col1X + colWidth + 10
    local col3X = col2X + colWidth + 10
    local ddCol2X = col1X + halfWidth + 10

    ---------------------------------------------------------------------------
    -- DISPOSICIÓN DE ELEMENTOS (FILAS Y COLUMNAS)
    ---------------------------------------------------------------------------
    local row1Y = layout.y
    local row2Y = row1Y - 45 -- Fila 2 para modo TOP/BOTTOM
    local freeRow2Y = row1Y - 85 -- Separación MUCHO MAYOR (85px) para dar espacio a los Sliders en FREE
    local finalY = row2Y

    if bar.block == "FREE" then
        -- ====================================================
        -- MODO FREE: 3 Columnas, 2 Filas exactas
        -- ====================================================
        
        -- COLUMNA 1: Toggle & Dropdown
        layout.y = row1Y
        layout:checkbox("EnableBarCheckbox_" .. barKey, locales["ENABLE"], nil,
            function() return bar.enabled end,
            function(v) bar.enabled = v; ascensionBars:updateDisplay() end, col1X - 6)
            
        layout.y = freeRow2Y
        layout:dropdown("AnchorDropdown_" .. barKey, locales["ANCHOR"],
            {{label=locales["TOP"], value="TOP"}, {label=locales["BOTTOM"], value="BOTTOM"}, {label=locales["FREE"], value="FREE"}},
            function() return bar.block end,
            function(v)
                local old = bar.block; bar.block = v
                addonTable.configUtils:cleanOrders(profile, "block", "order", old)
                bar.order = math.max(1, addonTable.configUtils:getCount(profile, "block", v))
                ascensionBars:updateDisplay()
                if panel.updateLayout then _G.C_Timer.After(0.01, function() panel:updateLayout() end) end
            end, colWidth, col1X)
        finalY = math.min(finalY, layout.y)

        -- COLUMNA 2: Width & Height
        layout.y = row1Y
        layout:slider("WidthSlider_" .. barKey, locales["WIDTH"], 50, 2000, 1,
            function() return bar.freeWidth end,
            function(v) bar.freeWidth = v; ascensionBars:updateDisplay() end, colWidth, col2X)
            
        layout.y = freeRow2Y
        layout:slider("HeightSlider_" .. barKey, locales["HEIGHT"], 2, 100, 1,
            function() return bar.freeHeight or 15 end,
            function(v) bar.freeHeight = v; ascensionBars:updateDisplay() end, colWidth, col2X)
        finalY = math.min(finalY, layout.y)

        -- COLUMNA 3: PosX & PosY
        layout.y = row1Y
        layout:slider("PosXSlider_" .. barKey, locales["POS_X"], -1000, 1000, 1,
            function() return bar.freeX end,
            function(v) bar.freeX = v; ascensionBars:updateDisplay() end, colWidth, col3X)
            
        layout.y = freeRow2Y
        layout:slider("PosYSlider_" .. barKey, locales["POS_Y"], -1000, 1000, 1,
            function() return bar.freeY end,
            function(v) bar.freeY = v; ascensionBars:updateDisplay() end, colWidth, col3X)
        finalY = math.min(finalY, layout.y)

    else
        -- ====================================================
        -- MODO TOP / BOTTOM (Estructura Original Respetada)
        -- ====================================================
        
        -- Fila 1: Checkboxes
        layout.y = row1Y
        layout:checkbox("EnableBarCheckbox_" .. barKey, locales["ENABLE"], nil,
            function() return bar.enabled end,
            function(v) bar.enabled = v; ascensionBars:updateDisplay() end, col1X - 6)
            
        layout.y = row1Y
        layout:checkbox("UseCustomHeightCheckbox_" .. barKey, locales["USE_CUSTOM_HEIGHT"], nil,
            function() return bar.useCustomHeight end,
            function(v) 
                bar.useCustomHeight = v 
                ascensionBars:updateDisplay()
                if panel.updateLayout then panel:updateLayout() end 
            end, col2X - 6)
            
        -- Fila 2: Dropdowns (Mitad y Mitad)
        layout.y = row2Y
        layout:dropdown("AnchorDropdown_" .. barKey, locales["ANCHOR"],
            {{label=locales["TOP"], value="TOP"}, {label=locales["BOTTOM"], value="BOTTOM"}, {label=locales["FREE"], value="FREE"}},
            function() return bar.block end,
            function(v)
                local old = bar.block; bar.block = v
                addonTable.configUtils:cleanOrders(profile, "block", "order", old)
                bar.order = math.max(1, addonTable.configUtils:getCount(profile, "block", v))
                ascensionBars:updateDisplay()
                if panel.updateLayout then _G.C_Timer.After(0.01, function() panel:updateLayout() end) end
            end, halfWidth, col1X)
            
        layout.y = row2Y
        local orderOptions = {}
        for j = 1, addonTable.configUtils:getCount(profile, "block", bar.block) do
            table.insert(orderOptions, { label = tostring(j), value = j })
        end
        layout:dropdown("OrderDropdown_" .. barKey, locales["ORDER"], orderOptions,
            function() return bar.order or 1 end,
            function(v)
                local old = bar.order or 1; if old == v then return end
                bar.order = (v > old) and (v + 0.5) or (v - 0.5)
                addonTable.configUtils:cleanOrders(profile, "block", "order", bar.block)
                ascensionBars:updateDisplay()
                if panel.updateLayout then _G.C_Timer.After(0.01, function() panel:updateLayout() end) end
            end, halfWidth, ddCol2X)
            
        local row3Y = layout.y - 10
        finalY = row3Y
        
        -- Fila 3: Sliders Opcionales
        if bar.useCustomHeight then
            layout.y = row3Y
            layout:slider("CustomHeightSlider_" .. barKey, locales["CUSTOM_HEIGHT"], 1, 50, 1,
                function() return bar.customHeight or 10 end,
                function(v) bar.customHeight = v; ascensionBars:updateDisplay() end, colWidth, col1X)
            finalY = math.min(finalY, layout.y)
        end
        
        if profile.textLayoutMode == "INDIVIDUAL_LINES" then
            layout.y = row3Y
            layout:slider("TextXSlider_" .. barKey, locales["TXT_X"], -500, 500, 1,
                function() return bar.textX or 0 end,
                function(v) bar.textX = v; ascensionBars:updateDisplay() end, colWidth, col2X)
            finalY = math.min(finalY, layout.y)
            
            layout.y = row3Y
            layout:slider("TextYSlider_" .. barKey, locales["TXT_Y"], -500, 500, 1,
                function() return bar.textY or 0 end,
                function(v) bar.textY = v; ascensionBars:updateDisplay() end, colWidth, col3X)
            finalY = math.min(finalY, layout.y)
        end
    end

    layout.y = finalY - 12
    layout:endSection()
    layout.y = layout.y - 15
end

function barsLayoutTab:build(panel)
    if not panel or not panel.content then return end
    
    addonTable.configUtils:cleanupContent(panel.content)
    
    local content = panel.content
    local profile = ascensionBars.db.profile
    if not profile then return end

    local defaultAvailableSpace = (ascensionBars.normalWidth or 750) - (menuStyle.sidebarWidth or 150) - 30
    local colGap = 10
    local y = -15

    -- SECCIÓN 1: GLOBAL SETTINGS
    local mainLayout = addonTable.layoutModel:new(content, y)
    mainLayout:header("GlobalOffsetHeader", locales["GLOBAL_SETTINGS"] or "Global Settings")
    
    local topColWidth = (defaultAvailableSpace - colGap) / 2
    local topCol1X = 15
    local topCol2X = 15 + topColWidth + colGap
    local startTopY = mainLayout.y

    mainLayout:slider("GlobalBarHeightSlider", locales["GLOBAL_BAR_HEIGHT"], 1, 50, 1,
        function() return profile.globalBarHeight end,
        function(v) profile.globalBarHeight = v; ascensionBars:updateDisplay() end,
        topColWidth - 20, topCol1X)

    local afterCol1Row1 = mainLayout.y
    mainLayout.y = startTopY

    mainLayout:checkbox("PerBlockOffsetToggle", locales["PER_BLOCK_OFFSET"] or "Use Per-Block Offset", nil,
        function() return profile.usePerBlockOffsets end,
        function(v)
            profile.usePerBlockOffsets = v
            ascensionBars:updateDisplay()
            if panel.updateLayout then _G.C_Timer.After(0.01, function() panel:updateLayout() end) end
        end, topCol2X - 6)

    mainLayout:checkbox("PerBlockGapToggle", locales["PER_BLOCK_GAP"] or "Use Per-Block Gap", nil,
        function() return profile.usePerBlockGaps end,
        function(v)
            profile.usePerBlockGaps = v
            ascensionBars:updateDisplay()
            if panel.updateLayout then _G.C_Timer.After(0.01, function() panel:updateLayout() end) end
        end, topCol2X - 6)

    mainLayout.y = math.min(afterCol1Row1, mainLayout.y) - 10
    local configStartY = mainLayout.y

    if not profile.usePerBlockOffsets then
        mainLayout:slider("GlobalBlocksOffsetSlider", locales["GLOBAL_BLOCKS_OFFSET"], -500, 0, 1,
            function() return profile.yOffset end,
            function(v) profile.yOffset = v; ascensionBars:updateDisplay() end, topColWidth - 20, topCol1X)
    else
        mainLayout:slider("TopBlockOffsetSlider", locales["TOP_OFFSET"], -500, 0, 1,
            function() return profile.topOffset or 0 end,
            function(v) profile.topOffset = v; ascensionBars:updateDisplay() end, topColWidth - 20, topCol1X)
        mainLayout:slider("BottomBlockOffsetSlider", locales["BOTTOM_OFFSET"], 0, 500, 1,
            function() return profile.bottomOffset or 0 end,
            function(v) profile.bottomOffset = v; ascensionBars:updateDisplay() end, topColWidth - 20, topCol1X)
    end

    local afterOffsetsY = mainLayout.y
    mainLayout.y = configStartY

    if not profile.usePerBlockGaps then
        mainLayout:slider("GlobalBarGapSlider", locales["BAR_GAP"], 0, 50, 1,
            function() return profile.barGap or 2 end,
            function(v) profile.barGap = v; ascensionBars:updateDisplay() end, topColWidth - 20, topCol2X)
    else
        mainLayout:slider("TopBlockGapSlider", locales["TOP_GAP"], 0, 50, 1,
            function() return profile.topBarGap or 2 end,
            function(v) profile.topBarGap = v; ascensionBars:updateDisplay() end, topColWidth - 20, topCol2X)
        mainLayout:slider("BottomBlockGapSlider", locales["BOTTOM_GAP"], 0, 50, 1,
            function() return profile.bottomBarGap or 2 end,
            function(v) profile.bottomBarGap = v; ascensionBars:updateDisplay() end, topColWidth - 20, topCol2X)
    end

    mainLayout.y = math.min(afterOffsetsY, mainLayout.y) - 15
    
    -- SECCIÓN BAR MANAGEMENT
    mainLayout:header("BarManagementHeader", locales["BAR_MANAGEMENT"])
    local barStartY = mainLayout.y

    local barKeys = { "XP", "Rep", "Honor", "HouseXp", "Azerite" }
    local barNames = { locales["EXPERIENCE"], locales["REPUTATION"], locales["HONOR"], locales["HOUSE_FAVOR"], locales["AZERITE"] }
    
    local twoColWidth = (defaultAvailableSpace - colGap) / 2
    local blocks = {
        { name = locales["TOP_BLOCK"],    key = "TOP",    x = 10, width = twoColWidth },
        { name = locales["BOTTOM_BLOCK"], key = "BOTTOM", x = 10 + twoColWidth + colGap, width = twoColWidth }
    }

    local maxRowY = barStartY

    for _, block in ipairs(blocks) do
        local layoutCol = addonTable.layoutModel:new(content, barStartY)
        local header = content:CreateFontString(nil, "OVERLAY", menuStyle.labelFont)
        header:SetPoint("TOPLEFT", block.x, barStartY)
        header:SetWidth(block.width)
        header:SetJustifyH("CENTER")
        header:SetText(block.name)
        
        local fontPath, _, outline = header:GetFont()
        header:SetFont(fontPath, 20, outline)
        header:SetTextColor(0.64, 0.21, 0.93)
        
        layoutCol.y = barStartY - 30
        layoutCol:slider("BlockHeightSlider_" .. block.key, locales["BLOCK_HEIGHT"], 1, 50, 1,
            function() 
                profile.blockHeights = profile.blockHeights or {}
                return profile.blockHeights[block.key] or profile.globalBarHeight or 10
            end,
            function(v) 
                profile.blockHeights = profile.blockHeights or {}
                profile.blockHeights[block.key] = v
                ascensionBars:updateDisplay() 
            end, block.width - 10, block.x + 5)
        
        layoutCol.y = layoutCol.y - 10

        local sorted = {}
        for i, key in ipairs(barKeys) do
            if profile.bars[key] and (profile.bars[key].block or "TOP") == block.key then
                table.insert(sorted, { key = key, name = barNames[i] })
            end
        end
        table.sort(sorted, function(a, b) return (profile.bars[a.key].order or 0) < (profile.bars[b.key].order or 0) end)

        for _, bar in ipairs(sorted) do
            self:createBarControls(layoutCol, profile, bar.key, bar.name, panel, block.width, block.x)
        end
        if layoutCol.y < maxRowY then maxRowY = layoutCol.y end
    end

    -- SECCIÓN FREE MODE
    local freeStartY = maxRowY - 10
    local layoutFree = addonTable.layoutModel:new(content, freeStartY)
    local freeHeader = content:CreateFontString(nil, "OVERLAY", menuStyle.labelFont)
    freeHeader:SetPoint("TOPLEFT", 10, freeStartY)
    freeHeader:SetWidth(defaultAvailableSpace)
    freeHeader:SetJustifyH("CENTER")
    freeHeader:SetText(locales["FREE_MODE"])
    
    local fFont, _, fOutline = freeHeader:GetFont()
    freeHeader:SetFont(fFont, 20, fOutline)
    freeHeader:SetTextColor(0.64, 0.21, 0.93)
    
    layoutFree.y = freeStartY - 40
    for i, key in ipairs(barKeys) do
        if (profile.bars[key] and profile.bars[key].block == "FREE") then
            self:createBarControls(layoutFree, profile, key, barNames[i], panel, defaultAvailableSpace, 10)
        end
    end

    content:SetHeight(math.abs(layoutFree.y) + 50)
end