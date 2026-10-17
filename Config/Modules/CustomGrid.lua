-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
-- Author: Aka-DoctorCode
-- File: CustomGrid.lua
-------------------------------------------------------------------------------
---@diagnostic disable: undefined-global, undefined-field, inject-field

local addonName, addonTable = ...
local ascensionBars = addonTable.main or _G.LibStub("AceAddon-3.0"):GetAddon(addonName)
local locales = _G.LibStub("AceLocale-3.0"):GetLocale("AscensionProgressDataBars")
local colors = setmetatable({}, { __index = function(t, k) return ascensionBars.colors and ascensionBars.colors[k] end })
local menuStyle = setmetatable({}, { __index = function(t, k) return ascensionBars.menuStyle and ascensionBars.menuStyle[k] end })

addonTable.customGridTab = addonTable.customGridTab or {}
local customGridTab = addonTable.customGridTab

-- Local state for reputation search (avoid polluting ascensionBars)
customGridTab.searchFactionText = customGridTab.searchFactionText or ""
customGridTab.selectedFactionToAdd = customGridTab.selectedFactionToAdd or 0
customGridTab.factionCache = customGridTab.factionCache or {}

-------------------------------------------------------------------------------
-- VISUAL CELL (for grid assignments)
-------------------------------------------------------------------------------
function customGridTab:createVisualCell(parentFrame, cellKey, cellWidth, cellHeight, xPos, yPos, currentAssignment, barNamesMap, barOptions, onSelectCallback)
    if not parentFrame then return nil end

    local frameName = "AscensionBarsVisualCell_" .. cellKey
    local cellButton = _G[frameName]

    -- Solo creamos el frame y sus texturas hijas si no existía antes
    if not cellButton then
        cellButton = _G.CreateFrame("Button", frameName, parentFrame)

        local bg = cellButton:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints()
        cellButton.bg = bg

        local border = cellButton:CreateTexture(nil, "BORDER")
        border:SetAllPoints()
        cellButton.border = border

        local innerBg = cellButton:CreateTexture(nil, "ARTWORK")
        innerBg:SetPoint("TOPLEFT", cellButton, "TOPLEFT", 1, -1)
        innerBg:SetPoint("BOTTOMRIGHT", cellButton, "BOTTOMRIGHT", -1, 1)
        cellButton.innerBg = innerBg

        local label = cellButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        label:SetWordWrap(false)
        cellButton.label = label

        cellButton:SetScript("OnEnter", function(self)
            self.border:SetColorTexture(_G.unpack(colors.surfaceLight))
        end)
        cellButton:SetScript("OnLeave", function(self)
            self.border:SetColorTexture(_G.unpack(colors.blackDetail))
        end)
    end

    -- Actualizamos siempre el frame reciclado/nuevo para que aparezca en la UI correcta
    cellButton:SetParent(parentFrame)
    cellButton:Show()
    cellButton:ClearAllPoints()
    cellButton:SetSize(cellWidth, cellHeight)
    cellButton:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", xPos, yPos)

    cellButton.border:SetColorTexture(_G.unpack(colors.blackDetail))
    cellButton.label:ClearAllPoints()
    cellButton.label:SetPoint("CENTER", cellButton, "CENTER", 0, 0)
    cellButton.label:SetWidth(cellWidth - menuStyle.contentPadding)

    if currentAssignment == "none" or not currentAssignment then
        cellButton.innerBg:SetColorTexture(_G.unpack(colors.surfaceDark))
        cellButton.label:SetText("+ " .. (locales["EMPTY"] or "Empty"))
        cellButton.label:SetTextColor(_G.unpack(colors.textLight or {0.6, 0.6, 0.6, 1}))
    else
        cellButton.innerBg:SetColorTexture(_G.unpack(colors.primary))
        cellButton.innerBg:SetAlpha(0.5)
        local displayName = (barNamesMap and barNamesMap[currentAssignment]) and barNamesMap[currentAssignment] or currentAssignment
        cellButton.label:SetText(displayName)
        cellButton.label:SetTextColor(_G.unpack(colors.textLight))
    end

    -- Re-bind the click behavior with updated callback
    cellButton:SetScript("OnClick", function(self)
        if _G.MenuUtil and _G.MenuUtil.CreateContextMenu then
            _G.MenuUtil.CreateContextMenu(self, function(owner, rootDesc)
                rootDesc:CreateTitle(locales["ASSIGN_BAR"] or "Assign Bar")
                rootDesc:CreateButton(locales["NONE"] or "None", function()
                    if onSelectCallback then onSelectCallback("none") end
                end)
                for _, opt in _G.ipairs(barOptions) do
                    rootDesc:CreateButton(opt.label, function()
                        if onSelectCallback then onSelectCallback(opt.value) end
                    end)
                end
            end)
        end
    end)

    cellButton.currentAssignment = currentAssignment
    return cellButton
end

-------------------------------------------------------------------------------
-- PRESET APPLY FUNCTION
-------------------------------------------------------------------------------
local function applyPresetToGrid(grid, presetValue)
    if not grid or presetValue == "CUSTOM" then return end
    if presetValue == "2X1" then
        grid.numRows = 2
        grid.colsPerRow = { 1, 1 }
        grid.assignments = { { "XP" }, { "Rep" } }
    elseif presetValue == "2X2" then
        grid.numRows = 2
        grid.colsPerRow = { 2, 2 }
        grid.assignments = { { "XP", "Rep" }, { "Honor", "Azerite" } }
    elseif presetValue == "3X2" then
        grid.numRows = 3
        grid.colsPerRow = { 2, 2, 2 }
        grid.assignments = { { "XP", "Rep" }, { "Honor", "Azerite" }, { "HouseXp", "none" } }
    end
end

-------------------------------------------------------------------------------
-- HELPER: Build preset controls for a grid block
-------------------------------------------------------------------------------
local function buildPresetControls(panel, blockKey, grid, blockX, blockWidth, layoutCol)
    local presetOptions = {
        { label = locales["PRESET_CUSTOM"] or "Custom",            value = "CUSTOM" },
        { label = locales["PRESET_2X1"] or "2x1 (2 Rows, 1 Col)",  value = "2X1" },
        { label = locales["PRESET_2X2"] or "2x2 (2 Rows, 2 Cols)", value = "2X2" },
        { label = locales["PRESET_3X2"] or "3x2 (3 Rows, 2 Cols)", value = "3X2" }
    }

    local presetRowY = layoutCol.y
    layoutCol:dropdown("GridPreset_" .. blockKey, locales["GRID_PRESET"] or "Layout Preset", presetOptions,
        function() return grid.preset or "CUSTOM" end,
        function(v)
            grid.preset = v
            applyPresetToGrid(grid, v)
            ascensionBars:updateDisplay()
            if panel.updateLayout then panel:updateLayout() end
        end, blockWidth / 2 - 10, blockX + menuStyle.contentPadding / 2)

    local afterDropdownY = layoutCol.y

    if grid.preset == "CUSTOM" then
        layoutCol.y = presetRowY + 3 -- Nudge up for alignment with dropdown
        local rightColX = blockX + menuStyle.contentPadding / 2 + (blockWidth / 2)

        layoutCol:stepper("GridRows_" .. blockKey, locales["GRID_ROWS"] or "Rows", 1, 7, 1,
            function() return grid.numRows or 1 end,
            function(v)
                grid.numRows = v
                grid.colsPerRow = grid.colsPerRow or {}
                grid.assignments = grid.assignments or {}
                for r = 1, v do
                    grid.colsPerRow[r] = grid.colsPerRow[r] or 1
                    grid.assignments[r] = grid.assignments[r] or { "none" }
                end
                ascensionBars:updateDisplay()
                if panel.updateLayout then panel:updateLayout() end
            end, blockWidth / 2 - 10, rightColX)

        layoutCol.y = math.min(afterDropdownY, layoutCol.y)
    else
        layoutCol.y = afterDropdownY
    end
end

-------------------------------------------------------------------------------
-- HELPER: Build the actual cell grid for a block
-------------------------------------------------------------------------------
local function buildCellGrid(panel, blockKey, grid, blockX, blockWidth, barKeys, barNames, barNamesMap, layoutCol)
    local validBarOptions = {}
    for i, bKey in _G.ipairs(barKeys) do
        _G.table.insert(validBarOptions, { label = barNames[i], value = bKey })
    end

    local cellHeight = 35
    local stepperWidth = 100 
    local horizontalGap = 10 
    local rowSpacing = 40    -- Sufficient to prevent overlap of 35px cells
    local startY = layoutCol.y

    for r = 1, grid.numRows do
        local rowTopY = startY
        
        -- 1. Stepper: Manually reset cursor to ignore internal factory labels
        layoutCol.y = rowTopY
        layoutCol:stepper("GridCols_" .. blockKey .. "_" .. r, "", 1, 4, 1,
            function() return grid.colsPerRow[r] or 1 end,
            function(v)
                grid.colsPerRow[r] = v
                grid.assignments[r] = grid.assignments[r] or {}
                for c = 1, v do grid.assignments[r][c] = grid.assignments[r][c] or "none" end
                ascensionBars:updateDisplay()
                if panel and panel.updateLayout then panel:updateLayout() end
            end, stepperWidth, blockX)

        -- 2. Visual Cells: Mathematically aligned center-to-center with stepper
        -- Stepper center is at rowTopY - 22. Cell (35px) center is cellVisualY - 17.5.
        -- Aligning both centers results in cellVisualY = rowTopY - 4.5
        local cellVisualY = rowTopY - 4.5 
        local cols = grid.colsPerRow[r] or 1
        local availableWidth = blockWidth - stepperWidth - horizontalGap
        local cellWidth = availableWidth / cols
        grid.assignments[r] = grid.assignments[r] or {}

        for c = 1, cols do
            local cellX = blockX + stepperWidth + horizontalGap + (c - 1) * cellWidth
            local currentAssig = grid.assignments[r][c] or "none"
            
            customGridTab:createVisualCell(panel.content, blockKey .. "_" .. r .. "_" .. c,
                cellWidth - 4, cellHeight,
                cellX, cellVisualY,
                currentAssig, barNamesMap, validBarOptions,
                function(selectedValue)
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
                    if panel and panel.updateLayout then panel:updateLayout() end

                    -- Refresh Bars Layout if initialized to show/hide cards immediately
                    if ascensionBars.configTabs and ascensionBars.configTabs.panels and ascensionBars.configTabs.panels[1] then
                        local barsPanel = ascensionBars.configTabs.panels[1]
                        if barsPanel.updateLayout then barsPanel:updateLayout() end
                    end
                end)
        end
        
        -- Advance to next row position
        startY = startY - rowSpacing
    end

    -- Update layout model Y for subsequent elements (like toggles)
    layoutCol.y = startY - 10
end

-------------------------------------------------------------------------------
-- HELPER: Build toggle list for bars in a block
-------------------------------------------------------------------------------
local function buildBarToggles(panel, blockKey, barKeys, barNames, blockX, blockWidth, layoutCol)
    layoutCol:label("GridSubToggleHeader_" .. blockKey, locales["ENABLE"] or "Enable", blockX + menuStyle.contentPadding / 2, colors.gold) -- #FFD100
    layoutCol.y = layoutCol.y - menuStyle.labelSpacing / 2

    local toggleStartY = layoutCol.y
    local maxTglDescentY = toggleStartY
    local toggleCount = 0

    for i, bKey in _G.ipairs(barKeys) do
        local bConf = ascensionBars.db.profile.bars[bKey]
        if bConf and (bConf.block or "TOP") == blockKey then
            toggleCount = toggleCount + 1
            local tX = blockX + menuStyle.contentPadding / 2 + ((toggleCount - 1) % 3) * (blockWidth / 3)

            layoutCol.y = toggleStartY
            layoutCol:checkbox("GridBarEn_" .. bKey, barNames[i], nil,
                function() return ascensionBars.db.profile.bars[bKey].enabled end,
                function(v)
                    ascensionBars.db.profile.bars[bKey].enabled = v
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
end

-------------------------------------------------------------------------------
-- HELPER: Build a single grid block (TOP or BOTTOM)
-------------------------------------------------------------------------------
local function buildGridBlock(panel, blockKey, blockName, startY, availableWidth)
    local profile = ascensionBars.db.profile
    profile.customGrids = profile.customGrids or {}
    profile.customGrids[blockKey] = profile.customGrids[blockKey] or {
        enabled = false,
        preset = "2X2",
        numRows = 2,
        colsPerRow = { 2, 2 },
        assignments = { { "XP", "Rep" }, { "Honor", "" } }
    }
    local grid = profile.customGrids[blockKey]

    local layoutCol = addonTable.layoutModel:new(nil, panel.content, startY)

    -- Block header
    local header = panel.content:CreateFontString(nil, "OVERLAY", menuStyle.headerFont)
    header:SetPoint("TOPLEFT", menuStyle.contentPadding, startY)
    header:SetJustifyH("LEFT")
    header:SetText(blockName)
    header:SetTextColor(_G.unpack(colors.gold))

    -- Enable checkbox (aligned horizontally with header)
    local toggle, nextY = layoutCol:checkbox("GridToggle_" .. blockKey, locales["CUSTOM_GRID_ENABLE"] or "Enable Custom Grid Layout",
        locales["ENABLE_ADVANCED_GRID_DESC"] or "",
        function() return grid.enabled end,
        function(v)
            grid.enabled = v
            if v and grid.preset == "CUSTOM" and grid.numRows == 1 then
                grid.preset = "2X2"
                applyPresetToGrid(grid, "2X2")
            end
            ascensionBars:updateDisplay()
            if panel and panel.updateLayout then panel:updateLayout() end
            
            -- Refresh Bars Layout if initialized
            if ascensionBars.configTabs and ascensionBars.configTabs.panels and ascensionBars.configTabs.panels[1] then
                local barsPanel = ascensionBars.configTabs.panels[1]
                if barsPanel.updateLayout then barsPanel:updateLayout() end
            end
        end, 0)

    toggle:ClearAllPoints()
    toggle:SetPoint("LEFT", header, "LEFT", 180, 2)
    
    -- Ensure layout.y starts after this combined row with a tight 3px gap
    layoutCol.y = math.min(startY - 28, layoutCol.y) - 3

    if grid.enabled then
        buildPresetControls(panel, blockKey, grid, menuStyle.contentPadding, availableWidth, layoutCol)
        
        -- Counter-act factory padding to keep grid close to presets
        layoutCol.y = layoutCol.y + 6 

        local barKeys, barNames, barNamesMap = {}, {}, {}
        for k, cfg in _G.pairs(profile.bars) do
            if (cfg.block or "TOP") == blockKey then
                _G.table.insert(barKeys, k)
                local name = cfg.name or k
                _G.table.insert(barNames, name)
                barNamesMap[k] = name
            end
        end

        buildCellGrid(panel, blockKey, grid, menuStyle.contentPadding, availableWidth, barKeys, barNames, barNamesMap, layoutCol)

        -- Compact spacing before toggles
        layoutCol.y = layoutCol.y - 4

        -- Bar individual visibility toggles
        buildBarToggles(panel, blockKey, barKeys, barNames, menuStyle.contentPadding, availableWidth, layoutCol)
    end

    return layoutCol.y
end

-------------------------------------------------------------------------------
-- HELPER: Update faction cache from game data
-------------------------------------------------------------------------------
local function updateFactionCache()
    local globalCache = customGridTab.factionCache
    local currentExpansionName = ""

    if _G.C_Reputation and _G.C_Reputation.GetNumFactions then
        local numFactions = _G.C_Reputation.GetNumFactions()
        for i = 1, numFactions do
            local fData = _G.C_Reputation.GetFactionDataByIndex(i)
            if fData and fData.factionID and fData.name then
                if fData.isHeader then
                    currentExpansionName = fData.name
                end
                if not (fData.isHeader and not fData.isHeaderWithRep) and not (fData.isHidden or fData.isForcedHidden) then
                    globalCache[fData.factionID] = {
                        name = fData.name,
                        expName = currentExpansionName,
                        isAccountWide = fData.isAccountWide or false
                    }
                end
            end
        end
    end
end

-------------------------------------------------------------------------------
-- HELPER: Build reputation management section
-------------------------------------------------------------------------------
local function buildReputationSection(panel, startY, availableWidth)
    local profile = ascensionBars.db.profile
    local layoutRep = addonTable.layoutModel:new(nil, panel.content, startY)

    -- Section header
    local repHeader = layoutRep:header("CustomRepHeader", locales["ADD_CUSTOM_REPUTATION"])
    repHeader:SetTextColor(unpack(colors.gold))
    layoutRep.y = layoutRep.y - menuStyle.labelSpacing

    layoutRep:beginSection(menuStyle.contentPadding, availableWidth - menuStyle.contentPadding * 2)
    layoutRep.y = layoutRep.y - 12 -- Equalized top margin

    -- Search row
    local rowY = layoutRep.y
    local marginX = menuStyle.contentPadding + 10 -- Centered horizontally
    local spacing = 10 -- Equal gap between elements
    local searchWidth = 160
    local buttonWidth = 70
    local dropdownWidth = availableWidth - searchWidth - buttonWidth - (spacing * 2) - (marginX * 2)

    -- 1. Input (Search)
    layoutRep.y = rowY
    layoutRep:input("SearchFactionInput", locales["SEARCH_FACTION"] or "Search:", searchWidth, marginX, function(text)
        customGridTab.searchFactionText = text
        _G.C_Timer.After(0.01, function()
            if panel and panel.updateLayout then panel:updateLayout() end
        end)
    end)
    local inputEndY = layoutRep.y

    if not _G.next(customGridTab.factionCache) then
        updateFactionCache()
    end

    -- Filter factions based on search
    local searchStr = (customGridTab.searchFactionText or ""):lower()
    local filteredFactions = {}
    for fID, cachedData in pairs(customGridTab.factionCache) do
        if searchStr == "" or cachedData.name:lower():find(searchStr, 1, true) or cachedData.expName:lower():find(searchStr, 1, true) then
            local displayLabel = cachedData.name
            if #displayLabel > 32 then
                displayLabel = displayLabel:sub(1, 32) .. "..."
            end
            table.insert(filteredFactions, { label = displayLabel, value = fID, sortName = cachedData.name })
        end
    end
    table.sort(filteredFactions, function(a, b) return a.sortName < b.sortName end)
    table.insert(filteredFactions, 1, { label = locales["NONE"] or "None", value = 0 })

    -- 2. Dropdown
    local dropdownX = marginX + searchWidth + spacing
    layoutRep.y = rowY
    layoutRep:dropdown("FactionSelectDropdown", nil, filteredFactions,
        function() return customGridTab.selectedFactionToAdd end,
        function(v) customGridTab.selectedFactionToAdd = v end, dropdownWidth, dropdownX)
    local dropdownEndY = layoutRep.y

    -- 3. Add button
    local buttonX = dropdownX + dropdownWidth + spacing
    layoutRep.y = rowY - 7 -- Corrected vertical alignment
    layoutRep:button("AddFactionBtn", locales["ADD"] or "Add", buttonWidth, 24, buttonX, function()
        local fID = customGridTab.selectedFactionToAdd
        if fID and fID > 0 then
            local key = "Rep_" .. fID
            local nameStr = "Reputation"
            for _, f in ipairs(filteredFactions) do
                if f.value == fID then
                    nameStr = f.label
                    break
                end
            end
            if not profile.bars[key] then
                profile.bars[key] = {
                    enabled = true,
                    block = "TOP",
                    order = addonTable.configUtils:getCount(profile, "block", "TOP") + 1,
                    freeX = 0,
                    freeY = 0,
                    freeWidth = 500,
                    freeHeight = 6,
                    name = nameStr
                }
                ascensionBars:createDynamicBar(key)
                ascensionBars:updateDisplay()
                if panel.updateLayout then panel:updateLayout() end
            end
        end
    end)
    local buttonEndY = layoutRep.y

    -- Finalize layout Y based on deepest element
    layoutRep.y = math.min(inputEndY, math.min(dropdownEndY, buttonEndY)) - 12 -- Equalized bottom margin

    layoutRep:endSection()


    return layoutRep.y
end

-------------------------------------------------------------------------------
-- MAIN BUILD FUNCTION
-------------------------------------------------------------------------------
function customGridTab:build(panel)
    if not panel or not panel.content then return end

    addonTable.configUtils:cleanupContent(panel.content)
    local profile = ascensionBars.db.profile
    if not profile then return end

    -- Default settings
    if profile.customGridMasterEnabled == nil then
        profile.customGridMasterEnabled = false
    end

    local defaultAvailableSpace = (ascensionBars.normalWidth or 850) - (menuStyle.sidebarWidth or 150) - menuStyle.contentPadding * 2
    local layout = addonTable.layoutModel:new(nil, panel.content, -menuStyle.contentPadding)

    -- -------------------------------------------------------------------------------
    -- HEADER SECTION
    -- -------------------------------------------------------------------------------
    local headerY = layout.y
    local headerFrame = CreateFrame("Frame", nil, panel.content)
    headerFrame:SetPoint("TOPLEFT", menuStyle.contentPadding, headerY)
    headerFrame:SetWidth(defaultAvailableSpace)
    headerFrame:SetHeight(40)

    local headerTitle = headerFrame:CreateFontString(nil, "OVERLAY", menuStyle.headerFont)
    headerTitle:SetPoint("TOPLEFT", 0, 0)
    headerTitle:SetText(locales["CUSTOM_GRID"] or "Custom Grid")
    headerTitle:SetTextColor(_G.unpack(colors.gold)) -- #FFD100

    local masterToggle = addonTable.UIContext:createCheckbox({
        parent = headerFrame,
        text = locales["ENABLE_ADVANCED_GRID"] or "Enable Advanced Mode",
        tooltip = locales["ENABLE_ADVANCED_GRID_DESC"],
        getter = function() return profile.customGridMasterEnabled end,
        setter = function(v)
            profile.customGridMasterEnabled = v
            ascensionBars:updateDisplay()
            if panel.updateLayout then panel:updateLayout() end

            -- Refresh Bars Layout if initialized
            if ascensionBars.configTabs and ascensionBars.configTabs.panels and ascensionBars.configTabs.panels[1] then
                local barsPanel = ascensionBars.configTabs.panels[1]
                if barsPanel.updateLayout then barsPanel:updateLayout() end
            end
        end,
        xOffset = 0,
        yOffset = 0
    })
    masterToggle:ClearAllPoints()
    masterToggle:SetPoint("LEFT", headerTitle, "LEFT", 180, 2)

    layout.y = headerY - headerFrame:GetHeight() - 6

    -- -------------------------------------------------------------------------------
    -- GRID SECTIONS (if enabled)
    -- -------------------------------------------------------------------------------
    if profile.customGridMasterEnabled then
        local blocks = {
            { name = locales["TOP_BLOCK"],    key = "TOP" },
            { name = locales["BOTTOM_BLOCK"], key = "BOTTOM" }
        }

        local currentY = layout.y

        for _, block in ipairs(blocks) do
            local blockEndY = buildGridBlock(panel, block.key, block.name, currentY, defaultAvailableSpace)
            currentY = blockEndY - menuStyle.contentPadding
        end

        layout.y = currentY
    end

    -- -------------------------------------------------------------------------------
    -- REPUTATION MANAGEMENT SECTION
    -- -------------------------------------------------------------------------------
    local repEndY = buildReputationSection(panel, layout.y - menuStyle.contentPadding, defaultAvailableSpace)

    -- Adjust scroll frame height
    panel.content:SetHeight(math.abs(repEndY) + menuStyle.contentPadding * 2)
    if panel.scrollFrame then
        panel.scrollFrame:UpdateScrollChildRect()
    end
end
