
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
-- LEGEND MODULE (Estructura Compacta y Alineada)
-------------------------------------------------------------------------------

local legend = CreateFrame("Frame", "AscensionBars_Legend", UIParent)
legend:SetSize(130, 50)
legend:SetMovable(true)
legend:EnableMouse(true)
legend:SetFrameStrata("TOOLTIP")
legend:SetClipsChildren(false)

legend:SetPoint("RIGHT", UIParent, "RIGHT", -20, 0)

legend:RegisterForDrag("LeftButton")
legend:SetScript("OnDragStart", function(self) self:StartMoving() end)
legend:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

local shadow = legend:CreateTexture(nil, "BACKGROUND")
shadow:SetPoint("TOPLEFT", legend, "TOPLEFT", -2, 2)
shadow:SetPoint("BOTTOMRIGHT", legend, "BOTTOMRIGHT", 2, -2)
shadow:SetColorTexture(0, 0, 0, 0.4)

legend.lines = {}

local PADDING = 0
local EDGE_MARGIN = 0
local ROW_HEIGHT = 28
local INTERNAL_GAP = -24

local function UpdateAlphas()
    local isOver = legend:IsMouseOver()
    legend:SetAlpha(isOver and 1.0 or 0.6)
end

legend:SetScript("OnEnter", UpdateAlphas)
legend:SetScript("OnLeave", UpdateAlphas)

-- Función auxiliar para aplicar OUTLINE de forma segura
local function ApplyOutline(fontString)
    if not fontString then return end
    local f, s = fontString:GetFont()
    if f and f ~= "" and s and s > 0 then
        fontString:SetFont(f, s, "OUTLINE")
    end
end

function ascensionBars:updateLegend()
    local profile = self.db and self.db.profile
    if not profile or not profile.legendEnabled then
        legend:Hide()
        return
    end

    legend:Show()

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
            line.frame:SetHeight(ROW_HEIGHT)
            
            -- TEXTO IZQUIERDA ARRIBA: Nombre
            line.name = line.frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            line.name:SetPoint("TOPLEFT", line.frame, "TOPLEFT", EDGE_MARGIN, -2)
            line.name:SetJustifyH("LEFT")
            ApplyOutline(line.name)

            -- TEXTO IZQUIERDA ABAJO: Sub-texto (Standing de reputación)
            line.subName = line.frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            line.subName:SetPoint("BOTTOMLEFT", line.frame, "BOTTOMLEFT", EDGE_MARGIN, 2)
            line.subName:SetJustifyH("LEFT")
            ApplyOutline(line.subName)

            -- TEXTO DERECHA ARRIBA: Porcentaje
            line.pct = line.frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            line.pct:SetPoint("TOPRIGHT", line.frame, "TOPRIGHT", -EDGE_MARGIN, -2)
            line.pct:SetJustifyH("RIGHT")
            ApplyOutline(line.pct)

            -- TEXTO DERECHA ABAJO: Valores absolutos
            line.abs = line.frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            line.abs:SetPoint("BOTTOMRIGHT", line.frame, "BOTTOMRIGHT", -EDGE_MARGIN, 2)
            line.abs:SetJustifyH("RIGHT")
            line.abs:SetTextColor(0.8, 0.8, 0.8)
            ApplyOutline(line.abs)

            table.insert(legend.lines, line)
        end

        line.frame:ClearAllPoints()
        line.frame:SetPoint("TOPLEFT", legend, "TOPLEFT", 0, -((lineIndex - 1) * ROW_HEIGHT) - PADDING)
        line.frame:SetPoint("RIGHT", legend, "RIGHT", 0, 0)

        local displayName = barObj.displayName or entry.key
        local subNameText = ""

        if entry.key == "Rep" and barObj.standing then
            subNameText = barObj.standing
        end

        line.name:SetText(displayName)
        line.subName:SetText(subNameText)
        
        local c = barObj.color or {}
        local r = type(c.r) == "number" and c.r or 1
        local g = type(c.g) == "number" and c.g or 1
        local b = type(c.b) == "number" and c.b or 1
        
        line.name:SetTextColor(r, g, b)
        line.subName:SetTextColor(r * 0.85, g * 0.85, b * 0.85)

        line.pct:SetText(string.format("%.1f%%", type(barObj.percentage) == "number" and barObj.percentage or 0))
        
        local currentText = dataText:FormatValue(barObj.current or 0, profile)
        local maxText = dataText:FormatValue(barObj.max or 1, profile)
        line.abs:SetText(string.format("%s / %s", currentText or "0", maxText or "1"))

        local rightSideWidth = math.max(line.pct:GetStringWidth() or 0, line.abs:GetStringWidth() or 0)
        local leftSideWidth = math.max(line.name:GetStringWidth() or 0, line.subName:GetStringWidth() or 0)
        line.currentWidth = leftSideWidth + INTERNAL_GAP + rightSideWidth + (EDGE_MARGIN * 2)

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
    local finalHeight = ((lineIndex - 1) * ROW_HEIGHT) + (PADDING * 2)

    legend:SetSize(finalWidth, finalHeight)
    UpdateAlphas()
end