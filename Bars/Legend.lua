-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
-- Author: Aka-DoctorCode
-- File: Legend.lua
-- Version: @project-version@
-------------------------------------------------------------------------------

local addonName, addonTable = ...
---@class AscensionBars
local ascensionBars = LibStub("AceAddon-3.0"):GetAddon(addonName)
local locales = LibStub("AceLocale-3.0"):GetLocale("AscensionBars")
local dataText = addonTable.dataText

-------------------------------------------------------------------------------
-- LEGEND MODULE (Frameless, Smart, Interactive)
-------------------------------------------------------------------------------

local legend = CreateFrame("Frame", "AscensionBars_Legend", UIParent)
legend:SetSize(200, 100)
legend:SetPoint("RIGHT", UIParent, "RIGHT", -20, 0)
legend:SetMovable(true)
legend:EnableMouse(true)
legend:SetFrameStrata("TOOLTIP")
legend:SetClipsChildren(false)

-- Sombra proyectada (efecto vidrio)
local shadow = legend:CreateTexture(nil, "BACKGROUND")
shadow:SetPoint("TOPLEFT", -5, 5)
shadow:SetPoint("BOTTOMRIGHT", 5, -5)
shadow:SetColorTexture(0, 0, 0, 0.3)
shadow:SetDrawLayer("BACKGROUND", -1)

-- Sin fondo ni borde
-- legend:SetBackdrop(nil)

legend.lines = {}  -- tabla de líneas { left, right, barObj }

local lineHeight = 20
local padding = 8

-- Actualización de la leyenda
function ascensionBars:updateLegend()
    local profile = self.db and self.db.profile
    if not profile then return end
    if not profile.legendEnabled then
        legend:Hide()
        return
    end

    legend:Show()

    local bars = {
        { obj = self.xp,      key = "XP" },
        { obj = self.rep,     key = "Rep" },
        { obj = self.honor,   key = "Honor" },
        { obj = self.houseXp, key = "HouseXp" },
        { obj = self.azerite, key = "Azerite" }
    }

    local lineIndex = 1
    for _, entry in ipairs(bars) do
        local barObj = entry.obj
        if barObj and barObj.bar and barObj.bar:IsShown() then
            -- Obtener o crear la línea
            local line = legend.lines[lineIndex]
            if not line then
                line = {}
                line.frame = CreateFrame("Frame", nil, legend)
                line.frame:SetSize(legend:GetWidth(), lineHeight)
                line.frame:SetPoint("TOPLEFT", 0, -(lineIndex-1)*lineHeight - padding)

                line.left = line.frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                line.left:SetPoint("LEFT", 4, 0)
                line.left:SetJustifyH("LEFT")

                line.right = line.frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
                line.right:SetPoint("RIGHT", -4, 0)
                line.right:SetJustifyH("RIGHT")

                -- Hover en la línea
                line.frame:EnableMouse(true)
                line.frame:SetScript("OnEnter", function()
                    -- Cambiar el texto derecho a valores absolutos
                    if line.barObj then
                        local current = line.barObj.current or 0
                        local max = line.barObj.max or 1
                        local formatted = string.format("%s / %s",
                            dataText:FormatValue(current, profile),
                            dataText:FormatValue(max, profile))
                        line.right:SetText(formatted)
                    end
                end)
                line.frame:SetScript("OnLeave", function()
                    -- Volver al porcentaje
                    if line.barObj then
                        line.right:SetText(string.format("%.1f%%", line.barObj.percentage or 0))
                    end
                end)

                table.insert(legend.lines, line)
            end

            line.barObj = barObj

            -- Texto izquierdo: nombre con color de la barra
            local leftText
            if entry.key == "XP" then
                leftText = barObj.displayName or "XP"
            elseif entry.key == "Rep" then
                leftText = barObj.displayName or "Rep"
                if barObj.standing then
                    leftText = leftText .. " (" .. barObj.standing .. ")"
                end
            elseif entry.key == "Honor" then
                leftText = barObj.displayName or "Honor"
            elseif entry.key == "HouseXp" then
                leftText = barObj.displayName or "House"
            elseif entry.key == "Azerite" then
                leftText = barObj.displayName or "Azerite"
            end

            local color = barObj.color or { r=1, g=1, b=1 }
            line.left:SetText(leftText)
            line.left:SetTextColor(color.r, color.g, color.b)

            -- Texto derecho: porcentaje por defecto
            line.right:SetText(string.format("%.1f%%", barObj.percentage or 0))
            line.right:SetTextColor(0.9, 0.9, 0.9)  -- blanco grisáceo

            line.frame:Show()
            lineIndex = lineIndex + 1
        end
    end

    -- Ocultar líneas sobrantes
    for i = lineIndex, #legend.lines do
        legend.lines[i].frame:Hide()
    end

    -- Ajustar altura del marco
    local totalHeight = padding * 2 + (lineIndex - 1) * lineHeight
    legend:SetHeight(totalHeight)

    -- Opacidad base 60%, 100% al hacer hover
    legend:SetAlpha(0.6)
end

-- Hover en la leyenda completa
legend:SetScript("OnEnter", function()
    legend:SetAlpha(1.0)
    if ascensionBars.state then
        ascensionBars.state.legendHovered = true
        ascensionBars:updateVisibility()
    end
end)

legend:SetScript("OnLeave", function()
    legend:SetAlpha(0.6)
    if ascensionBars.state then
        ascensionBars.state.legendHovered = false
        ascensionBars:updateVisibility()
    end
end)

-- Actualización cuando cambia el ancho del marco (por si el usuario redimensiona)
legend:SetScript("OnSizeChanged", function(self, width, height)
    if width and width > 0 then
        local numLines = #legend.lines
        for i, line in ipairs(legend.lines) do
            line.frame:SetWidth(width)
        end
    end
end)
