
-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
-- Author: Aka-DoctorCode
-- File: Legend.lua
-- Version: @project-version@
-------------------------------------------------------------------------------
-- Copyright (c) 2025–2026 Aka-DoctorCode. All Rights Reserved.
--
-- This software and its source code are the exclusive property of the author.
-- No part of this file may be copied, modified, redistributed, or used in
-- derivative works without express written permission.
-------------------------------------------------------------------------------

local addonName, addonTable = ...
---@class AscensionBars
local ascensionBars = LibStub("AceAddon-3.0"):GetAddon(addonName)
local dataText = addonTable.dataText

-------------------------------------------------------------------------------
-- LEGEND MODULE (Estructura Elástica y Dinámica)
-------------------------------------------------------------------------------

local legend = CreateFrame("Frame", "AscensionBars_Legend", UIParent)
legend:SetSize(130, 50)
legend:SetMovable(true)
legend:EnableMouse(true)
legend:SetFrameStrata("TOOLTIP")
legend:SetClipsChildren(true) 

legend:SetPoint("RIGHT", UIParent, "RIGHT", -20, 0)

legend:RegisterForDrag("LeftButton")
legend:SetScript("OnDragStart", function(self) self:StartMoving() end)
legend:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

local shadow = legend:CreateTexture(nil, "BACKGROUND")
shadow:SetPoint("TOPLEFT", legend, "TOPLEFT", -2, 2)
shadow:SetPoint("BOTTOMRIGHT", legend, "BOTTOMRIGHT", 2, -2)

legend.lines = {}

-- ESPACIOS DE SEGURIDAD MUY REDUCIDOS
local PADDING = 2
local EDGE_MARGIN = 2
local INTERNAL_GAP = 5 -- Reducido para compactar horizontalmente

-- Función para aplicar fuente, tamaño y contorno dinámico
local function ApplyFontAndOutline(fontString, size, outline)
    if not fontString then return end
    local f = fontString:GetFont()
    if not f or f == "" then f = STANDARD_TEXT_FONT or "Fonts\\FRIZQT__.TTF" end
    -- Si el perfil dice "NONE", le pasamos una cadena vacía a la API de WoW
    local finalOutline = (outline == "NONE") and "" or outline
    fontString:SetFont(f, size, finalOutline)
end

function ascensionBars:updateLegend()
    local profile = self.db and self.db.profile
    if not profile or not profile.legendEnabled then
        legend:Hide()
        return
    end

    legend:Show()

    local bgAlpha = profile.legendBgAlpha
    if bgAlpha == nil then bgAlpha = 0.4 end
    shadow:SetColorTexture(0, 0, 0, bgAlpha)

    local textSize = profile.legendTextSize or 12
    local subTextSize = math.max(8, textSize - 2)
    local outlineMode = profile.legendFontOutline or "OUTLINE"
    
    -- COMPACTACIÓN VERTICAL: Reducimos el espacio extra de 12 a 4
    local dynamicRowHeight = textSize + subTextSize + 4

    local activeBars = {}
    local barsToCheck = {
        { obj = self.xp,      key = "XP" },
        { obj = self.rep,     key = "Rep" },
        { obj = self.honor,   key = "Honor" },
        { obj = self.houseXp, key = "HouseXp" },
        { obj = self.azerite, key = "Azerite" }
    }

    for _, entry in ipairs(barsToCheck) do
        if entry.obj and entry.obj.bar and entry.obj.bar:IsShown() then
            table.insert(activeBars, entry)
        end
    end

    table.sort(activeBars, function(a, b)
        local aY = a.obj.bar:GetBottom() or 0
        local bY = b.obj.bar:GetBottom() or 0
        return aY > bY
    end)

    local lineIndex = 1
    for _, entry in ipairs(activeBars) do
        local barObj = entry.obj
        local line = legend.lines[lineIndex]

        if not line then
            line = {}
            line.frame = CreateFrame("Frame", nil, legend)
            
            line.name = line.frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            line.name:SetJustifyH("LEFT")

            line.subName = line.frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            line.subName:SetJustifyH("LEFT")

            line.pct = line.frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            line.pct:SetJustifyH("RIGHT")

            line.abs = line.frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            line.abs:SetJustifyH("RIGHT")

            table.insert(legend.lines, line)
        end

        ApplyFontAndOutline(line.name, textSize, outlineMode)
        ApplyFontAndOutline(line.subName, subTextSize, outlineMode)
        ApplyFontAndOutline(line.pct, subTextSize, outlineMode)
        ApplyFontAndOutline(line.abs, subTextSize, outlineMode)

        line.frame:SetHeight(dynamicRowHeight)
        line.frame:ClearAllPoints()
        line.frame:SetPoint("TOPLEFT", legend, "TOPLEFT", 0, -((lineIndex - 1) * dynamicRowHeight) - PADDING)
        line.frame:SetPoint("RIGHT", legend, "RIGHT", 0, 0)

        local displayName = barObj.displayName or entry.key
        local subNameText = ""
        if entry.key == "Rep" and barObj.standing then
            subNameText = barObj.standing
        end

        line.name:SetText(displayName)
        line.subName:SetText(subNameText)
        
        local c = barObj.color or {}
        local r, g, b = c.r or 1, c.g or 1, c.b or 1
        line.name:SetTextColor(r, g, b)
        line.subName:SetTextColor(r * 0.85, g * 0.85, b * 0.85)

        local hasAbs = profile.showAbsoluteValues
        local hasPct = profile.showPercentage
        if not hasAbs and not hasPct then hasPct = true end

        local pctTextStr = string.format("%.1f%%", type(barObj.percentage) == "number" and barObj.percentage or 0)
        local absTextStr = string.format("%s / %s", dataText:FormatValue(barObj.current or 0, profile) or "0", dataText:FormatValue(barObj.max or 1, profile) or "1")

        line.pct:Hide(); line.abs:Hide()
        line.name:ClearAllPoints(); line.subName:ClearAllPoints()
        line.pct:ClearAllPoints(); line.abs:ClearAllPoints()

        -- COMPACTACIÓN VERTICAL: Textos más juntos
        line.name:SetPoint("TOPLEFT", line.frame, "TOPLEFT", EDGE_MARGIN, -1)
        line.subName:SetPoint("BOTTOMLEFT", line.frame, "BOTTOMLEFT", EDGE_MARGIN, 1)

        if hasPct and hasAbs then
            line.pct:SetText(pctTextStr)
            line.pct:SetPoint("TOPRIGHT", line.frame, "TOPRIGHT", -EDGE_MARGIN, -1)
            line.pct:Show()
            
            line.abs:SetText(absTextStr)
            line.abs:SetPoint("BOTTOMRIGHT", line.frame, "BOTTOMRIGHT", -EDGE_MARGIN, 1)
            line.abs:Show()
        elseif hasPct and not hasAbs then
            line.pct:SetText(pctTextStr)
            line.pct:SetPoint("RIGHT", line.frame, "RIGHT", -EDGE_MARGIN, 0)
            line.pct:Show()
        elseif hasAbs and not hasPct then
            line.abs:SetText(absTextStr)
            line.abs:SetPoint("RIGHT", line.frame, "RIGHT", -EDGE_MARGIN, 0)
            line.abs:Show()
        end

        -- Calculamos el ancho (+4 para compensar el outline si existe)
        local rightSideWidth = math.max(line.pct:IsShown() and line.pct:GetStringWidth() or 0, line.abs:IsShown() and line.abs:GetStringWidth() or 0)
        local leftSideWidth = math.max(line.name:GetStringWidth() or 0, line.subName:GetStringWidth() or 0)
        local currentGap = rightSideWidth > 0 and INTERNAL_GAP or 0
        
        local outlineBuffer = (outlineMode == "NONE") and 0 or 4
        line.currentWidth = leftSideWidth + currentGap + rightSideWidth + (EDGE_MARGIN * 2) + outlineBuffer

        line.frame:Show()
        lineIndex = lineIndex + 1
    end

    for i = lineIndex, #legend.lines do
        legend.lines[i].frame:Hide()
    end

    if lineIndex == 1 then
        legend:Hide()
        return
    end

    local maxRequiredWidth = 0
    for i = 1, lineIndex - 1 do
        if legend.lines[i].currentWidth > maxRequiredWidth then
            maxRequiredWidth = legend.lines[i].currentWidth
        end
    end

    local finalWidth = math.max(130, maxRequiredWidth)
    local finalHeight = ((lineIndex - 1) * dynamicRowHeight) + (PADDING * 2)

    legend:SetSize(finalWidth, finalHeight)
    legend:SetAlpha(1.0)
end