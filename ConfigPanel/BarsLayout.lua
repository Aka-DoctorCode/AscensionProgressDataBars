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
local locales = _G.LibStub("AceLocale-3.0"):GetLocale("AscensionBars")

-- Use the shared utilities that will be defined in our main ConfigMain.lua
local colors = ascensionBars.colors
local menuStyle = ascensionBars.menuStyle

-- Object-Oriented module for the Bars Layout Tab
addonTable.barsLayoutTab = {}
local barsLayoutTab = addonTable.barsLayoutTab

-------------------------------------------------------------------------------
-- HELPER FUNCTIONS
-------------------------------------------------------------------------------

-- Creates a visual interactive cell for the custom grid
function barsLayoutTab:createVisualCell(parentFrame, cellKey, cellWidth, cellHeight, xPos, yPos, currentAssignment, barNamesMap, barOptions, onSelectCallback)
    if not parentFrame then return nil end
    
    local cellButton = _G.CreateFrame("Button", "VisualCell_" .. cellKey, parentFrame)
    cellButton:SetSize(cellWidth, cellHeight)
    cellButton:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", xPos, yPos)
    
    -- Background texture
    local bg = cellButton:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    cellButton.bg = bg
    
    -- Border texture
    local border = cellButton:CreateTexture(nil, "BORDER")
    border:SetAllPoints()
    -- #4D4D4D (Dark Gray Border)
    border:SetColorTexture(0.3, 0.3, 0.3, 1)
    cellButton.border = border
    
    -- Inner background to create a border effect
    local innerBg = cellButton:CreateTexture(nil, "ARTWORK")
    innerBg:SetPoint("TOPLEFT", cellButton, "TOPLEFT", 1, -1)
    innerBg:SetPoint("BOTTOMRIGHT", cellButton, "BOTTOMRIGHT", -1, 1)
    cellButton.innerBg = innerBg
    
    local label = cellButton:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    label:SetPoint("CENTER", cellButton, "CENTER", 0, 0)
    
    -- Apply styles based on assignment status
    if currentAssignment == "none" or not currentAssignment then
        -- #1A1A1A (Very Dark Gray)
        innerBg:SetColorTexture(0.1, 0.1, 0.1, 0.8) 
        label:SetText("+ " .. (locales["EMPTY"] or "Empty"))
        label:SetTextColor(0.5, 0.5, 0.5)
    else
        -- #A335EE (Purple with 50% opacity)
        innerBg:SetColorTexture(0.64, 0.21, 0.93, 0.5) 
        
        local displayName = barNamesMap[currentAssignment] or currentAssignment
        label:SetText(displayName)
        label:SetTextColor(1, 1, 1)
    end
    
    -- Hover effects
    cellButton:SetScript("OnEnter", function(self)
        -- #FFFFFF (White border on hover)
        self.border:SetColorTexture(1, 1, 1, 1) 
    end)
    
    cellButton:SetScript("OnLeave", function(self)
        if currentAssignment == "none" or not currentAssignment then
            -- #4D4D4D
            self.border:SetColorTexture(0.3, 0.3, 0.3, 1)
        else
            -- #FFD100 (Gold border for active cells)
            self.border:SetColorTexture(1.0, 0.82, 0.0, 1) 
        end
    end)
    
    -- Click to open MenuUtil context menu (WoW 12.0.0 API)
    cellButton:SetScript("OnClick", function(self)
        if _G.MenuUtil and _G.MenuUtil.CreateContextMenu then
            _G.MenuUtil.CreateContextMenu(self, function(owner, rootDescription)
                rootDescription:CreateTitle(locales["ASSIGN_BAR"] or "Assign Bar")
                
                rootDescription:CreateButton(locales["NONE"] or "None", function()
                    if onSelectCallback then onSelectCallback("none") end
                end)
                
                for _, opt in ipairs(barOptions) do
                    rootDescription:CreateButton(opt.label, function()
                        if onSelectCallback then onSelectCallback(opt.value) end
                    end)
                end
            end)
        end
    end)
    
    return cellButton
end

-- Applies predefined grid layouts to minimize user friction
local function applyGridPreset(grid, presetValue)
    if not grid or presetValue == "CUSTOM" then return end
    
    if presetValue == "2X1" then
        grid.numRows = 2
        grid.colsPerRow = {1, 1}
        grid.assignments = { {"XP"}, {"Rep"} }
    elseif presetValue == "2X2" then
        grid.numRows = 2
        grid.colsPerRow = {2, 2}
        grid.assignments = { {"XP", "Rep"}, {"Honor", "Azerite"} }
    elseif presetValue == "3X2" then
        grid.numRows = 3
        grid.colsPerRow = {2, 2, 2}
        grid.assignments = { {"XP", "Rep"}, {"Honor", "Azerite"}, {"HouseXp", "none"} }
    end
end

-------------------------------------------------------------------------------
-- CORE LAYOUT BUILDER
-------------------------------------------------------------------------------

function barsLayoutTab:createBarControls(layout, profile, barKey, displayName, panel, controlWidth, xOffset)
    if not profile or not profile.bars or not profile.bars[barKey] then return end
    local bar = profile.bars[barKey]

    layout:beginSection(xOffset, controlWidth)
    
    -- Card Title
    layout:label("BarHeader_" .. barKey, displayName, xOffset + 5, colors.gold)
    
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
        return { "XP", "Rep", "Honor", "HouseXp", "Azerite" },
               { locales["EXPERIENCE"], locales["REPUTATION"], locales["HONOR"], locales["HOUSE_FAVOR"], locales["AZERITE"] }
    end

    local barKeys, barNames = getBarListKeys()
    local barNamesMap = {}
    for i, key in ipairs(barKeys) do
        barNamesMap[key] = barNames[i]
    end
    
    local twoColWidth = (defaultAvailableSpace - colGap) / 2
    local blocks = {
        { name = locales["TOP_BLOCK"],    key = "TOP",    x = 10, width = twoColWidth },
        { name = locales["BOTTOM_BLOCK"], key = "BOTTOM", x = 10 + twoColWidth + colGap, width = twoColWidth }
    }

    local maxHeaderY = barStartY

    for _, block in ipairs(blocks) do
        profile.customGrids = profile.customGrids or {}
        profile.customGrids[block.key] = profile.customGrids[block.key] or { enabled = false, preset = "CUSTOM", numRows = 1, colsPerRow = {1}, assignments = {{ "none" }} }
        local grid = profile.customGrids[block.key]
        
        local layoutCol = addonTable.layoutModel:new(content, barStartY)
        local header = content:CreateFontString(nil, "OVERLAY", menuStyle.labelFont)
        header:SetPoint("TOPLEFT", block.x, barStartY)
        header:SetWidth(block.width)
        header:SetJustifyH("CENTER")
        header:SetText(block.name)
        
        local fontPath, _, outline = header:GetFont()
        header:SetFont(fontPath, 20, outline)
        -- #A335EE
        header:SetTextColor(0.64, 0.21, 0.93)
        
        layoutCol.y = barStartY - 30
        
        layoutCol:checkbox("GridToggle_" .. block.key, locales["CUSTOM_GRID_ENABLE"] or "Enable Custom Grid", locales["CUSTOM_GRID_DESC"] or "",
            function() return grid.enabled end,
            function(v) 
                grid.enabled = v 
                ascensionBars:updateDisplay()
                if panel.updateLayout then panel:updateLayout() end
            end, block.x + 5)
            
        layoutCol.y = layoutCol.y - 15

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
        end
        
        layoutCol.y = layoutCol.y - 10
        if layoutCol.y < maxHeaderY then maxHeaderY = layoutCol.y end
    end
    
    local currentY = maxHeaderY - 10
    local isTwoColActive = false
    local twoColMaxY = currentY
    
    for _, block in ipairs(blocks) do
        local grid = profile.customGrids[block.key]
        local isGrid = grid.enabled
        local blockX, blockWidth
        
        if isGrid then
            if isTwoColActive then
                currentY = twoColMaxY - 20
                isTwoColActive = false
            end
            blockX = 10
            blockWidth = defaultAvailableSpace
        else
            if not isTwoColActive then
                isTwoColActive = true
                blockX = 10
                blockWidth = twoColWidth
                twoColMaxY = currentY
            else
                blockX = 10 + twoColWidth + colGap
                blockWidth = twoColWidth
            end
        end
        
        local layoutCol = addonTable.layoutModel:new(content, currentY)
        
        if isGrid then
            layoutCol:label("GridOptsHeader_"..block.key, locales["GRID_OPTIONS"] or "Grid Configuration", blockX + 5, colors.gold)
            layoutCol.y = layoutCol.y - 5
            
            -- Preset Selector
            local presetOptions = {
                { label = locales["PRESET_CUSTOM"] or "Custom", value = "CUSTOM" },
                { label = locales["PRESET_2X1"] or "2x1 (2 Rows, 1 Col)", value = "2X1" },
                { label = locales["PRESET_2X2"] or "2x2 (2 Rows, 2 Cols)", value = "2X2" },
                { label = locales["PRESET_3X2"] or "3x2 (3 Rows, 2 Cols)", value = "3X2" }
            }
            
            layoutCol:dropdown("GridPreset_"..block.key, locales["GRID_PRESET"] or "Layout Preset", presetOptions,
                function() return grid.preset or "CUSTOM" end,
                function(v)
                    grid.preset = v
                    applyGridPreset(grid, v)
                    ascensionBars:updateDisplay()
                    if panel.updateLayout then panel:updateLayout() end
                end, blockWidth/2 - 5, blockX + 5)
            
            layoutCol.y = layoutCol.y - 10
            
            -- Only show Steppers if using Custom mode
            if grid.preset == "CUSTOM" then
                layoutCol:stepper("GridRows_"..block.key, locales["GRID_ROWS"] or "Rows", 1, 7, 1,
                    function() return grid.numRows or 1 end,
                    function(v) 
                        grid.numRows = v
                        grid.colsPerRow = grid.colsPerRow or {}
                        grid.assignments = grid.assignments or {}
                        for r=1, v do
                            grid.colsPerRow[r] = grid.colsPerRow[r] or 1
                            grid.assignments[r] = grid.assignments[r] or { "none" }
                        end
                        ascensionBars:updateDisplay()
                        if panel.updateLayout then panel:updateLayout() end
                    end, blockWidth/2 - 5, blockX + 5)
                
                layoutCol.y = layoutCol.y - 10
                local rowStartY = layoutCol.y
                local maxDescentY = rowStartY
                
                for r = 1, grid.numRows do
                    local sW = (blockWidth/3) - 10
                    local sX = blockX + 5 + ((r-1)%3) * (blockWidth/3)
                    
                    layoutCol.y = rowStartY
                    layoutCol:stepper("GridCols_"..block.key.."_"..r, string.format(locales["GRID_COLS_FOR_ROW"] or "Cols R%d", r), 1, 5, 1,
                        function() return grid.colsPerRow[r] or 1 end,
                        function(v)
                            grid.colsPerRow[r] = v
                            grid.assignments[r] = grid.assignments[r] or {}
                            for c=1, v do
                                grid.assignments[r][c] = grid.assignments[r][c] or "none"
                            end
                            ascensionBars:updateDisplay()
                            if panel.updateLayout then panel:updateLayout() end
                        end, sW, sX)
                    
                    if layoutCol.y < maxDescentY then
                        maxDescentY = layoutCol.y
                    end
                    
                    if r % 3 == 0 or r == grid.numRows then
                        rowStartY = maxDescentY
                        layoutCol.y = rowStartY
                    end
                end
                
                layoutCol.y = layoutCol.y - 10
            end -- End of Custom Steppers
            
            -- Prepare valid assignments for this block
            local validBarOptions = {}
            for i, bKey in ipairs(barKeys) do
                local bConf = profile.bars[bKey]
                if bConf and (bConf.block or "TOP") == block.key then
                    table.insert(validBarOptions, {label = barNames[i], value = bKey})
                end
            end
            
            -- Draw the Visual Grid Canvas
            grid.assignments = grid.assignments or {}
            local cellHeight = 35
            
            for r = 1, grid.numRows do
                local cols = grid.colsPerRow[r] or 1
                local cellWidth = blockWidth / cols
                local rowStartY = layoutCol.y
                
                grid.assignments[r] = grid.assignments[r] or {}

                for c = 1, cols do
                    local cellX = blockX + (c-1)*cellWidth
                    local currentAssig = grid.assignments[r][c] or "none"
                    
                    self:createVisualCell(content, block.key.."_"..r.."_"..c, cellWidth - 10, cellHeight, cellX, rowStartY, currentAssig, barNamesMap, validBarOptions, function(selectedValue)
                        -- Swap logic: If the selected bar is already in another cell, clear that cell
                        if selectedValue ~= "none" then
                            for scanR = 1, grid.numRows do
                                local scanCols = grid.colsPerRow[scanR] or 1
                                for scanC = 1, scanCols do
                                    if grid.assignments[scanR] and grid.assignments[scanR][scanC] == selectedValue then
                                        grid.assignments[scanR][scanC] = grid.assignments[r][c] or "none"
                                    end
                                end
                            end
                        end
                        grid.assignments[r][c] = selectedValue
                        ascensionBars:updateDisplay()
                        if panel.updateLayout then panel:updateLayout() end
                    end)
                end
                layoutCol.y = layoutCol.y - cellHeight - 5
            end
            
            layoutCol.y = layoutCol.y - 10
            layoutCol:label("GridSubToggleHeader_"..block.key, locales["ENABLE"] or "Enable", blockX + 5, colors.gold)
            layoutCol.y = layoutCol.y - 5
            
            local toggleStartY = layoutCol.y
            local maxTglDescentY = toggleStartY
            local toggleCount = 0
            
            for i, bKey in ipairs(barKeys) do
                local bConf = profile.bars[bKey]
                if bConf and (bConf.block or "TOP") == block.key then
                    toggleCount = toggleCount + 1
                    
                    local tW = (blockWidth/3) - 10
                    local tX = blockX + 5 + ((toggleCount-1)%3) * (blockWidth/3)
                    
                    layoutCol.y = toggleStartY
                    layoutCol:checkbox("GridBarEn_"..bKey, barNames[i], nil,
                        function() return profile.bars[bKey].enabled end,
                        function(v) 
                            profile.bars[bKey].enabled = v
                            ascensionBars:updateDisplay()
                        end, tX)
                        
                    if layoutCol.y < maxTglDescentY then
                        maxTglDescentY = layoutCol.y
                    end
                    
                    if toggleCount % 3 == 0 then
                        toggleStartY = maxTglDescentY
                        layoutCol.y = toggleStartY
                    end
                end
            end
            
            if toggleCount % 3 ~= 0 then
                layoutCol.y = maxTglDescentY
            end
            
            currentY = layoutCol.y - 10
        else
            local sorted = {}
            for i, key in ipairs(barKeys) do
                if profile.bars[key] and (profile.bars[key].block or "TOP") == block.key then
                    table.insert(sorted, { key = key, name = barNames[i] })
                end
            end
            table.sort(sorted, function(a, b) return (profile.bars[a.key].order or 0) < (profile.bars[b.key].order or 0) end)
            
            for _, bar in ipairs(sorted) do
                self:createBarControls(layoutCol, profile, bar.key, bar.name, panel, blockWidth, blockX)
            end
            
            if layoutCol.y < twoColMaxY then twoColMaxY = layoutCol.y end
        end
    end
    
    if isTwoColActive then
        currentY = twoColMaxY - 20
    end
    
    local maxRowY = currentY

    -- FREE MODE SECTION
    local freeStartY = maxRowY - 10
    local layoutFree = addonTable.layoutModel:new(content, freeStartY)
    local freeHeader = content:CreateFontString(nil, "OVERLAY", menuStyle.labelFont)
    freeHeader:SetPoint("TOPLEFT", 10, freeStartY)
    freeHeader:SetWidth(defaultAvailableSpace)
    freeHeader:SetJustifyH("CENTER")
    freeHeader:SetText(locales["FREE_MODE"] or "Free Mode")
    
    local fFont, _, fOutline = freeHeader:GetFont()
    freeHeader:SetFont(fFont, 20, fOutline)
    -- #A335EE
    freeHeader:SetTextColor(0.64, 0.21, 0.93)
    
    layoutFree.y = freeStartY - 40
    for i, key in ipairs(barKeys) do
        if (profile.bars[key] and profile.bars[key].block == "FREE") then
            self:createBarControls(layoutFree, profile, key, barNames[i], panel, defaultAvailableSpace, 10)
        end
    end

    content:SetHeight(math.abs(layoutFree.y) + 50)
end