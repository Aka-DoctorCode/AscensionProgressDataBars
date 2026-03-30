-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
-- Author: Aka-DoctorCode
-- File: AscensionProgressDataBars.lua
-- Version: @project-version@
-------------------------------------------------------------------------------
-- Copyright (c) 2025-2026 Aka-DoctorCode. All Rights Reserved.
--
-- This software and its source code are the exclusive property of the author.
-- No part of this file may be copied, modified, redistributed, or used in
-- derivative works without express written permission.
-------------------------------------------------------------------------------

local addonName, addonTable = ...
local Locales = LibStub("AceLocale-3.0"):GetLocale("AscensionProgressDataBars")

---@class AscensionBars
---@field db { profile: table, global: table, RegisterCallback: function, SetProfile: function, GetProfiles: function, GetCurrentProfile: function, CopyProfile: function, DeleteProfile: function, ResetProfile: function }
---@field paragonText FontString
---@field renderParagonText function
---@field scanParagonRewards function
---@field notifyParagonRewardsAvailable function
---@field activeBars table<string, table>
---@field xp table
---@field rep table
---@field honor table
---@field houseXp table
---@field azerite table
---@field state table
---@field constants table
---@field defaults table
---@field configFrame Frame | any
---@field isMinimized boolean
---@field normalWidth number
---@field normalHeight number
---@field activeTab number
---@field tabs table
---@field panels table
---@field textHolder Frame
---@field textHolders table
---@field fontToUse string
---@field colors table
---@field files table
---@field menuStyle table
---@field houseRewardText FontString
---@field hoverFrame Frame
---@field registeredElements table
---@field configTabs table
---@field refreshConfig function
---@field refreshConfigUI function
---@field updateDisplay function
---@field updateVisibility function
---@field setupBar function
---@field getClassColor function
---@field refreshHousingFavor function
---@field setupTextHolders function
---@field acquireTexture function
---@field updateStandardBar function
---@field cleanupTextures function
---@field hideBlizzardFrames function
---@field createBars function
---@field createDynamicBar function
---@field removeDynamicBar function
---@field searchFactionText string
---@field selectedFactionToAdd number
---@field updateLayout function
---@field IsEnabled function
---@field RegisterChatCommand function
---@field RegisterEvent function
---@field UnregisterEvent function
---@field UnregisterAllEvents function
---@field NewModule function
---@field IterateModules function
---@field GetModule function
---@field configExperience function
---@field configReputation function
---@field configHonor function
---@field configHouseXp function
---@field configAzerite function
---@field renderExperience function
---@field renderReputation function
---@field renderHonor function
---@field renderHouseXp function
---@field renderAzerite function
---@field getFactionData function
---@field onHouseFavorUpdated function
---@field formatXP function
---@field getPlayerMaxLevel function
---@field applyTextStyles function
---@field handleOnUpdate function
---@field toggleConfig function
---@field onPlayerEnteringWorld function
---@field onCombatStart function
---@field onCombatEnd function
---@field onQuestTurnIn function
---@field onCVarUpdate function
---@field createFrames function
---@field createBar function
---@field updateSpark function
---@field pushCarouselEvent function
---@field updateLegend function
---@field updateCarouselVisibility function
---@field startCarousel function

---@class DataTextResult
---@field identity string
---@field details string
---@field percentage string
---@field remaining string

local ascensionBars = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceEvent-3.0", "AceConsole-3.0")
---@cast ascensionBars AscensionBars

addonTable.main = ascensionBars

local texturePool = {}
local lastUpdate  = 0

-------------------------------------------------------------------------------
-- UTILITIES
-------------------------------------------------------------------------------

function ascensionBars:getPlayerMaxLevel()
    if _G.GetMaxLevelForLatestExpansion then
        local maxLevel = _G.GetMaxLevelForLatestExpansion()
        if maxLevel then return maxLevel end
    end
    return 80
end

function ascensionBars:getClassColor()
    if not self.state then return { r = 1, g = 1, b = 1, a = 1 } end -- #FFFFFF

    if not self.state.cachedClassColor then
        local _, classFilename = UnitClass("player")
        if classFilename then
            local classColor = C_ClassColor.GetClassColor(classFilename)
            if classColor then
                self.state.cachedClassColor = classColor
                return self.state.cachedClassColor
            end
        end
        self.state.cachedClassColor = { r = 1, g = 1, b = 1, a = 1 } -- #FFFFFF
    end
    return self.state.cachedClassColor
end

function ascensionBars:hideBlizzardFrames()
    local framesToHide = { _G["StatusTrackingBarManager"], _G["UIWidgetPowerBarContainerFrame"] }
    for _, frame in pairs(framesToHide) do
        if frame then
            frame:UnregisterAllEvents()
            frame:Hide()
            frame:SetAlpha(0)
            frame.Show = function() end
        end
    end
end

function ascensionBars:formatXP()
    local dt = addonTable.dataText
    if dt then return dt:combine(dt:formatExperience()) end
    return ""
end

-------------------------------------------------------------------------------
-- FRAME CREATION
-------------------------------------------------------------------------------

function ascensionBars:createFrames()
    self.textHolder = CreateFrame("Frame", "AscensionBars_TextHolderT1", UIParent)
    self.textHolder:SetFrameStrata("HIGH")
    self.textHolder:SetClipsChildren(false)
    self.textHolder:SetHeight(20)
    self.textHolder:SetPoint("CENTER", UIParent, "CENTER", 0, 0)

    if not self.hoverFrame then
        self.hoverFrame = CreateFrame("Frame", "AscensionBars_HoverFrame", UIParent)
        self.hoverFrame:SetAllPoints(UIParent)
        self.hoverFrame:SetFrameStrata("BACKGROUND")
        self.hoverFrame:EnableMouse(false)
    end

    if not self.paragonText then
        self.paragonText = UIParent:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    end

    if not self.houseRewardText then
        self.houseRewardText = UIParent:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    end


    local barDefs = {
        { key = "XP",      name = "AscensionXPBar_XP"      },
        { key = "Rep",     name = "AscensionXPBar_Rep"     },
        { key = "Honor",   name = "AscensionXPBar_Honor"   },
        { key = "HouseXp", name = "AscensionXPBar_HouseXp" },
        { key = "Azerite", name = "AscensionXPBar_Azerite" },
    }

    self.activeBars = {}
    for _, def in ipairs(barDefs) do
        self.activeBars[def.key] = self:createBar(def.name)
    end

    if self.db and self.db.profile and self.db.profile.bars then
        for k, v in pairs(self.db.profile.bars) do
            if string.match(k, "^Rep_%d+$") then
                self.activeBars[k] = self:createBar("AscensionXPBar_" .. k)
            end
        end
    end

    -- Backward-compat aliases consumed by bar modules
    self.xp      = self.activeBars["XP"]
    self.rep     = self.activeBars["Rep"]
    self.honor   = self.activeBars["Honor"]
    self.houseXp = self.activeBars["HouseXp"]
    self.azerite = self.activeBars["Azerite"]

    if self.honor   then self.honor.bar:Hide()   end
    if self.houseXp then self.houseXp.bar:Hide() end
    if self.azerite then self.azerite.bar:Hide() end


end

function ascensionBars:createDynamicBar(barKey)
    if self.activeBars[barKey] then return end
    self.activeBars[barKey] = self:createBar("AscensionXPBar_" .. barKey)
    if addonTable.dataText and addonTable.dataText.initBarText then
        addonTable.dataText:initBarText(self.activeBars[barKey])
    end
end

function ascensionBars:removeDynamicBar(barKey)
    if not self.activeBars[barKey] then return end
    local barObj = self.activeBars[barKey]
    if barObj.bar then barObj.bar:Hide() end
    if barObj.txFrame then barObj.txFrame:Hide() end
    self.activeBars[barKey] = nil
end

function ascensionBars:createBar(name)
    local bar = CreateFrame("StatusBar", name, UIParent)
    bar:SetFrameStrata("MEDIUM")
    bar:EnableMouse(true)

    local barKey = string.match(name, "AscensionXPBar_(.+)")

    bar:SetScript("OnEnter", function()
        if self.state then
            self.state.isHovering  = true
            self.state.hoveredBarKey = barKey
            self:updateVisibility()
        end
    end)

    bar:SetScript("OnLeave", function()
        if self.state then
            self.state.isHovering  = false
            self.state.hoveredBarKey = nil
            self:updateVisibility()
        end
    end)

    bar:SetStatusBarTexture(self.constants.TEXTURE_BAR)
    bar:SetClipsChildren(true)

    local background = self:acquireTexture(bar)
    if background then
        background:SetAllPoints()
        background:SetTexture(self.constants.TEXTURE_BAR)
        local bgAlpha = (self.db and self.db.profile and self.db.profile.backgroundAlpha) or 0.5
        background:SetVertexColor(0, 0, 0, bgAlpha) -- #000000
        background:SetDrawLayer("BACKGROUND", -1)
    end

    -- Spark outer glow bloom layer
    local sparkGlow = bar:CreateTexture(nil, "ARTWORK", nil, 1)
    sparkGlow:SetTexture(self.constants.TEXTURE_SPARK)
    sparkGlow:SetBlendMode("ADD")
    sparkGlow:SetVertexColor(1, 1, 1, 0.9) -- #FFFFFF
    sparkGlow:Hide()

    -- Spark inner hard-edge core line
    local sparkCore = bar:CreateTexture(nil, "ARTWORK", nil, 2)
    sparkCore:SetTexture(self.constants.TEXTURE_BAR)
    sparkCore:SetBlendMode("ADD")
    sparkCore:SetVertexColor(1, 1, 1, 1) -- #FFFFFF
    sparkCore:Hide()

    local restedOverlay = (name == "AscensionXPBar_XP") and bar:CreateTexture(nil, "ARTWORK") or nil

    local txFrame = CreateFrame("Frame", nil, UIParent)
    txFrame:SetFrameStrata("HIGH")
    txFrame:SetFrameLevel(bar:GetFrameLevel() + 5)
    txFrame:SetAllPoints(bar)
    txFrame:Hide()

    local leftText   = txFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    local centerText = txFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    local rightText  = txFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")

    return {
        bar           = bar,
        sparkGlow     = sparkGlow,
        sparkCore     = sparkCore,
        leftText      = leftText,
        centerText    = centerText,
        rightText     = rightText,
        txFrame       = txFrame,
        restedOverlay = restedOverlay,
        background    = background,
    }
end

function ascensionBars:acquireTexture(parent)
    if not parent then return nil end
    for i = 1, #texturePool do
        if not texturePool[i]:IsShown() and texturePool[i]:GetParent() == parent then
            texturePool[i]:Show()
            return texturePool[i]
        end
    end
    local texture = parent:CreateTexture(nil, "BACKGROUND")
    table.insert(texturePool, texture)
    return texture
end

function ascensionBars:cleanupTextures()
    for i = 1, #texturePool do
        if texturePool[i] then texturePool[i]:Hide() end
    end
end

-------------------------------------------------------------------------------
-- DISPLAY HELPERS
-------------------------------------------------------------------------------

function ascensionBars:updateSpark(bar, minVal, maxVal, currentVal)
    local hasGlow = bar and bar.sparkGlow
    local hasCore = bar and bar.sparkCore

    if not (self.db and self.db.profile and self.db.profile.sparkEnabled) then
        if hasGlow then bar.sparkGlow:Hide() end
        if hasCore then bar.sparkCore:Hide() end
        return
    end

    if not hasGlow or not hasCore then return end

    local barWidth  = bar.bar:GetWidth()
    local barHeight = bar.bar:GetHeight()
    local percentage = (maxVal > minVal) and (currentVal - minVal) / (maxVal - minVal) or 0
    local xPos = barWidth * percentage

    -- Core: 2px wide, exact bar height — the sharp bright edge
    bar.sparkCore:SetSize(2, barHeight)
    bar.sparkCore:ClearAllPoints()
    bar.sparkCore:SetPoint("CENTER", bar.bar, "LEFT", xPos, 0)
    bar.sparkCore:Show()

    -- Glow: wide soft bloom, at least 3x bar height for visible bleed effect
    local glowHeight = math.max(barHeight * 3, 18)
    local glowWidth  = math.max(glowHeight * 4, 75)
    bar.sparkGlow:SetSize(glowWidth, glowHeight)
    bar.sparkGlow:ClearAllPoints()
    bar.sparkGlow:SetPoint("CENTER", bar.bar, "LEFT", xPos, 0)
    bar.sparkGlow:Show()
end

function ascensionBars:setupBar(bar, minVal, maxVal, currentVal, color)
    if not bar or not bar.bar then return end
    if maxVal <= minVal then maxVal = minVal + 1 end
    bar.bar:SetMinMaxValues(minVal, maxVal)
    bar.bar:SetValue(currentVal)
    bar.bar:SetStatusBarColor(color.r, color.g, color.b, color.a or 1)
    self:updateSpark(bar, minVal, maxVal, currentVal)
end

function ascensionBars:updateStandardBar(barObj, barKey, currentFunc, maxFunc, colorFunc, textFunc)
    if not self.db or not barObj then return end
    local profile = self.db.profile
    if not profile or not profile.bars then return end

    local config = profile.bars[barKey]
    if not config or not config.enabled then
        if barObj.bar    then barObj.bar:Hide()    end
        if barObj.txFrame then barObj.txFrame:Hide() end
        return
    end

    if barObj.bar     then barObj.bar:Show()    end
    if barObj.txFrame then barObj.txFrame:Show() end

    local current = currentFunc()
    local maxVal  = maxFunc()
    if maxVal == 0 then maxVal = 1 end

    local color = colorFunc()
    self:setupBar(barObj, 0, maxVal, current, color)

    barObj.current    = current
    barObj.max        = maxVal
    barObj.percentage = (current / maxVal) * 100
    barObj.color      = color

    local str = textFunc(current, maxVal, (current / maxVal) * 100)
    if barObj.centerText then barObj.centerText:SetText(str) end
    if barObj.leftText   then barObj.leftText:SetText("")   end
    if barObj.rightText  then barObj.rightText:SetText("")  end
end

-------------------------------------------------------------------------------
-- DISPLAY PIPELINE
-------------------------------------------------------------------------------

function ascensionBars:applyTextStyles()
    if not self.db or not self.db.profile then return end

    local profile = self.db.profile
    local font    = profile.fontPath or [[Fonts\FRIZQT__.TTF]]
    local outline = profile.fontOutline or "OUTLINE"

    for barKey, obj in pairs(self.activeBars or {}) do
        if obj then
            local barConfig  = profile.bars and profile.bars[barKey]
            local finalFont  = font
            if barConfig and barConfig.useCustomFont then
                finalFont = barConfig.customFontPath or finalFont
            end

            local finalSize = profile.textSize or 14
            if barConfig and barConfig.useCustomTextSize then
                finalSize = barConfig.customTextSize or finalSize
            end

            local finalColor = profile.textColor or { r = 1, g = 1, b = 1, a = 1 } -- #FFFFFF
            if barConfig and barConfig.useCustomTextColor then
                finalColor = barConfig.customTextColor or finalColor
            end

            local function applyStyle(fontString, anchor, xOff)
                if not fontString then return end
                fontString:SetFont(finalFont, finalSize, outline)
                fontString:SetTextColor(finalColor.r or 1, finalColor.g or 1, finalColor.b or 1, finalColor.a or 1)
                local yOff = profile.textYOffset or 0
                fontString:ClearAllPoints()
                fontString:SetPoint(anchor, obj.bar, anchor, xOff, yOff)
            end

            applyStyle(obj.leftText,   "LEFT",    10)
            applyStyle(obj.centerText, "CENTER",   0)
            applyStyle(obj.rightText,  "RIGHT",  -10)
        end
    end
end

function ascensionBars:updateDisplay(force)
    local now = GetTime()
    if not force and (now - lastUpdate < ascensionBars.constants.UPDATE_THROTTLE) then
        if self.state and not self.state.updatePending then
            self.state.updatePending = true
            C_Timer.After(ascensionBars.constants.UPDATE_THROTTLE, function()
                if self.state then self.state.updatePending = false end
                self:updateDisplay(true)
            end)
        end
        return
    end
    lastUpdate = now

    if not self.db or not self.db.profile then return end
    local profile = self.db.profile
    local bars    = profile and profile.bars or nil
    if not bars then return end

    self:applyTextStyles()

    local maxLevel   = self:getPlayerMaxLevel() or 1
    local curLevel   = UnitLevel("player") or 0
    local isConfig   = self.state and self.state.isConfigMode
    local shouldHideXP = (curLevel >= maxLevel) and profile.hideAtMaxLevel and not isConfig

    self:updateLayout(shouldHideXP)
    self:updateVisibility()

    -- Dispatch to every registered module's UpdateRender method
    for _, module in self:IterateModules() do
        if module:IsEnabled() and module.UpdateRender then
            module:UpdateRender(isConfig, shouldHideXP)
        end
    end

    if self.updateLegend             then self:updateLegend()             end
    if self.updateCarouselVisibility then self:updateCarouselVisibility() end
end

function ascensionBars:updateLayout(shouldHideXP)
    if not self.db or not self.db.profile then return end
    local profile = self.db.profile
    local bars    = profile and profile.bars or nil
    if not bars then return end

    local blocks = { TOP = {}, BOTTOM = {}, FREE = {} }

    for barKey, entry in pairs(self.activeBars or {}) do
        local config = bars[barKey]
        if config and config.enabled and not (barKey == "XP" and shouldHideXP) then
            table.insert(blocks[config.block or "TOP"], { obj = entry, key = barKey })
            if entry.txFrame then entry.txFrame:Show() end
        else
            if entry.bar     then entry.bar:Hide()     end
            if entry.txFrame then entry.txFrame:Hide() end
        end
    end

    local function getBarHeight(entry)
        local config = bars[entry.key]
        if not config then return profile.globalBarHeight or 6 end
        local block = config.block or "TOP"
        if block == "FREE" then return config.freeHeight or 15 end
        if config.useCustomHeight then return config.customHeight or 10 end
        if profile.usePerBlockHeights and profile.blockHeights and profile.blockHeights[block] then
            return profile.blockHeights[block]
        end
        return profile.globalBarHeight or 6
    end

    local sortFn = function(a, b)
        return (bars[a.key].order or 0) < (bars[b.key].order or 0)
    end
    table.sort(blocks.TOP,    sortFn)
    table.sort(blocks.BOTTOM, sortFn)

    ---------------------------------------------------------------------------
    local barAnchor = profile.barAnchor or "TOP"
    local screenW   = UIParent:GetWidth() or 1024

    local function layoutBlock(block, blockName, startAnchor, anchorFrame, direction)
        local prevBar = nil
        
        local initialYOffset
        if blockName == "TOP" then
            initialYOffset = profile.usePerBlockOffsets and (profile.topOffset or 0) or (profile.yOffset or -2)
        else
            -- Bottom offset from the slider is positive (0 to +500).
            -- Global yOffset from the slider is negative (0 to -500).
            -- We always need a positive value here to push UP from the bottom edge of UIParent.
            initialYOffset = profile.usePerBlockOffsets and (profile.bottomOffset or 0) or math.abs(profile.yOffset or -2)
        end
        
        local gap = profile.usePerBlockGaps and (blockName == "TOP" and (profile.topBarGap or 0) or (profile.bottomBarGap or 0)) or (profile.barGap or 2)
        
        for i, entry in ipairs(block) do
            local obj    = entry.obj
            local height = getBarHeight(entry)
            obj.bar:SetHeight(height)
            obj.bar:ClearAllPoints()

            if entry.key == "XP" and shouldHideXP then
                obj.bar:Hide()
            end

            if prevBar then
                local gapDirection = (blockName == "TOP") and -gap or gap
                obj.bar:SetPoint(startAnchor, prevBar, direction, 0, gapDirection)
                obj.bar:SetWidth(screenW)
            else
                obj.bar:SetPoint(startAnchor, anchorFrame, startAnchor, 0, initialYOffset)
                obj.bar:SetWidth(screenW)
            end

            if entry.txFrame then
                obj.txFrame:SetAllPoints(obj.bar)
            end

            obj.bar:Show()
            prevBar = obj.bar
        end
    end

    local function layoutGridBlock(block, blockName, startAnchor, anchorFrame, direction)
        local grid = profile.customGrids and profile.customGrids[blockName]
        if not grid or not grid.enabled then return false end
        
        local initialYOffset
        if blockName == "TOP" then
            initialYOffset = profile.usePerBlockOffsets and (profile.topOffset or 0) or (profile.yOffset or -2)
        else
            initialYOffset = profile.usePerBlockOffsets and (profile.bottomOffset or 0) or math.abs(profile.yOffset or -2)
        end
        local gap = profile.usePerBlockGaps and (blockName == "TOP" and (profile.topBarGap or 0) or (profile.bottomBarGap or 0)) or (profile.barGap or 2)
        local gapDirection = (blockName == "TOP") and -gap or gap
        
        local availableBars = {}
        for _, entry in ipairs(block) do availableBars[entry.key] = entry end
        
        local prevRowBar = nil
        
        for r = 1, grid.numRows or 1 do
            local cols = (grid.colsPerRow and grid.colsPerRow[r]) or 1
            local cellWidth = (screenW - ((cols - 1) * gap)) / cols
            local prevColBar = nil
            local firstBarInRow = nil
            
            for c = 1, cols do
                local assignedKey = grid.assignments and grid.assignments[r] and grid.assignments[r][c]
                local entry = assignedKey and availableBars[assignedKey]
                
                if entry then
                    local obj = entry.obj
                    local height = getBarHeight(entry)
                    obj.bar:SetHeight(height)
                    obj.bar:SetWidth(cellWidth)
                    obj.bar:ClearAllPoints()
                    
                    if entry.key == "XP" and shouldHideXP then
                        obj.bar:Hide()
                    else
                        if c == 1 then
                            if r == 1 then
                                obj.bar:SetPoint(startAnchor, anchorFrame, startAnchor, 0, initialYOffset)
                            else
                                if prevRowBar then
                                    obj.bar:SetPoint(startAnchor, prevRowBar, direction, 0, gapDirection)
                                else
                                    obj.bar:SetPoint(startAnchor, anchorFrame, startAnchor, 0, initialYOffset)
                                end
                            end
                            firstBarInRow = obj.bar
                            prevRowBar = obj.bar
                        else
                            if prevColBar then
                                obj.bar:SetPoint("LEFT", prevColBar, "RIGHT", gap, 0)
                            end
                        end
                        
                        if entry.txFrame then obj.txFrame:SetAllPoints(obj.bar) end
                        obj.bar:Show()
                        prevColBar = obj.bar
                    end
                    availableBars[assignedKey] = nil
                end
            end
            if firstBarInRow then prevRowBar = firstBarInRow end
        end
        
        for key, entry in pairs(availableBars) do
            entry.obj.bar:Hide()
            if entry.obj.txFrame then entry.obj.txFrame:Hide() end
        end
        return true
    end

    local function renderBlock(blockData, blockName, startAnchor, anchorFrame, direction)
        local gridOpts = profile.customGrids and profile.customGrids[blockName]
        if gridOpts and gridOpts.enabled then
            layoutGridBlock(blockData, blockName, startAnchor, anchorFrame, direction)
        else
            layoutBlock(blockData, blockName, startAnchor, anchorFrame, direction)
        end
    end

    if barAnchor == "TOP" then
        renderBlock(blocks.TOP,    "TOP",    "TOPLEFT",    UIParent, "BOTTOMLEFT")
        renderBlock(blocks.BOTTOM, "BOTTOM", "BOTTOMLEFT", UIParent, "TOPLEFT")
    else
        renderBlock(blocks.BOTTOM, "BOTTOM", "BOTTOMLEFT", UIParent, "TOPLEFT")
        renderBlock(blocks.TOP,    "TOP",    "TOPLEFT",    UIParent, "BOTTOMLEFT")
    end

    for _, entry in ipairs(blocks.FREE) do
        local obj    = entry.obj
        local config = bars[entry.key]
        if config then
            obj.bar:ClearAllPoints()
            obj.bar:SetPoint("CENTER", UIParent, "CENTER", config.freeX or 0, config.freeY or 0)
            obj.bar:SetWidth(config.freeWidth or screenW)
            obj.bar:SetHeight(getBarHeight(entry))
            if obj.txFrame then obj.txFrame:SetAllPoints(obj.bar) end
            obj.bar:Show()
        end
    end
end

function ascensionBars:updateVisibility()
    if not self.db or not self.db.profile or not self.state then return end
    local profile      = self.db.profile
    local blockMode    = profile.blockTextMode or "FOCUS"
    local isConfig     = self.state.isConfigMode
    local legendHovered = self.state.legendHovered

    local baseAlpha = 1
    if not legendHovered and not isConfig then
        if profile.hideInCombat and self.state.inCombat then
            baseAlpha = 0
        elseif profile.showOnMouseover and not self.state.isHovering then
            baseAlpha = 0
        end
    end

    local dimAlpha = profile.focusDimAlpha or 0.4

    for key, barObj in pairs(self.activeBars or {}) do
        local barConfig = profile.bars and profile.bars[key]
        if barObj and barObj.bar and barConfig and barConfig.enabled then
            local barAlpha    = baseAlpha
            local centerAlpha = 0

            if blockMode == "FOCUS" then
                if self.state.hoveredBarKey == nil then
                    barAlpha    = baseAlpha
                    centerAlpha = 0
                elseif self.state.hoveredBarKey == key then
                    barAlpha    = baseAlpha
                    centerAlpha = baseAlpha
                else
                    barAlpha    = baseAlpha * dimAlpha
                    centerAlpha = 0
                end
            else
                barAlpha    = baseAlpha
                centerAlpha = baseAlpha
            end

            barObj.bar:SetAlpha(barAlpha)
            if barAlpha > 0 and not barObj.bar:IsShown() then
                barObj.bar:Show()
            end

            if barObj.leftText   then barObj.leftText:SetAlpha(0)             end
            if barObj.rightText  then barObj.rightText:SetAlpha(0)            end
            if barObj.centerText then barObj.centerText:SetAlpha(centerAlpha)  end
            if barObj.txFrame    then barObj.txFrame:SetAlpha(barAlpha)       end
        end
    end

    if self.textHolder then self.textHolder:SetAlpha(baseAlpha) end
    
    -- Actualizamos el texto de Paragon para aplicar cambios de posición/tamaño inmediatamente
    if self.scanParagonRewards then self:scanParagonRewards() end
end


-------------------------------------------------------------------------------
-- INITIALIZATION
-------------------------------------------------------------------------------

function ascensionBars:OnInitialize()
    local db = LibStub("AceDB-3.0"):New("AscensionProgressDataBarsDB", self.defaults, true)
    self.db = db

    self.db.RegisterCallback(self, "OnProfileChanged", "refreshConfig")
    self.db.RegisterCallback(self, "OnProfileCopied",  "refreshConfig")
    self.db.RegisterCallback(self, "OnProfileReset",   "refreshConfig")

    local function migrateOldSettings()
        if not db.profile then return end
        local p = db.profile
        if p.textGroups       then p.textGroups       = nil end
        if p.usePerGroupSize  ~= nil then p.usePerGroupSize  = nil end
        if p.usePerGroupColor ~= nil then p.usePerGroupColor = nil end
        if p.textLayoutMode   ~= nil then p.textLayoutMode   = nil end
        if p.textFollowBar    ~= nil then p.textFollowBar    = nil end
        if p.bars then
            for _, v in pairs(p.bars) do
                if v then
                    if v.textBlock then v.textBlock = nil end
                    if v.textOrder then v.textOrder = nil end
                    if v.textX     then v.textX     = nil end
                    if v.textY     then v.textY     = nil end
                end
            end
        end
    end

    migrateOldSettings()

    self.state = {
        isConfigMode     = false,
        isHovering       = false,
        inCombat         = false,
        updatePending    = false,
        hoveredBarKey    = nil,
        legendHovered    = false,
        cachedClassColor = nil,
        lastXP           = 0,
        lastXPMax        = 0,
        lastHonor        = 0,
        lastReputation   = {},
        lastAzeriteXP    = 0,
        lastHouseFavor   = {},
    }

    local defaultFont = [[Fonts\FRIZQT__.TTF]]
    if _G.GameFontNormal and _G.GameFontNormal.GetFont then
        self.fontToUse = _G.GameFontNormal:GetFont() or defaultFont
    else
        self.fontToUse = defaultFont
    end

    local function toggleConfig()
        self:toggleConfig()
    end
    self:RegisterChatCommand("apb", toggleConfig)

    self:createFrames()
end

function ascensionBars:OnEnable()
    self.state.isConfigMode  = false
    self.state.isHovering    = false
    self.state.inCombat      = false
    self.state.cachedClassColor = nil

    -- Core-level global events only — bar-specific events are owned by each module
    local coreEvents = {
        ["PLAYER_ENTERING_WORLD"] = "onPlayerEnteringWorld",
        ["PLAYER_REGEN_DISABLED"] = "onCombatStart",
        ["PLAYER_REGEN_ENABLED"]  = "onCombatEnd",
        ["QUEST_TURNED_IN"]       = "onQuestTurnIn",
        ["NEIGHBORHOOD_NAME_UPDATED"]  = "updateDisplay",
        ["CVAR_UPDATE"]           = "onCVarUpdate",
    }

    for event, method in pairs(coreEvents) do
        if self[method] then
            self:RegisterEvent(event, method)
        end
    end

    if addonTable.dataText and addonTable.dataText.initBarText then
        for _, bar in pairs(self.activeBars or {}) do
            if bar then addonTable.dataText:initBarText(bar) end
        end
    end

    if C_Reputation and C_Reputation.SetWatchedFactionByID then
        hooksecurefunc(C_Reputation, "SetWatchedFactionByID", function()
            self:updateDisplay()
        end)
    end

    if C_Housing and C_Housing.SetTrackedHouseGuid then
        hooksecurefunc(C_Housing, "SetTrackedHouseGuid", function()
            C_Timer.After(0.15, function()
                if self.refreshHousingFavor then self:refreshHousingFavor() end
                self:updateDisplay()
            end)
        end)
    end

    if self.refreshHousingFavor  then self:refreshHousingFavor()  end
    if self.scanParagonRewards   then self:scanParagonRewards()    end
    self:hideBlizzardFrames()
    self:updateDisplay(true)
end

-------------------------------------------------------------------------------
-- CORE EVENT HANDLERS
-------------------------------------------------------------------------------

function ascensionBars:onPlayerEnteringWorld()
    if self.scanParagonRewards  then self:scanParagonRewards()  end
    if self.refreshHousingFavor then self:refreshHousingFavor() end

    if not self.state then return end
    self.state.lastXP     = UnitXP("player")   or 0
    self.state.lastXPMax  = UnitXPMax("player") or 0
    self.state.lastHonor  = UnitHonor("player") or 0

    if C_AzeriteItem and C_AzeriteItem.FindActiveAzeriteItem then
        local itemLoc = C_AzeriteItem.FindActiveAzeriteItem()
        if itemLoc and C_AzeriteItem.GetAzeriteItemXPInfo then
            self.state.lastAzeriteXP = C_AzeriteItem.GetAzeriteItemXPInfo(itemLoc) or 0
        end
    end

    self:updateDisplay(true)
end

function ascensionBars:onCombatStart()
    if self.state then self.state.inCombat = true end
    self:updateVisibility()
    if self.updateCarouselVisibility then self:updateCarouselVisibility() end
end

function ascensionBars:onCombatEnd()
    if self.state then self.state.inCombat = false end
    self:updateVisibility()
    if self.updateCarouselVisibility then self:updateCarouselVisibility() end
    if self.startCarousel then self:startCarousel() end
end

function ascensionBars:onQuestTurnIn()
    C_Timer.After(1, function()
        if self.scanParagonRewards then self:scanParagonRewards() end
    end)
end

function ascensionBars:onCVarUpdate(_, name, _)
    if name == "trackedHouseFavor" then
        C_Timer.After(0.15, function()
            if self.refreshHousingFavor then self:refreshHousingFavor() end
            self:updateDisplay()
        end)
    end
end

function ascensionBars:OnDisable()
    self:cleanupTextures()
    for _, barObj in pairs(self.activeBars or {}) do
        if barObj and barObj.bar then barObj.bar:Hide() end
    end
    if self.textHolder then self.textHolder:Hide() end
end

function ascensionBars:refreshConfig()
    -- Ensure all dynamic bars (e.g. extra reputations) from the new profile exist
    if self.db and self.db.profile and self.db.profile.bars then
        for k, _ in pairs(self.db.profile.bars) do
            if string.match(k, "^Rep_%d+$") then
                self:createDynamicBar(k)
            end
        end
    end

    -- Refresh the configuration UI if it's currently loaded
    if self.refreshConfigUI then
        self:refreshConfigUI()
    end

    -- Update the actual bars on screen
    self:updateDisplay(true)
end

function ascensionBars:toggleConfig()
    if not self.configFrame then
        self:refreshConfigUI()
    end
    if self.configFrame then
        local isOpening = not self.configFrame:IsShown()
        self.configFrame:SetShown(isOpening)
        if not isOpening then
            self.state.isConfigMode = false
            self:updateDisplay(true)
        end
    end
end