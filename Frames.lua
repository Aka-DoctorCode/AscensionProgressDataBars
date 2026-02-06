-------------------------------------------------------------------------------
-- Project: AscensionBars
-- Author: Aka-DoctorCode 
-- File: Frames.lua
-- Version: 20
-------------------------------------------------------------------------------
-- Copyright (c) 2025–2026 Aka-DoctorCode. All Rights Reserved.
--
-- This software and its source code are the exclusive property of the author.
-- No part of this file may be copied, modified, redistributed, or used in 
-- derivative works without express written permission.
-------------------------------------------------------------------------------
local AB = LibStub("AceAddon-3.0"):GetAddon("AscensionBars")

-- Texture pool for performance
local texturePool = {}

function AB:CreateFrames()
    local CONSTANTS = AB.constants
    self.textHolder = CreateFrame("Frame", "AscensionBars_TextHolder", UIParent)
    self.textHolder:SetFrameStrata("HIGH")
    self.textHolder:SetClipsChildren(false)
    self.textHolder:SetHeight(20)

    self.HoverFrame = CreateFrame("Frame", "AscensionBars_HoverFrame", UIParent)
    self.HoverFrame:SetFrameStrata("BACKGROUND")
    self.HoverFrame:EnableMouse(true)
    self.HoverFrame:SetScript("OnEnter", function()
        self.state.isHovering = true
        self:UpdateVisibility()
    end)
    self.HoverFrame:SetScript("OnLeave", function()
        self.state.isHovering = false
        self:UpdateVisibility()
    end)

    self.XP = self:CreateBar("AscensionXPBar_XP")
    self.Rep = self:CreateBar("AscensionXPBar_Rep")
    self.paragonText = self.textHolder:CreateFontString(nil, "OVERLAY", "GameFontNormal")
end

function AB:CreateBar(name)
    local CONSTANTS = AB.constants
    local bar = CreateFrame("StatusBar", name, UIParent)
    bar:SetFrameStrata("LOW")
    bar:SetStatusBarTexture(CONSTANTS.TEXTURE_BAR)
    bar:SetClipsChildren(true)

    -- Use texture pool for background
    local bg = self:AcquireTexture(bar)
    bg:SetAllPoints(true)
    bg:SetTexture(CONSTANTS.TEXTURE_BAR)
    bg:SetVertexColor(0, 0, 0, self.db.profile.backgroundAlpha or 0.5)
    bg:SetDrawLayer("BACKGROUND", -1)

    local spark = bar:CreateTexture(nil, "ARTWORK")
    spark:SetTexture(CONSTANTS.TEXTURE_SPARK)
    spark:SetSize(6, 6)
    spark:SetBlendMode("ADD")

    local rested = (name == "AscensionXPBar_XP") and bar:CreateTexture(nil, "ARTWORK") or nil

    local txFrame = CreateFrame("Frame", nil, self.textHolder)
    local text = txFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    text:SetAllPoints(true)

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
    -- Clean up textures from pool
    for i = 1, #texturePool do
        texturePool[i]:Hide()
    end
end
