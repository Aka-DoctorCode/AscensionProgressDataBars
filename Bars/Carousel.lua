-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
-- Author: Aka-DoctorCode
-- File: Bars/Carousel.lua
-- Version: @project-version@
-------------------------------------------------------------------------------

local addonName, addonTable = ...
---@class AscensionBars
local ascensionBars = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale("AscensionBars")
local dataText = addonTable.dataText

-------------------------------------------------------------------------------
-- Colores semánticos (igual que en la leyenda, pero podemos obtenerlos de las barras)
-------------------------------------------------------------------------------
local function getBarColor(barKey)
    local barObj = ascensionBars[barKey]
    if barObj and barObj.color then
        return barObj.color
    end
    -- Fallbacks
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
local batchData = {}               -- Acumulador: [categoría][subId] = { label, amount }
local dynamicQueue = {}            -- Cola de mensajes dinámicos listos para mostrar
local fixedMessages = {}           -- Lista de mensajes fijos activos
local fixedIndex = 1
local currentMessage = {
    text = "",
    color = { r = 1, g = 1, b = 1 },
    isDynamic = false,
    timer = nil,
}
local isPaused = false
local inCombat = false

-- Temporizadores
local batchTimer = nil
local displayTimer = nil
local fixedRotationTimer = nil

-------------------------------------------------------------------------------
-- Marco del carrusel
-------------------------------------------------------------------------------
local carousel = CreateFrame("Frame", "AscensionBars_Carousel", UIParent)
carousel:SetSize(500, 30)
carousel:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 80)
carousel:SetFrameStrata("TOOLTIP")
carousel:EnableMouse(true)
carousel:SetClipsChildren(false)

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
    -- No cancelamos batchTimer aquí porque lo gestionamos aparte
end

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
    -- Reanudar la rotación
    if currentMessage.text ~= "" then
        startDisplayTimer()
    else
        showNextMessage()
    end
end

local function startDisplayTimer(duration)
    if isPaused then return end
    clearTimers()
    local time = duration or (currentMessage.isDynamic and 5 or 7)
    displayTimer = C_Timer.NewTimer(time, function()
        if isPaused then return end
        -- Mensaje actual terminado
        if currentMessage.isDynamic then
            -- Mostrar siguiente dinámico si hay
            if #dynamicQueue > 0 then
                local nextMsg = table.remove(dynamicQueue, 1)
                currentMessage.isDynamic = true
                currentMessage.text = nextMsg.text
                setTextColor(nextMsg.color)
                text:SetText(currentMessage.text)
                startDisplayTimer(5)
            else
                -- No más dinámicos, pasar a fijos
                showNextFixed()
            end
        else
            -- Mensaje fijo terminado, siguiente fijo
            showNextFixed()
        end
    end)
end

-- Procesa el lote acumulado y genera mensajes en la cola dinámica
local function processBatch()
    batchTimer = nil

    -- Convertir batchData en mensajes
    for category, subs in pairs(batchData) do
        for subId, data in pairs(subs) do
            local amount = data.amount
            if amount > 0 then
                local label = data.label
                local color
                if category == "REP" then
                    color = getBarColor("rep")  -- Usamos el color de la barra de reputación (podría ser por facción si quisiéramos)
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

    -- Limpiar batch
    batchData = {}

    -- Si no hay mensaje actual, mostrar el primero de la cola
    if currentMessage.text == "" and #dynamicQueue > 0 then
        local first = table.remove(dynamicQueue, 1)
        currentMessage.isDynamic = true
        currentMessage.text = first.text
        setTextColor(first.color)
        text:SetText(currentMessage.text)
        startDisplayTimer(5)
    end
    -- Si ya hay mensaje actual, los mensajes ya están en cola y se mostrarán después
end

-- Inicia o reinicia el temporizador de lote
local function resetBatchTimer()
    if batchTimer then
        batchTimer:Cancel()
    end
    local profile = ascensionBars.db and ascensionBars.db.profile
    local delay = (profile and profile.carouselBatchDelay) or 1.5
    batchTimer = C_Timer.NewTimer(delay, processBatch)
end

-------------------------------------------------------------------------------
-- API pública: pushCarouselEvent
-------------------------------------------------------------------------------
function ascensionBars:pushCarouselEvent(category, subId, label, amount)
    local profile = self.db and self.db.profile
    if not profile or not profile.carouselEnabled or not amount or amount == 0 then return end

    -- Inicializar acumulador si no existe
    if not batchData[category] then
        batchData[category] = {}
    end
    if not batchData[category][subId] then
        batchData[category][subId] = { label = label, amount = 0 }
    end
    batchData[category][subId].amount = batchData[category][subId].amount + amount

    -- Iniciar o reiniciar el temporizador de lote
    resetBatchTimer()

    -- Si estamos en combate, ajustar opacidad (ya se hace en updateCarouselCombatState)
end

-------------------------------------------------------------------------------
-- Mensajes fijos (Paragon, Housing)
-------------------------------------------------------------------------------
function ascensionBars:updateFixedMessages()
    local profile = self.db and self.db.profile
    if not profile then return end

    fixedMessages = {}

    -- Paragon reward pendiente
    if self.paragonText and self.paragonText:GetText() ~= "" then
        local rawText = self.paragonText:GetText():gsub("|c%x+", ""):gsub("|r", "")
        table.insert(fixedMessages, {
            text = rawText,
            color = { r = 0.0, g = 1.0, b = 0.0 }, -- Verde puro
            id = "PARAGON"
        })
    end

    -- House upgrade disponible
    if self.houseRewardText and self.houseRewardText:GetText() ~= "" then
        local rawText = self.houseRewardText:GetText():gsub("|c%x+", ""):gsub("|r", "")
        table.insert(fixedMessages, {
            text = rawText,
            color = { r = 1.0, g = 0.5, b = 0.1 }, -- Ocre
            id = "HOUSE"
        })
    end

    -- Si no hay mensaje actual y hay fijos, mostrar el primero
    if currentMessage.text == "" and #fixedMessages > 0 and #dynamicQueue == 0 then
        fixedIndex = 1
        showNextFixed()
    end
end

local function showNextFixed()
    if isPaused then return end
    if #dynamicQueue > 0 then
        -- Prioridad a dinámicos
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

    -- Rotar
    fixedIndex = fixedIndex + 1
    if fixedIndex > #fixedMessages then fixedIndex = 1 end
    local msg = fixedMessages[fixedIndex]
    currentMessage.isDynamic = false
    currentMessage.text = msg.text
    setTextColor(msg.color)
    text:SetText(msg.text)
    startDisplayTimer(7)
end

-------------------------------------------------------------------------------
-- Mostrar el siguiente mensaje (usado al reanudar)
-------------------------------------------------------------------------------
local function showNextMessage()
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
-- Inicialización y visibilidad
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