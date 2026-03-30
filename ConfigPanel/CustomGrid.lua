-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
-- Author: Aka-DoctorCode
-- File: CustomGrid.lua
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
local locales = LibStub("AceLocale-3.0"):GetLocale("AscensionProgressDataBars")
local colors = ascensionBars.colors
local menuStyle = ascensionBars.menuStyle

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

    local cellButton = CreateFrame("Button", "VisualCell_" .. cellKey, parentFrame)
    cellButton:SetSize(cellWidth, cellHeight)
    cellButton:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", xPos, yPos)

    local bg = cellButton:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    cellButton.bg = bg

    local border = cellButton:CreateTexture(nil, "BORDER")
    border:SetAllPoints()
    border:SetColorTexture(unpack(colors.blackDetail))
    cellButton.border = border

    local innerBg = cellButton:CreateTexture(nil, "ARTWORK")
    innerBg:SetPoint("TOPLEFT", cellButton, "TOPLEFT", 1, -1)
    innerBg:SetPoint("BOTTOMRIGHT", cellButton, "BOTTOMRIGHT", -1, 1)
    cellButton.innerBg = innerBg

    -- Use GameFontNormal for better scaling
    local label = cellButton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("CENTER", cellButton, "CENTER", 0, 0)
    label:SetWidth(cellWidth - menuStyle.contentPadding)
    label:SetWordWrap(false)

    if currentAssignment == "none" or not currentAssignment then
        innerBg:SetColorTexture(unpack(colors.surfaceDark))
        label:SetText("+ " .. (locales["EMPTY"] or "Empty"))
        label:SetTextColor(unpack(colors.textDim))
    else
        innerBg:SetColorTexture(unpack(colors.primary))
        innerBg:SetAlpha(0.5)  -- semi-transparent for assigned cells
        local displayName = barNamesMap[currentAssignment] or currentAssignment
        label:SetText(displayName)
        label:SetTextColor(unpack(colors.textLight))
    end

    cellButton:SetScript("OnEnter", function(self)
        self.border:SetColorTexture(unpack(colors.surfaceHighlight))
    end)

    cellButton:SetScript("OnLeave", function(self)
        self.border:SetColorTexture(unpack(colors.blackDetail))
    end)

    cellButton:SetScript("OnClick", function(self)
        if MenuUtil and MenuUtil.CreateContextMenu then
            MenuUtil.CreateContextMenu(self, function(owner, rootDesc)
                rootDesc:CreateTitle(locales["ASSIGN_BAR"] or "Assign Bar")
                rootDesc:CreateButton(locales["NONE"] or "None", function()
                    if onSelectCallback then onSelectCallback("none") end
                end)
                for _, opt in ipairs(barOptions) do
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
        layoutCol.y = presetRowY
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
    for i, bKey in ipairs(barKeys) do
        table.insert(validBarOptions, { label = barNames[i], value = bKey })
    end

    local cellHeight = 35
    local rowStartY = layoutCol.y
    local maxDescentY = rowStartY

    for r = 1, grid.numRows do
        local cols = grid.colsPerRow[r] or 1
        local cellWidth = blockWidth / cols
        grid.assignments[r] = grid.assignments[r] or {}

        for c = 1, cols do
            local cellX = blockX + (c - 1) * cellWidth
            local currentAssig = grid.assignments[r][c] or "none"
            customGridTab:createVisualCell(panel.content, blockKey .. "_" .. r .. "_" .. c,
                cellWidth - menuStyle.contentPadding, cellHeight,
                cellX, rowStartY,
                currentAssig, barNamesMap, validBarOptions,
                function(selectedValue)
                    if selectedValue ~= "none" then
                        -- Remove from any other cell
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
        rowStartY = rowStartY - cellHeight - menuStyle.labelSpacing / 2
        layoutCol.y = rowStartY
    end

    layoutCol.y = layoutCol.y - menuStyle.contentPadding
end

-------------------------------------------------------------------------------
-- HELPER: Build toggle list for bars in a block
-------------------------------------------------------------------------------
local function buildBarToggles(panel, blockKey, barKeys, barNames, blockX, blockWidth, layoutCol)
    layoutCol:label("GridSubToggleHeader_" .. blockKey, locales["ENABLE"] or "Enable", blockX + menuStyle.contentPadding / 2, colors.gold)
    layoutCol.y = layoutCol.y - menuStyle.labelSpacing / 2

    local toggleStartY = layoutCol.y
    local maxTglDescentY = toggleStartY
    local toggleCount = 0

    for i, bKey in ipairs(barKeys) do
        local bConf = ascensionBars.db.profile.bars[bKey]
        if bConf and (bConf.block or "TOP") == blockKey then
            toggleCount = toggleCount + 1
            local tW = (blockWidth / 3) - menuStyle.contentPadding
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

    local layoutCol = addonTable.layoutModel:new(panel.content, startY)

    -- Block header
    local header = panel.content:CreateFontString(nil, "OVERLAY", menuStyle.headerFont)
    header:SetPoint("TOPLEFT", menuStyle.contentPadding, startY)
    header:SetWidth(availableWidth - menuStyle.contentPadding * 2)
    header:SetJustifyH("CENTER")
    header:SetText(blockName)
    header:SetTextColor(unpack(colors.gold))
    layoutCol.y = startY - menuStyle.headerSpacing

    -- Enable checkbox
    layoutCol:checkbox("GridToggle_" .. blockKey, locales["CUSTOM_GRID_ENABLE"] or "Enable Custom Grid Layout",
        locales["CUSTOM_GRID_DESC"] or "",
        function() return grid.enabled end,
        function(v)
            grid.enabled = v
            if v and grid.preset == "CUSTOM" and grid.numRows == 1 then
                grid.preset = "2X2"
                applyPresetToGrid(grid, "2X2")
            end
            ascensionBars:updateDisplay()
            if panel.updateLayout then panel:updateLayout() end
        end, menuStyle.contentPadding)

    layoutCol.y = layoutCol.y - menuStyle.labelSpacing

    if grid.enabled then
        -- Preset controls
        buildPresetControls(panel, blockKey, grid, menuStyle.contentPadding, availableWidth, layoutCol)

        layoutCol.y = layoutCol.y - menuStyle.labelSpacing

        -- Get bars belonging to this block
        local barKeys = {}
        local barNames = {}
        local barNamesMap = {}
        for k, cfg in pairs(profile.bars) do
            if (cfg.block or "TOP") == blockKey then
                table.insert(barKeys, k)
                local name = cfg.name or k
                table.insert(barNames, name)
                barNamesMap[k] = name
            end
        end

        -- Build cell grid
        buildCellGrid(panel, blockKey, grid, menuStyle.contentPadding, availableWidth,
                      barKeys, barNames, barNamesMap, layoutCol)

        layoutCol.y = layoutCol.y - menuStyle.labelSpacing

        -- Bar toggles
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

    if C_Reputation and C_Reputation.GetNumFactions then
        local numFactions = C_Reputation.GetNumFactions()
        for i = 1, numFactions do
            local fData = C_Reputation.GetFactionDataByIndex(i)
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
    local layoutRep = addonTable.layoutModel:new(panel.content, startY)

    -- Section header
    local repHeader = layoutRep:header("CustomRepHeader", locales["ADD_CUSTOM_REPUTATION"])
    repHeader:SetTextColor(unpack(colors.gold))
    layoutRep.y = layoutRep.y - menuStyle.labelSpacing

    layoutRep:beginSection(menuStyle.contentPadding, availableWidth - menuStyle.contentPadding * 2)
    layoutRep.y = layoutRep.y - menuStyle.labelSpacing

    -- Search row
    local searchRowY = layoutRep.y
    local marginX = menuStyle.contentPadding
    local spacing = menuStyle.checkboxSpacing / 2
    local searchWidth = 180
    local buttonWidth = 100
    local dropdownWidth = availableWidth - searchWidth - buttonWidth - (spacing * 3) - menuStyle.contentPadding * 2

    layoutRep.y = searchRowY
    layoutRep:input("SearchFactionInput", locales["SEARCH_FACTION"] or "Search:", searchWidth, marginX, function(text)
        customGridTab.searchFactionText = text
        C_Timer.After(0.01, function()
            if panel.updateLayout then panel:updateLayout() end
        end)
    end)

    -- Update faction cache if needed
    if not next(customGridTab.factionCache) then
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

    -- Dropdown
    local dropdownX = marginX + searchWidth + spacing
    layoutRep.y = searchRowY + menuStyle.contentPadding / 4
    layoutRep:dropdown("FactionSelectDropdown", nil, filteredFactions,
        function() return customGridTab.selectedFactionToAdd end,
        function(v) customGridTab.selectedFactionToAdd = v end, dropdownWidth, dropdownX)

    -- Add button
    local buttonX = dropdownX + dropdownWidth + spacing
    layoutRep.y = searchRowY - menuStyle.buttonHeight / 2
    layoutRep:button("AddFactionBtn", locales["ADD"] or "Add", buttonWidth, menuStyle.buttonHeight, buttonX, function()
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

    layoutRep.y = searchRowY - menuStyle.headerSpacing
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
    local layout = addonTable.layoutModel:new(panel.content, -menuStyle.contentPadding)

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
    headerTitle:SetTextColor(unpack(colors.gold))

    local masterToggle = CreateFrame("CheckButton", nil, headerFrame, "UICheckButtonTemplate")
    masterToggle:SetSize(menuStyle.checkboxSize, menuStyle.checkboxSize)
    masterToggle:SetPoint("LEFT", headerFrame, "LEFT", 160, -2)
    masterToggle:SetChecked(profile.customGridMasterEnabled)

    local toggleLabel = masterToggle:CreateFontString(nil, "OVERLAY", menuStyle.labelFont)
    toggleLabel:SetPoint("LEFT", masterToggle, "RIGHT", menuStyle.contentPadding / 2, 0)
    toggleLabel:SetText(locales["ENABLE_ADVANCED_GRID"] or "Enable Advanced Mode")
    toggleLabel:SetTextColor(unpack(colors.textLight))

    masterToggle:SetScript("OnClick", function(self)
        profile.customGridMasterEnabled = self:GetChecked()
        ascensionBars:updateDisplay()
        if panel.updateLayout then panel:updateLayout() end
    end)

    layout.y = headerY - headerFrame:GetHeight() - menuStyle.contentPadding

    -- Description
    local desc = panel.content:CreateFontString(nil, "OVERLAY", menuStyle.descFont)
    desc:SetPoint("TOPLEFT", menuStyle.contentPadding, layout.y)
    desc:SetWidth(defaultAvailableSpace - menuStyle.contentPadding * 2)
    desc:SetJustifyH("LEFT")
    desc:SetText(locales["CUSTOM_GRID_DESC"] or "Arrange bars in rows and columns. This layout overrides the standard bar order for the selected block.")
    desc:SetTextColor(unpack(colors.textDim))
    layout.y = layout.y - (desc:GetHeight() + menuStyle.labelSpacing)

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
    else
        local disabledMsg = panel.content:CreateFontString(nil, "OVERLAY", menuStyle.descFont)
        disabledMsg:SetPoint("TOPLEFT", menuStyle.contentPadding, layout.y)
        disabledMsg:SetWidth(defaultAvailableSpace - menuStyle.contentPadding * 2)
        disabledMsg:SetJustifyH("CENTER")
        disabledMsg:SetText(locales["CUSTOM_GRID_DISABLED_MSG"] or "Enable Custom Grid (Advanced) above to configure custom layouts.")
        disabledMsg:SetTextColor(unpack(colors.textDim))
        layout.y = layout.y - (disabledMsg:GetHeight() + menuStyle.labelSpacing)
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