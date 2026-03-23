-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
-- Author: Aka-DoctorCode
-- File: Bars/Carousel.lua
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
local L = LibStub("AceLocale-3.0"):GetLocale("AscensionBars")
local dataText = addonTable.dataText

-------------------------------------------------------------------------------
-- Colores semánticos
-------------------------------------------------------------------------------
local function getBarColor(barKey)
    local barObj = ascensionBars[barKey]
    if barObj and barObj.color then
        return barObj.color
    end
    if barKey == "xp" then return { r = 0.0, g = 0.4, b = 0.9 } end
    if barKey == "rep" then return { r = 0.0, g = 1.0, b = 0.0 } end
    if barKey == "honor" then return { r = 0.8, g = 0.2, b = 0.2 } end
    if barKey == "houseXp" then return { r = 1.0, g = 0.5, b = 0.1 } end
    if barKey == "azerite" then return { r = 0.9, g = 0.8, b = 0.5 } end
    return { r = 1, g = 1, b = 1 }
end

-------------------------------------------------------------------------------
-- Estructuras de datos
-------------------------------------------------------------------------------
local batchData = {}
local dynamicQueue = {}
local fixedMessages = {}
local fixedIndex = 1
local currentMessage = {
    text = "",
    color = { r = 1, g = 1, b = 1 },
    isDynamic = false,
    timer = nil,
}
local isPaused = false
local inCombat = false

local batchTimer = nil
local displayTimer = nil
local fixedRotationTimer = nil

-------------------------------------------------------------------------------
-- Marco del carrusel con fondo y posición configurable
-------------------------------------------------------------------------------
local carousel = CreateFrame("Frame", "AscensionBars_Carousel", UIParent)
carousel:SetSize(500, 30)
carousel:SetFrameStrata("TOOLTIP")
carousel:EnableMouse(true)
carousel:SetClipsChildren(false)

-- Fondo (sombra expandida) similar a la leyenda
local shadow = carousel:CreateTexture(nil, "BACKGROUND")
shadow:SetPoint("TOPLEFT", carousel, "TOPLEFT", -2, 2)
shadow:SetPoint("BOTTOMRIGHT", carousel, "BOTTOMRIGHT", 2, -2)
shadow:SetColorTexture(0, 0, 0, 0.4)  -- alpha se actualizará después

-- Texto
local text = carousel:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
text:SetAllPoints()
text:SetJustifyH("CENTER")
text:SetJustifyV("MIDDLE")
text:SetShadowOffset(1, -1)
text:SetShadowColor(0, 0, 0, 0.8)

local function updateFont()
    local profile = ascensionBars.db and ascensionBars.db.profile
    if not profile then return end
    local fontPath = profile.fontPath or [[Fonts\FRIZQT__.TTF]]
    local outline = profile.fontOutline or "OUTLINE"
    text:SetFont(fontPath, 18, outline)
end
updateFont()

-------------------------------------------------------------------------------
-- Funciones auxiliares
-------------------------------------------------------------------------------
local function setTextColor(color)
    text:SetTextColor(color.r, color.g, color.b)
end

local function clearTimers()
    if displayTimer then displayTimer:Cancel() displayTimer = nil end
    if fixedRotationTimer then fixedRotationTimer:Cancel() fixedRotationTimer = nil end
end

-- Declaración previa de funciones que se llamarán entre sí
local startDisplayTimer
local showNextFixed
local showNextMessage

-- Implementación de startDisplayTimer
startDisplayTimer = function(duration)
    if isPaused then return end
    clearTimers()
    local time = duration or (currentMessage.isDynamic and 5 or 7)
    displayTimer = C_Timer.NewTimer(time, function()
        if isPaused then return end
        if currentMessage.isDynamic then
            if #dynamicQueue > 0 then
                local nextMsg = table.remove(dynamicQueue, 1)
                currentMessage.isDynamic = true
                currentMessage.text = nextMsg.text
                setTextColor(nextMsg.color)
                text:SetText(currentMessage.text)
                startDisplayTimer(5)
            else
                showNextFixed()
            end
        else
            showNextFixed()
        end
    end)
end

-- Implementación de showNextFixed
showNextFixed = function()
    if isPaused then return end
    if #dynamicQueue > 0 then
        local nextMsg = table.remove(dynamicQueue, 1)
        currentMessage.isDynamic = true
        currentMessage.text = nextMsg.text
        setTextColor(nextMsg.color)
        text:SetText(currentMessage.text)
        startDisplayTimer(5)
        return
    end

    if #fixedMessages == 0 then
        text:SetText("")
        currentMessage.text = ""
        clearTimers()
        return
    end

    fixedIndex = fixedIndex + 1
    if fixedIndex > #fixedMessages then fixedIndex = 1 end
    local msg = fixedMessages[fixedIndex]
    currentMessage.isDynamic = false
    currentMessage.text = msg.text
    setTextColor(msg.color)
    text:SetText(msg.text)
    startDisplayTimer(7)
end

-- Implementación de showNextMessage
showNextMessage = function()
    if #dynamicQueue > 0 then
        local msg = table.remove(dynamicQueue, 1)
        currentMessage.isDynamic = true
        currentMessage.text = msg.text
        setTextColor(msg.color)
        text:SetText(msg.text)
        startDisplayTimer(5)
    elseif #fixedMessages > 0 then
        fixedIndex = 1
        showNextFixed()
    else
        text:SetText("")
        currentMessage.text = ""
        clearTimers()
    end
end

-------------------------------------------------------------------------------
-- Control de estado
-------------------------------------------------------------------------------
local function pauseAll()
    isPaused = true
    clearTimers()
end

local function resumeAll()
    isPaused = false
    if inCombat then
        carousel:SetAlpha(0.4)
    else
        carousel:SetAlpha(1)
    end
    if currentMessage.text ~= "" then
        startDisplayTimer()
    else
        showNextMessage()
    end
end

local function processBatch()
    batchTimer = nil

    for category, subs in pairs(batchData) do
        for subId, data in pairs(subs) do
            local amount = data.amount
            if amount > 0 then
                local label = data.label
                local color
                if category == "REP" then
                    color = getBarColor("rep")
                elseif category == "XP" then
                    color = getBarColor("xp")
                elseif category == "HONOR" then
                    color = getBarColor("honor")
                elseif category == "HOUSE" then
                    color = getBarColor("houseXp")
                elseif category == "AZERITE" then
                    color = getBarColor("azerite")
                else
                    color = { r = 1, g = 1, b = 1 }
                end

                local amountStr = dataText:FormatValue(amount, ascensionBars.db.profile)
                local msgText = string.format("+%s %s", amountStr, label)
                table.insert(dynamicQueue, {
                    text = msgText,
                    color = color,
                })
            end
        end
    end

    batchData = {}

    if currentMessage.text == "" and #dynamicQueue > 0 then
        local first = table.remove(dynamicQueue, 1)
        currentMessage.isDynamic = true
        currentMessage.text = first.text
        setTextColor(first.color)
        text:SetText(currentMessage.text)
        startDisplayTimer(5)
    end
end

local function resetBatchTimer()
    if batchTimer then
        batchTimer:Cancel()
    end
    local profile = ascensionBars.db and ascensionBars.db.profile
    local delay = (profile and profile.carouselBatchDelay) or 1.5
    batchTimer = C_Timer.NewTimer(delay, processBatch)
end

-------------------------------------------------------------------------------
-- API pública
-------------------------------------------------------------------------------
function ascensionBars:pushCarouselEvent(category, subId, label, amount)
    local profile = self.db and self.db.profile
    if not profile or not profile.carouselEnabled or not amount or amount == 0 then return end

    if not batchData[category] then
        batchData[category] = {}
    end
    if not batchData[category][subId] then
        batchData[category][subId] = { label = label, amount = 0 }
    end
    batchData[category][subId].amount = batchData[category][subId].amount + amount

    resetBatchTimer()
end

function ascensionBars:updateFixedMessages()
    local profile = self.db and self.db.profile
    if not profile then return end

    fixedMessages = {}

    if self.paragonText then
        local text = self.paragonText:GetText()
        if text and text ~= "" then
            local rawText = text:gsub("|c%x+", ""):gsub("|r", "")
            table.insert(fixedMessages, {
                text = rawText,
                color = { r = 0.0, g = 1.0, b = 0.0 },
                id = "PARAGON"
            })
        end
    end

    if self.houseRewardText then
        local text = self.houseRewardText:GetText()
        if text and text ~= "" then
            local rawText = text:gsub("|c%x+", ""):gsub("|r", "")
            table.insert(fixedMessages, {
                text = rawText,
                color = { r = 1.0, g = 0.5, b = 0.1 },
                id = "HOUSE"
            })
        end
    end

    if currentMessage.text == "" and #fixedMessages > 0 and #dynamicQueue == 0 then
        fixedIndex = 1
        showNextFixed()
    end
end

-------------------------------------------------------------------------------
-- Hover
-------------------------------------------------------------------------------
carousel:SetScript("OnEnter", function()
    pauseAll()
    carousel:SetAlpha(1)
end)

carousel:SetScript("OnLeave", function()
    resumeAll()
end)

-------------------------------------------------------------------------------
-- Sincronización con combate
-------------------------------------------------------------------------------
function ascensionBars:updateCarouselCombatState(combat)
    inCombat = combat
    if combat then
        carousel:SetAlpha(0.4)
    else
        if not isPaused then
            carousel:SetAlpha(1)
        end
    end
end

-------------------------------------------------------------------------------
-- Inicialización y visibilidad (con posición configurable)
-------------------------------------------------------------------------------
function ascensionBars:initCarousel()
    self:RegisterEvent("PLAYER_ENTERING_WORLD", function()
        updateFont()
    end)
    carousel:Hide()
end

function ascensionBars:updateCarouselVisibility()
    local profile = self.db and self.db.profile
    if not profile then return end

    if profile.carouselEnabled then
        -- Aplicar posición desde el perfil (anclado a TOP)
        carousel:ClearAllPoints()
        carousel:SetPoint("TOP", UIParent, "TOP",
            profile.carouselXOffset or 0,
            profile.carouselYOffset or -50)   -- valor por defecto: -50

        -- Aplicar alpha del fondo
        local bgAlpha = profile.carouselBgAlpha
        if bgAlpha == nil then bgAlpha = 0.4 end
        shadow:SetColorTexture(0, 0, 0, bgAlpha)

        carousel:Show()
        self:updateFixedMessages()
    else
        carousel:Hide()
        clearTimers()
        text:SetText("")
        currentMessage.text = ""
    end
end

ascensionBars:initCarousel()
addonTable.carousel = carousel

