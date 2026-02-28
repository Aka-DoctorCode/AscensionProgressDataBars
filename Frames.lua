-------------------------------------------------------------------------------
-- Project: AscensionBars
-- Author: Aka-DoctorCode
-- File: Frames.lua
-- Version: @project-version@
-------------------------------------------------------------------------------
-- Copyright (c) 2025–2026 Aka-DoctorCode. All Rights Reserved.
--
-- This software and its source code are the exclusive property of the author.
-- No part of this file may be copied, modified, redistributed, or used in
-- derivative works without express written permission.
-------------------------------------------------------------------------------

---@type AscensionBars
local AB = LibStub("AceAddon-3.0"):GetAddon("AscensionBars")
local texturePool = {}

function AB:CreateFrames()
    self.textHolders = {}
    for i = 1, 3 do
        local key = "T" .. i
        local holder = CreateFrame("Frame", "AscensionBars_TextHolder" .. key, UIParent)
        holder:SetFrameStrata("HIGH")
        holder:SetClipsChildren(false)
        holder:SetHeight(20)
        holder:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
        self.textHolders[key] = holder
    end
    self.textHolder = self.textHolders.T1 -- Backward compatibility
    if not self.HoverFrame then
        self.HoverFrame = CreateFrame("Frame", "AscensionBars_HoverFrame", UIParent)
        self.HoverFrame:SetAllPoints(UIParent)
        self.HoverFrame:SetFrameStrata("BACKGROUND")
        self.HoverFrame:EnableMouse(false) -- Disable mouse to prevent blocking clicks
    end
    self.XP = self:CreateBar("AscensionXPBar_XP")
    self.Rep = self:CreateBar("AscensionXPBar_Rep")
    self.Honor = self:CreateBar("AscensionXPBar_Honor")
    self.HouseXp = self:CreateBar("AscensionXPBar_HouseXp")
    self.Azerite = self:CreateBar("AscensionXPBar_Azerite")
    if self.Honor and self.Honor.bar then self.Honor.bar:Hide() end
    if self.HouseXp and self.HouseXp.bar then self.HouseXp.bar:Hide() end
    if self.Azerite and self.Azerite.bar then self.Azerite.bar:Hide() end
    self.paragonText = self.textHolder:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
end

function AB:CreateBar(name)
    local CONSTANTS = AB.constants
    local bar = CreateFrame("StatusBar", name, UIParent)
    bar:SetFrameStrata("LOW")
    bar:EnableMouse(true)
    bar:SetScript("OnEnter", function()
        self.state.isHovering = true
        self:UpdateVisibility()
    end)
    bar:SetScript("OnLeave", function()
        self.state.isHovering = false
        self:UpdateVisibility()
    end)
    bar:SetStatusBarTexture(CONSTANTS.TEXTURE_BAR)
    bar:SetClipsChildren(true)
    local bg = self:AcquireTexture(bar)
    bg:SetAllPoints()
    bg:SetTexture(CONSTANTS.TEXTURE_BAR)
    bg:SetVertexColor(0, 0, 0, self.db.profile.backgroundAlpha or 0.5)
    bg:SetDrawLayer("BACKGROUND", -1)
    local spark = bar:CreateTexture(nil, "ARTWORK")
    spark:SetTexture(CONSTANTS.TEXTURE_SPARK)
    spark:SetSize(6, 6)
    spark:SetBlendMode("ADD")
    local rested = (name == "AscensionXPBar_XP") and bar:CreateTexture(nil, "ARTWORK") or nil
    local txFrame = CreateFrame("Frame", nil, self.textHolder)
    txFrame:SetSize(AB.constants.MIN_TEXT_WIDTH, 20)
    local text = txFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    text:SetAllPoints()
    return {
        bar = bar,
        spark = spark,
        txFrame = txFrame,
        text = text,
        restedOverlay = rested,
        background = bg
    }
end

function AB:AcquireTexture(parent)
    for i = 1, #texturePool do
        if not texturePool[i]:IsShown() and texturePool[i]:GetParent() == parent then
            texturePool[i]:Show()
            return texturePool[i]
        end
    end
    local tex = parent:CreateTexture(nil, "BACKGROUND")
    table.insert(texturePool, tex)
    return tex
end

function AB:CleanupTextures()
    for i = 1, #texturePool do
        texturePool[i]:Hide()
    end
end
