-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
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
---@type AscensionBars
local ascensionBars = addonTable.main or _G.LibStub("AceAddon-3.0"):GetAddon(addonName)
---@cast ascensionBars AscensionBars
local locales = _G.LibStub("AceLocale-3.0"):GetLocale("AscensionProgressDataBars")

-- Use the shared utilities that will be defined in our main ConfigMain.lua
local colors = ascensionBars.colors
local menuStyle = ascensionBars.menuStyle

-- Object-Oriented module for the Bars Layout Tab
addonTable.barsLayoutTab = {}
local barsLayoutTab = addonTable.barsLayoutTab

-------------------------------------------------------------------------------
-- CORE LAYOUT BUILDER
-------------------------------------------------------------------------------

function barsLayoutTab:createBarControls(layout, profile, barKey, displayName, panel, controlWidth, xOffset)
    if not profile or not profile.bars or not profile.bars[barKey] then return end
    local bar = profile.bars[barKey]

    layout:beginSection(xOffset, controlWidth)
    
    -- Card Title
    layout:label("BarHeader_" .. barKey, displayName, xOffset + 5, colors.gold) -- #FFD100
    
    local margin = 10
    local internalWidth = controlWidth - (margin * 2)
    
    local halfWidth = (internalWidth - 10) / 2
    local colWidth = (internalWidth - 20) / 3
    
    local col1X = xOffset + margin
    local col2X = col1X + colWidth + 10
    local col3X = col2X + colWidth + 10
    local ddCol2X = col1X + halfWidth + 10

    local row1Y = layout.y
    local row2Y = row1Y - 45
    local freeRow2Y = row1Y - 85
    local finalY = row2Y

    if bar.block == "FREE" then
        layout.y = row1Y
        layout:checkbox("EnableBarCheckbox_" .. barKey, locales["ENABLE"], nil,
            function() return bar.enabled end,
            function(v) bar.enabled = v; ascensionBars:updateDisplay() end, col1X - 6)
            
        if string.match(barKey, "^Rep_%d+$") then
            layout:button("DeleteBtn_" .. barKey, locales["DELETE"] or "Delete", 80, 24, col3X, function()
                profile.bars[barKey] = nil
                ascensionBars:removeDynamicBar(barKey)
                ascensionBars:updateDisplay()
                if panel.updateLayout then panel:updateLayout() end
            end)
        end

        layout.y = freeRow2Y
        layout:dropdown("AnchorDropdown_" .. barKey, locales["ANCHOR"],
            {{label=locales["TOP"], value="TOP"}, {label=locales["BOTTOM"], value="BOTTOM"}, {label=locales["FREE"], value="FREE"}},
            function() return bar.block end,
            function(v)
                local old = bar.block; bar.block = v
                addonTable.configUtils:cleanOrders(profile, "block", "order", old)
                bar.order = math.max(1, addonTable.configUtils:getCount(profile, "block", v))
                
                -- LIMPIADOR DE GRID: Si la barra se va de un bloque con Grid activo, la quitamos de su cuadrícula.
                if profile.customGrids and profile.customGrids[old] and profile.customGrids[old].assignments then
                    for r, row in pairs(profile.customGrids[old].assignments) do
                        for c, assignedBar in pairs(row) do
                            if assignedBar == barKey then
                                profile.customGrids[old].assignments[r][c] = "none"
                            end
                        end
                    end
                end

                ascensionBars:updateDisplay()
                if panel.updateLayout then _G.C_Timer.After(0.01, function() panel:updateLayout() end) end
            end, colWidth, col1X)
        finalY = math.min(finalY, layout.y)

        layout.y = row1Y
        layout:slider("WidthSlider_" .. barKey, locales["WIDTH"], 50, 2000, 1,
            function() return bar.freeWidth end,
            function(v) bar.freeWidth = v; ascensionBars:updateDisplay() end, colWidth, col2X)
            
        layout.y = freeRow2Y
        layout:slider("HeightSlider_" .. barKey, locales["HEIGHT"], 2, 100, 1,
            function() return bar.freeHeight or 15 end,
            function(v) bar.freeHeight = v; ascensionBars:updateDisplay() end, colWidth, col2X)
        finalY = math.min(finalY, layout.y)

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
        layout.y = row1Y
        layout:checkbox("EnableBarCheckbox_" .. barKey, locales["ENABLE"], nil,
            function() return bar.enabled end,
            function(v) bar.enabled = v; ascensionBars:updateDisplay() end, col1X - 6)
            
        if string.match(barKey, "^Rep_%d+$") then
            layout:button("DeleteBtn_" .. barKey, locales["DELETE"] or "Delete", 80, 24, col3X, function()
                profile.bars[barKey] = nil
                ascensionBars:removeDynamicBar(barKey)
                ascensionBars:updateDisplay()
                if panel.updateLayout then panel:updateLayout() end
            end)
        end

        layout.y = row1Y
        layout:checkbox("UseCustomHeightCheckbox_" .. barKey, locales["USE_CUSTOM_HEIGHT"], nil,
            function() return bar.useCustomHeight end,
            function(v) 
                bar.useCustomHeight = v 
                ascensionBars:updateDisplay()
                if panel.updateLayout then panel:updateLayout() end 
            end, col2X - 6)
            
        layout.y = row2Y
        layout:dropdown("AnchorDropdown_" .. barKey, locales["ANCHOR"],
            {{label=locales["TOP"], value="TOP"}, {label=locales["BOTTOM"], value="BOTTOM"}, {label=locales["FREE"], value="FREE"}},
            function() return bar.block end,
            function(v)
                local old = bar.block; bar.block = v
                addonTable.configUtils:cleanOrders(profile, "block", "order", old)
                bar.order = math.max(1, addonTable.configUtils:getCount(profile, "block", v))
                
                -- LIMPIADOR DE GRID: Si la barra se va de un bloque con Grid activo, la quitamos de su cuadrícula.
                if profile.customGrids and profile.customGrids[old] and profile.customGrids[old].assignments then
                    for r, row in pairs(profile.customGrids[old].assignments) do
                        for c, assignedBar in pairs(row) do
                            if assignedBar == barKey then
                                profile.customGrids[old].assignments[r][c] = "none"
                            end
                        end
                    end
                end

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
        
        if bar.useCustomHeight then
            layout.y = row3Y
            layout:slider("CustomHeightSlider_" .. barKey, locales["CUSTOM_HEIGHT"], 1, 50, 1,
                function() return bar.customHeight or 10 end,
                function(v) bar.customHeight = v; ascensionBars:updateDisplay() end, internalWidth, col1X)
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
    
    -- BAR MANAGEMENT SECTION
    mainLayout:header("BarManagementHeader", locales["BAR_MANAGEMENT"])

    mainLayout:checkbox("PerBlockHeightToggle", locales["USE_PER_BLOCK_HEIGHT"], nil,
        function() return profile.usePerBlockHeights end,
        function(v)
            profile.usePerBlockHeights = v
            ascensionBars:updateDisplay()
            if panel.updateLayout then _G.C_Timer.After(0.01, function() panel:updateLayout() end) end
        end, 15)

    local barStartY = mainLayout.y

    local function getBarListKeys()
        local keys = { "XP", "Rep", "Honor", "HouseXp", "Azerite" }
        local names = { locales["EXPERIENCE"], locales["REPUTATION"], locales["HONOR"], locales["HOUSE_FAVOR"], locales["AZERITE"] }
        
        -- Custom Reputations
        if profile and profile.bars then
            for k, cfg in pairs(profile.bars) do
                if string.match(k, "^Rep_%d+$") then
                    table.insert(keys, k)
                    table.insert(names, cfg.name or (locales["REPUTATION"] .. " (" .. string.match(k, "%d+") .. ")"))
                end
            end
        end
        return keys, names
    end

    local barKeys, barNames = getBarListKeys()
    local twoColWidth = (defaultAvailableSpace - colGap) / 2
    local blocks = {
        { name = locales["TOP_BLOCK"],    key = "TOP",    x = 10, width = twoColWidth },
        { name = locales["BOTTOM_BLOCK"], key = "BOTTOM", x = 10 + twoColWidth + colGap, width = twoColWidth }
    }

    -- Determine starting Y for the bar section and a variable to track the deepest point reached
    local deepestY = barStartY

    for _, block in ipairs(blocks) do        
        -- Reset layout start to barStartY for each column to keep them parallel
        local layoutCol = addonTable.layoutModel:new(content, barStartY)
        
        local header = content:CreateFontString(nil, "OVERLAY", menuStyle.labelFont)
        header:SetPoint("TOPLEFT", block.x, barStartY)
        header:SetWidth(block.width)
        header:SetJustifyH("CENTER")
        header:SetText(block.name)
        
        local fontPath, _, outline = header:GetFont()
        header:SetFont(fontPath, 20, outline)
        header:SetTextColor(0.64, 0.21, 0.93) -- #A335EE
        
        layoutCol.y = barStartY - 35

        -- Block Height Settings
        if profile.usePerBlockHeights then
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
        end
        
        -- Filter and sort bars belonging to this block
        local sortedBars = {}
        for i, key in ipairs(barKeys) do
            local barData = profile.bars[key]
            if barData and (barData.block or "TOP") == block.key then
                table.insert(sortedBars, { key = key, name = barNames[i] })
            end
        end
        
        table.sort(sortedBars, function(a, b) 
            return (profile.bars[a.key].order or 0) < (profile.bars[b.key].order or 0) 
        end)
        
        -- Render bar controls
        for _, bar in ipairs(sortedBars) do
            self:createBarControls(layoutCol, profile, bar.key, bar.name, panel, block.width, block.x)
        end
        
        -- Track the lowest point across all columns
        if layoutCol.y < deepestY then
            deepestY = layoutCol.y
        end
    end

    -- SECTION: FREE MODE INITIALIZATION
    -- Positioned relative to deepestY to prevent overlap with parallel columns
    local freeStartY = deepestY
    local layoutFree = addonTable.layoutModel:new(content, freeStartY)
    
    local freeHeader = content:CreateFontString(nil, "OVERLAY", menuStyle.labelFont)
    freeHeader:SetPoint("TOPLEFT", 10, freeStartY)
    freeHeader:SetWidth(defaultAvailableSpace)
    freeHeader:SetJustifyH("CENTER")
    freeHeader:SetText(locales["FREE_MODE"] or "Free Mode")
    
    -- Visual styles following Ascension suite standards
    local fontPath, _, fontOutline = freeHeader:GetFont()
    freeHeader:SetFont(fontPath, 22, fontOutline)
    freeHeader:SetTextColor(0.64, 0.21, 0.93) -- #A335EE
    
    -- Setting the Y offset for the first controls in Free Mode
    layoutFree.y = freeStartY - 50

    -- Iterate through bar keys to find those assigned to the "FREE" block
    for i, key in ipairs(barKeys) do
        local barData = profile.bars[key]
        -- Nil check and block validation for runtime safety
        if barData and barData.block == "FREE" then
            self:createBarControls(layoutFree, profile, key, barNames[i], panel, defaultAvailableSpace, 10)
        end
    end

    -- Final Height calculation for the Scroll Content
    -- math.abs is used because layoutFree.y is a negative offset from the top
    content:SetHeight(math.abs(layoutFree.y) + 60)
end