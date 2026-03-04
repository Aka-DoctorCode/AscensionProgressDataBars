-------------------------------------------------------------------------------
-- Project: AscensionBars
-- Author: Aka-DoctorCode
-- File: Dev.lua
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
---@field registeredElements table
local ascensionBars = LibStub("AceAddon-3.0"):GetAddon(addonName)
---@cast ascensionBars AscensionBars

local devStatus = {
    width = 280,
    height = 500,
    top = 500,
    left = 500,
}

---@type AceGUI
local aceGui = LibStub("AceGUI-3.0")

local selectedElementID = "GLOBAL"

function ascensionBars:populateDevPanelContents(devFrame)
    devFrame:ReleaseChildren()

    -- Dropdown for element selection
    local elementSelector = aceGui:Create("Dropdown")
    elementSelector:SetLabel("Select Element to Edit")
    elementSelector:SetWidth(240)

    local dropdownList = { ["GLOBAL"] = "Global menuStyle" }

    -- Ensure registered elements are included
    if self.registeredElements then
        for elementID, _ in pairs(self.registeredElements) do
            dropdownList[elementID] = "Element: " .. elementID
        end
    end

    -- Include any existing saved elements just in case
    if self.db and self.db.profile and self.db.profile.elementStyles then
        for elementID, _ in pairs(self.db.profile.elementStyles) do
            dropdownList[elementID] = "Element: " .. elementID
        end
    end
    elementSelector:SetList(dropdownList)
    elementSelector:SetValue(selectedElementID)

    elementSelector:SetCallback("OnValueChanged", function(_, _, key)
        selectedElementID = key
        self:refreshDevPanel()
    end)
    devFrame:AddChild(elementSelector)

    ---@type AceScrollFrame
    local scroll = aceGui:Create("ScrollFrame")
    scroll:SetLayout("List")
    scroll:SetFullWidth(true)
    scroll:SetFullHeight(true)
    devFrame:AddChild(scroll)

    local targetTable
    local elementType = "GLOBAL"
    if selectedElementID == "GLOBAL" then
        targetTable = self.menuStyle
    else
        self.db.profile.elementStyles = self.db.profile.elementStyles or {}
        self.db.profile.elementStyles[selectedElementID] = self.db.profile.elementStyles[selectedElementID] or {}
        targetTable = self.db.profile.elementStyles[selectedElementID]
        if self.registeredElements and self.registeredElements[selectedElementID] then
            elementType = self.registeredElements[selectedElementID]
        end
    end

    if type(self.menuStyle) ~= "table" then return end

    local elementProperties = {
        ["GLOBAL"] = nil, -- Show all
        ["Header"] = { ["uiHeaderSize"] = true, ["uiHeaderColor"] = true, ["headerSpacing"] = true, ["contentPadding"] = true },
        ["Label"] = { ["text_light"] = true, ["labelSpacing"] = true, ["contentPadding"] = true },
        ["Checkbox"] = { ["checkboxSize"] = true, ["checkboxSpacing"] = true, ["textColor"] = true, ["contentPadding"] = true },
        ["Slider"] = { ["sliderSpacing"] = true, ["sliderWidth"] = true, ["contentPadding"] = true },
        ["ColorPicker"] = { ["colorPickerSize"] = true, ["colorPickerSpacing"] = true, ["contentPadding"] = true },
        ["Dropdown"] = { ["dropdownWidth"] = true, ["dropdownHeight"] = true, ["contentPadding"] = true },
    }

    local allowedKeys = elementProperties[elementType]
    if elementType ~= "GLOBAL" and allowedKeys == nil then
        -- Unknown element type registered, don't filter.
        allowedKeys = nil
    end

    local keys = {}
    for k in pairs(self.menuStyle) do
        if not allowedKeys or allowedKeys[k] then
            table.insert(keys, k)
        end
    end
    table.sort(keys)

    for _, key in ipairs(keys) do
        local value = targetTable[key]
        local displayValue = value
        local isInherited = false

        if displayValue == nil and selectedElementID ~= "GLOBAL" then
            displayValue = self.menuStyle[key]
            isInherited = true
        end

        local titleText = key
        if isInherited then
            titleText = key .. " (Inherited)"
        elseif selectedElementID ~= "GLOBAL" then
            titleText = key .. " (Override)"
        end

        ---@type AceInlineGroup
        local group = aceGui:Create("InlineGroup")
        group:SetTitle(titleText)
        group:SetFullWidth(true)
        group:SetLayout("Flow")

        local function triggerUpdate()
            if self.updateDisplay then self:updateDisplay() end
            if self.refreshConfigUI and self.configFrame and self.configFrame:IsShown() then
                self:refreshConfigUI()
            end
        end

        if type(displayValue) == "number" or (displayValue == nil and type(self.menuStyle[key]) == "number") then
            ---@type AceEditBox
            local edit = aceGui:Create("EditBox")
            edit:SetWidth(80)
            edit:SetText(displayValue and tostring(displayValue) or "")
            edit:SetCallback("OnEnterPressed", function(_, _, val)
                local num = tonumber(val)
                if num then
                    targetTable[key] = num
                    triggerUpdate()
                    self:refreshDevPanel()
                end
            end)
            group:AddChild(edit)

            ---@type AceButton
            local minus = aceGui:Create("Button")
            minus:SetText("-")
            minus:SetWidth(40)
            minus:SetCallback("OnClick", function()
                local newVal = (targetTable[key] or self.menuStyle[key] or 0) - 1
                targetTable[key] = newVal
                triggerUpdate()
                self:refreshDevPanel()
            end)
            group:AddChild(minus)

            ---@type AceButton
            local plus = aceGui:Create("Button")
            plus:SetText("+")
            plus:SetWidth(40)
            plus:SetCallback("OnClick", function()
                local newVal = (targetTable[key] or self.menuStyle[key] or 0) + 1
                targetTable[key] = newVal
                triggerUpdate()
                self:refreshDevPanel()
            end)
            group:AddChild(plus)
        elseif type(displayValue) == "table" and #displayValue >= 3 then
            -- Recognize this as a Color Table
            ---@type AceColorPicker
            local colorPicker = aceGui:Create("ColorPicker")
            colorPicker:SetHasAlpha(true)
            colorPicker:SetColor(displayValue[1], displayValue[2], displayValue[3], displayValue[4] or 1)
            colorPicker:SetCallback("OnValueConfirmed", function(_, _, r, g, b, a)
                targetTable[key] = { r, g, b, a }
                triggerUpdate()
                self:refreshDevPanel()
            end)
            group:AddChild(colorPicker)
        end

        -- Add clear override button if overridden
        if selectedElementID ~= "GLOBAL" and not isInherited then
            local clearBtn = aceGui:Create("Button")
            clearBtn:SetText("Reset")
            clearBtn:SetWidth(60)
            clearBtn:SetCallback("OnClick", function()
                targetTable[key] = nil
                triggerUpdate()
                self:refreshDevPanel()
            end)
            group:AddChild(clearBtn)
        end

        if type(self.menuStyle[key]) == "number" or type(self.menuStyle[key]) == "table" then
            scroll:AddChild(group)
        end
    end
end

function ascensionBars:openDevPanel()
    if not self.configFrame then
        -- Force initialize Config UI invisibly so factory functions register elementIDs
        self:toggleConfig()
        if self.panels then
            for i, panel in ipairs(self.panels) do
                if panel.UpdateLayout then
                    panel.UpdateLayout()
                end
            end
        end
        if self.configFrame then
            self.configFrame:Hide()
        end
    end

    if self.devFrame then
        self.devFrame:Hide()
        self.devFrame = nil
        return
    end

    ---@type AceFrame
    local devFrame = aceGui:Create("Frame")
    self.devFrame = devFrame
    devFrame:SetStatusTable(devStatus)
    devFrame:SetTitle("AB - Dev Style Tweak")
    devFrame:SetLayout("Flow")
    devFrame:SetCallback("OnClose", function(widget)
        aceGui:Release(widget)
        self.devFrame = nil
    end)

    self:populateDevPanelContents(devFrame)
end

function ascensionBars:refreshDevPanel()
    if self.devFrame then
        self:populateDevPanelContents(self.devFrame)
    end
end

-- Slash command to open dev panel
SLASH_ABDEV1 = "/abdev"
SlashCmdList["ABDEV"] = function()
    if ascensionBars then
        ascensionBars:openDevPanel()
    end
end
