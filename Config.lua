-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
-- Author: Aka-DoctorCode
-- File: Config.lua
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
local ascensionBars = addonTable.main or LibStub("AceAddon-3.0"):GetAddon(addonName)
local locales = LibStub("AceLocale-3.0"):GetLocale("AscensionBars")
local colors = ascensionBars.colors
local files = ascensionBars.files
local menuStyle = ascensionBars.menuStyle
local layoutFactory = addonTable.layoutFactory

local function createConfigFrame()
    if not layoutFactory then return end
    if ascensionBars.configFrame then return end

    ---@cast ascensionBars AscensionBars
    ascensionBars.configFrame = CreateFrame("Frame", "AscensionBarsConfigFrame", _G.UIParent, "BackdropTemplate")
    ---@class ConfigFrame : Frame, BackdropTemplate
    local configFrame = ascensionBars.configFrame
    ---@cast configFrame ConfigFrame
    configFrame:SetSize(ascensionBars.normalWidth or 850, ascensionBars.normalHeight or 500)
    configFrame:SetPoint("CENTER")
    configFrame:SetMovable(true)
    configFrame:EnableMouse(true)
    configFrame:RegisterForDrag("LeftButton")
    configFrame:SetScript("OnDragStart", configFrame.StartMoving)
    configFrame:SetScript("OnDragStop", configFrame.StopMovingOrSizing)
    
    configFrame:SetResizable(true)
    configFrame:SetResizeBounds(400, 300)
    configFrame:SetFrameStrata("TOOLTIP")
    
    configFrame:SetBackdrop({
        bgFile = files.bgFile,
        edgeFile = files.edgeFile,
        edgeSize = menuStyle.backdropEdgeSize,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    configFrame:SetBackdropColor(unpack(colors.backgroundDark)) -- #050508
    configFrame:SetBackdropBorderColor(unpack(colors.surfaceHighlight)) -- #2A243D

    local title = configFrame:CreateFontString(nil, "OVERLAY", menuStyle.headerFont)
    title:SetPoint("TOPLEFT", menuStyle.titleLeft, menuStyle.titleTop)
    title:SetText(locales["ADDON_NAME"])
    title:SetTextColor(unpack(colors.gold)) -- #FFCC33

    local closeButton = CreateFrame("Button", nil, configFrame, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", configFrame, "TOPRIGHT", -4, -4)

    local resizeGrip = CreateFrame("Button", nil, configFrame)
    resizeGrip:SetPoint("BOTTOMRIGHT", configFrame, "BOTTOMRIGHT", -6, 6)
    resizeGrip:SetSize(16, 16)
    resizeGrip:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    resizeGrip:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    resizeGrip:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    
    resizeGrip:SetScript("OnMouseDown", function(_, button)
        if button == "LeftButton" then configFrame:StartSizing("BOTTOMRIGHT") end
    end)
    
    resizeGrip:SetScript("OnMouseUp", function()
        configFrame:StopMovingOrSizing()
        if ascensionBars.configTabs and ascensionBars.configTabs.getActiveTab then
            ascensionBars.configTabs.selectTab(ascensionBars.configTabs.getActiveTab())
        end
    end)

    local resetButton = CreateFrame("Button", nil, configFrame, "UIPanelButtonTemplate")
    resetButton:SetSize(130, menuStyle.buttonHeight)
    resetButton:SetPoint("BOTTOMLEFT", menuStyle.contentPadding, menuStyle.contentPadding + 24)
    resetButton:SetText(locales["FACTION_STANDINGS_RESET"])
    resetButton:SetScript("OnClick", function()
        if ascensionBars.db then
            ascensionBars.db:ResetProfile()
            ascensionBars:updateDisplay()
            ascensionBars.configTabs.selectTab(1)
        end
    end)

    local configModeCheck = CreateFrame("CheckButton", nil, configFrame, "UICheckButtonTemplate")
        configModeCheck:SetPoint("BOTTOMLEFT", menuStyle.contentPadding, 8)
        configModeCheck:SetSize(menuStyle.checkboxSize, menuStyle.checkboxSize)
        configModeCheck.text = configModeCheck:CreateFontString(nil, "OVERLAY", menuStyle.labelFont)
        configModeCheck.text:SetPoint("LEFT", configModeCheck, "RIGHT", 5, 0)
        configModeCheck.text:SetText(locales["CONFIG_MODE"])
        configModeCheck:SetChecked(ascensionBars.state.isConfigMode)
        
        configModeCheck:SetScript("OnClick", function(self)
            -- Update the state and refresh the bars
            ascensionBars.state.isConfigMode = self:GetChecked()
            ascensionBars:updateDisplay(true)
        end)
    
        -- Sync checkbox state whenever the frame is shown
        configFrame:HookScript("OnShow", function()
            configModeCheck:SetChecked(ascensionBars.state.isConfigMode)
        end)

    local tabNames = {
        locales["TAB_BARS_LAYOUT"],
        locales["TAB_TEXT_LAYOUT"],
        locales["TAB_BEHAVIOR"],
        locales["TAB_COLORS"],
        locales["TAB_PARAGON_ALERTS"]
    }
    
    local buildFuncs = {
        function(panel) if addonTable.barsLayoutTab then addonTable.barsLayoutTab:build(panel) end end,
        function(panel) if addonTable.textLayoutTab then addonTable.textLayoutTab:build(panel) end end,
        function(panel) if addonTable.behaviorTab then addonTable.behaviorTab:build(panel) end end,
        function(panel) if addonTable.colorsTab then addonTable.colorsTab:build(panel) end end,
        function(panel) if addonTable.paragonAlertsTab then addonTable.paragonAlertsTab:build(panel) end end
    }

    ascensionBars.configTabs = layoutFactory:createTabbedInterface(configFrame, tabNames, buildFuncs, 1)
    configFrame:Hide()
end

function ascensionBars:refreshConfigUI()
    if not self.configFrame then
        createConfigFrame()
    end

    if self.configFrame then
        local wasShown = self.configFrame:IsShown()
        local currentTab = self.configTabs and self.configTabs.getActiveTab() or 1

        -- Reset current frame to apply changes
        self.configFrame:Hide()
        self.configFrame = nil
        self.configTabs = nil

        -- Re-initialize
        createConfigFrame()

        if wasShown then
            self.configFrame:Show()
            if self.configTabs and self.configTabs.selectTab then
                self.configTabs.selectTab(currentTab)
            end
        end
    end
end

function ascensionBars:refreshConfig() 
    self:refreshConfigUI() 
end
