-------------------------------------------------------------------------------
-- Project: AscensionProgressDataBars
-- Author: Aka-DoctorCode
-- File: ConfigUtils.lua
-- Version: @project-version@
-------------------------------------------------------------------------------
-- Copyright (c) 2025–2026 Aka-DoctorCode. All Rights Reserved.
--
-- This software and its source code are the exclusive property of the author.
-- No part of this file may be copied, modified, redistributed, or used in
-- derivative works without express written permission.
-------------------------------------------------------------------------------

local addonName, addonTable = ...

-- Object-Oriented module for Config Utilities
addonTable.configUtils = {}
---@type AscensionBars
local ascensionBars = addonTable.main or LibStub("AceAddon-3.0"):GetAddon(addonName)
---@cast ascensionBars AscensionBars
local locales = LibStub("AceLocale-3.0"):GetLocale("AscensionBars")
local configUtils = addonTable.configUtils

-- Extracts the correct block identifier safely
function configUtils:getActualBlock(bar, blockField)
    if not bar then return nil end
    local val = bar[blockField]
    if blockField == "textBlock" and not val then return "T1" end
    if blockField == "block" and not val then return "TOP" end
    return val
end

-- Cleans up and sequentially re-orders bars within a specific layout block
function configUtils:cleanOrders(profile, blockField, orderField, block)
    if not profile or not profile.bars then return end
    
    local temp = {}
    for k, bar in pairs(profile.bars) do
        if self:getActualBlock(bar, blockField) == block then
            table.insert(temp, { key = k, order = bar[orderField] or 99 })
        end
    end
    
    table.sort(temp, function(a, b) return a.order < b.order end)
    
    for i, data in ipairs(temp) do
        profile.bars[data.key][orderField] = i
    end
end

-- Counts the number of elements assigned to a specific layout block
function configUtils:getCount(profile, blockField, block)
    local count = 0
    for _, bar in pairs(profile.bars) do
        if self:getActualBlock(bar, blockField) == block then
            count = count + 1
        end
    end
    return count
end

function configUtils:cleanupContent(contentPanel)
    if not contentPanel then return end
    
    for _, child in ipairs({ contentPanel:GetChildren() }) do
        child:Hide()
        child:ClearAllPoints()
    end
    
    for _, region in ipairs({ contentPanel:GetRegions() }) do
        if region.Hide then region:Hide() end
    end
end

-- Sets a standard GameTooltip for a given UI frame
function configUtils:setTooltip(frame, text)
    if not frame or not text then return end
    
    frame:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(text, 1, 1, 1)
        GameTooltip:Show()
    end)
    
    frame:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end