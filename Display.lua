local AB = LibStub("AceAddon-3.0"):GetAddon("AscensionBars")
local lastUpdate = 0

function AB:UpdateTextAnchors(factionName, isMaxLevel)
    local CONSTANTS = AB.constants
    local profile = self.db.profile
    local effectiveMax = isMaxLevel and not self.state.isConfigMode
    local gap = CONSTANTS.DEFAULT_GAP

    self.XP.txFrame:ClearAllPoints()
    self.Rep.txFrame:ClearAllPoints()
    self.textHolder:ClearAllPoints()
    self.textHolder:SetPoint("TOP", UIParent, "TOP", 0, profile.yOffset - 13.5)

    local w1 = self.XP.text:GetStringWidth() + 5
    local w2 = self.Rep.text:GetStringWidth() + 5
    if w1 < 10 then w1 = CONSTANTS.MIN_TEXT_WIDTH end
    if w2 < 10 then w2 = CONSTANTS.MIN_TEXT_WIDTH end

    if effectiveMax or (not self.state.isConfigMode and not factionName) then
        -- Single bar mode (Max Level or no reputation)
        local target = (effectiveMax and factionName) and self.Rep or self.XP
        self.textHolder:SetWidth(target == self.Rep and w2 or w1)
        target.txFrame:SetAllPoints(self.textHolder)
        target.text:SetJustifyH("CENTER")
    else
        -- Divided bar mode (Config or Leveling)
        self.textHolder:SetWidth(w1 + gap + w2)

        self.XP.txFrame:SetPoint("LEFT", self.textHolder, "LEFT")
        self.XP.txFrame:SetPoint("TOP", self.textHolder, "TOP")
        self.XP.txFrame:SetPoint("BOTTOM", self.textHolder, "BOTTOM")
        self.XP.txFrame:SetWidth(w1)
        self.XP.text:SetJustifyH("LEFT")

        self.Rep.txFrame:SetPoint("LEFT", self.XP.txFrame, "RIGHT", gap, 0)
        self.Rep.txFrame:SetPoint("TOP", self.textHolder, "TOP")
        self.Rep.txFrame:SetPoint("BOTTOM", self.textHolder, "BOTTOM")
        self.Rep.txFrame:SetWidth(w2)
        self.Rep.text:SetJustifyH("LEFT")
    end
end

function AB:UpdateDisplay(force)
    local CONSTANTS = AB.constants
    local now = GetTime()
    local isForce = (force == true) or self.state.isConfigMode

    if not isForce and (now - lastUpdate < CONSTANTS.UPDATE_THROTTLE) then
        if not self.state.updatePending then
            self.state.updatePending = true
            C_Timer.After(CONSTANTS.UPDATE_THROTTLE, function()
                self.state.updatePending = false
                self:UpdateDisplay(true)
            end)
        end
        return
    end
    lastUpdate = now

    self:DebugPrint("UpdateDisplay called")

    local profile = self.db.profile
    local isMax = UnitLevel("player") >= GetMaxPlayerLevel()

    self:UpdateLayout(isMax)
    self:UpdateVisibility()

    if self.state.isConfigMode then
        self:RenderConfig()
        return
    end

    if not isMax then
        local cur, mx = UnitXP("player"), UnitXPMax("player")
        local color = profile.useClassColorXP and self:GetClassColor() or profile.xpBarColor
        self.XP.bar:SetStatusBarColor(color.r, color.g, color.b, 1.0)
        self.XP.bar:SetMinMaxValues(0, mx)
        self.XP.bar:SetValue(cur)

        if profile.sparkEnabled then
            local pct = (mx > 0) and (cur / mx) or 0
            self.XP.spark:SetPoint("CENTER", self.XP.bar, "LEFT", self.XP.bar:GetWidth() * pct, 0)
            self.XP.spark:Show()
        else
            self.XP.spark:Hide()
        end

        if profile.showRestedBar then
            local rested = GetXPExhaustion()
            if rested and rested > 0 then
                local rw = self.XP.bar:GetWidth() * (math.min(cur + rested, mx) / mx)
                self.XP.restedOverlay:SetSize(rw, profile.barHeightXP)
                self.XP.restedOverlay:SetPoint("LEFT", self.XP.bar, "LEFT")
                self.XP.restedOverlay:SetColorTexture(
                    profile.restedBarColor.r,
                    profile.restedBarColor.g,
                    profile.restedBarColor.b,
                    profile.restedBarColor.a
                )
                self.XP.restedOverlay:Show()
            else
                if self.XP.restedOverlay then
                    self.XP.restedOverlay:Hide()
                end
            end
        end
        self.XP.text:SetText(self:FormatXP())
    end

    local name = self:RenderReputation()
    self:UpdateTextAnchors(name, isMax)
end

function AB:RenderReputation()
    local profile = self.db.profile
    local name, reaction, min, max, value, factionID, standingLabel
    local p = self.state.cachedPendingParagons

    if p and #p > 0 then
        local pc = profile.paragonPendingColor
        local hex = string.format("|cff%02x%02x%02x",
            math.floor((pc.r or 0) * 255),
            math.floor((pc.g or 1) * 255),
            math.floor((pc.b or 0) * 255)
        )

        local text = ""
        if profile.splitParagonText then
            local lines = {}
            for _, info in ipairs(p) do
                table.insert(lines, hex .. string.upper(info.name) .. " REWARD PENDING!|r")
            end
            text = table.concat(lines, "\n")
        else
            local names = {}
            for _, info in ipairs(p) do
                table.insert(names, string.upper(info.name))
            end
            local factionStr = ""
            if #names == 1 then
                factionStr = names[1]
            elseif #names == 2 then
                factionStr = names[1] .. " AND " .. names[2]
            else
                local last = table.remove(names)
                factionStr = table.concat(names, ", ") .. " AND " .. last
            end
            text = hex .. factionStr .. " REWARD" .. (#p > 1 and "S" or "") .. " PENDING!|r"
        end

        self.paragonText:SetFont(self.FONT_TO_USE, profile.paragonTextSize, "OUTLINE, THICK")
        self.paragonText:SetText(text)
        self.paragonText:Show()
        self.paragonText:ClearAllPoints()
        if profile.paragonOnTop then
            self.paragonText:SetPoint("TOP", UIParent, "TOP", 0, profile.paragonTextYOffset)
        else
            self.paragonText:SetPoint("TOP", self.textHolder, "BOTTOM", 0, profile.paragonTextYOffset)
        end

        name, reaction, min, max, value, standingLabel = p[1].name, 9, 0, 1, 1, "Reward Pending"
    else
        self.paragonText:Hide()
        local data = C_Reputation.GetWatchedFactionData()
        if data then
            name, reaction, factionID = data.name, data.reaction, data.factionID
            min, max, value = data.currentReactionThreshold, data.nextReactionThreshold, data.currentStanding
            if C_Reputation.IsFactionParagon(factionID) then
                local cv, th = C_Reputation.GetFactionParagonInfo(factionID)
                min, max, value, standingLabel, reaction = 0, th, cv % th, "Paragon", 9
            elseif C_Reputation.IsMajorFaction(factionID) then
                local md = C_MajorFactions.GetMajorFactionData(factionID)
                min, max, value, standingLabel, reaction = 0, md.renownLevelThreshold,
                    md.renownReputationEarned, "Renown " .. md.renownLevel, 11
            else
                standingLabel = _G["FACTION_STANDING_LABEL" .. reaction] or "???"
            end
        end
    end

    if name then
        self.Rep.bar:Show()
        self.Rep.txFrame:Show()
        local color = profile.useReactionColorRep and profile.repColors[reaction] or profile.repBarColor
        self.Rep.bar:SetStatusBarColor(color.r, color.g, color.b, color.a or 1.0)
        self.Rep.bar:SetMinMaxValues(min, max)
        self.Rep.bar:SetValue(value)

        if profile.sparkEnabled then
            local pct = (max - min > 0) and (value - min) / (max - min) or 0
            self.Rep.spark:SetPoint("CENTER", self.Rep.bar, "LEFT", self.Rep.bar:GetWidth() * pct, 0)
            self.Rep.spark:Show()
        else
            self.Rep.spark:Hide()
        end

        local pct = (max - min > 0) and ((value - min) / (max - min) * 100) or 0
        local valueStr = BreakUpLargeNumbers(value - min)
        local maxStr = BreakUpLargeNumbers(max - min)

        if profile.showAbsoluteValues and profile.showPercentage then
            self.Rep.text:SetText(string.format("%s (%s) %s/%s (%.1f%%)",
                name, standingLabel, valueStr, maxStr, pct))
        elseif profile.showAbsoluteValues then
            self.Rep.text:SetText(string.format("%s (%s) %s/%s",
                name, standingLabel, valueStr, maxStr))
        elseif profile.showPercentage then
            self.Rep.text:SetText(string.format("%s (%s) %.1f%%",
                name, standingLabel, pct))
        else
            self.Rep.text:SetText(string.format("%s (%s)", name, standingLabel))
        end
    else
        self.Rep.bar:Hide()
        self.Rep.txFrame:Hide()
    end
    return name
end

function AB:RenderConfig()
    self.textHolder:Show()
    self.textHolder:SetAlpha(1)
    self.textHolder:SetFrameStrata("HIGH")

    local profile = self.db.profile
    local tc = profile.textColor

    -- XP BAR
    self.XP.bar:Show()
    self.XP.txFrame:Show()
    local xc = profile.useClassColorXP and self:GetClassColor() or profile.xpBarColor
    self.XP.bar:SetStatusBarColor(xc.r, xc.g, xc.b, 1)
    self.XP.bar:SetMinMaxValues(0, 100)
    self.XP.bar:SetValue(75)

    self.XP.text:SetText("Experience Bar Data | 0/0 (0.0%)")
    self.XP.text:SetTextColor(tc.r, tc.g, tc.b, 1)

    if profile.showRestedBar then
        local w = self.XP.bar:GetWidth()
        if self.XP.restedOverlay then
            self.XP.restedOverlay:SetSize(w * 0.25, profile.barHeightXP)
            self.XP.restedOverlay:ClearAllPoints()
            self.XP.restedOverlay:SetPoint("LEFT", self.XP.bar, "LEFT", w * 0.75, 0)
            self.XP.restedOverlay:SetColorTexture(
                profile.restedBarColor.r,
                profile.restedBarColor.g,
                profile.restedBarColor.b,
                profile.restedBarColor.a
            )
            self.XP.restedOverlay:Show()
        end
    else
        if self.XP.restedOverlay then
            self.XP.restedOverlay:Hide()
        end
    end

    -- REPUTATION BAR
    self.Rep.bar:Show()
    self.Rep.txFrame:Show()
    local rc = profile.useReactionColorRep and profile.repColors[9] or profile.repBarColor
    self.Rep.bar:SetStatusBarColor(rc.r, rc.g, rc.b, 1)
    self.Rep.bar:SetMinMaxValues(0, 100)
    self.Rep.bar:SetValue(50)

    self.Rep.text:SetText("Reputation Bar Data | 0/0 (0.0%)")
    self.Rep.text:SetTextColor(tc.r, tc.g, tc.b, 1)

    -- PARAGON TEXT
    local pc = profile.paragonPendingColor
    local hex = string.format("|cff%02x%02x%02x",
        math.floor((pc.r or 0) * 255),
        math.floor((pc.g or 1) * 255),
        math.floor((pc.b or 0) * 255)
    )
    self.paragonText:SetFont(self.FONT_TO_USE, profile.paragonTextSize, "OUTLINE, THICK")

    if profile.splitParagonText then
        self.paragonText:SetText(hex .. "[CONFIG] FACTION A REWARD|r\n" .. hex .. "[CONFIG] FACTION B REWARD|r")
    else
        self.paragonText:SetText(hex .. "[CONFIG] MULTIPLE REWARDS PENDING!|r")
    end

    self.paragonText:Show()
    self.paragonText:ClearAllPoints()
    if profile.paragonOnTop then
        self.paragonText:SetPoint("TOP", UIParent, "TOP", 0, profile.paragonTextYOffset)
    else
        self.paragonText:SetPoint("TOP", self.textHolder, "BOTTOM", 0, profile.paragonTextYOffset)
    end

    self:UpdateTextAnchors("Config", false)
end

function AB:UpdateLayout(isMax)
    local profile = self.db.profile
    local effectiveMax = isMax and not self.state.isConfigMode

    self.XP.bar:SetHeight(profile.barHeightXP)
    self.Rep.bar:SetHeight(profile.barHeightRep)

    local font, _, flags = self.XP.text:GetFont()
    local outline = profile.fontOutline or "OUTLINE"
    self.XP.text:SetFont(font, profile.textSize, outline)
    self.Rep.text:SetFont(font, profile.textSize, outline)

    local tc = profile.textColor
    self.XP.text:SetTextColor(tc.r, tc.g, tc.b, tc.a)
    self.Rep.text:SetTextColor(tc.r, tc.g, tc.b, tc.a)

    -- Update background alpha
    if self.XP.background then
        self.XP.background:SetVertexColor(0, 0, 0, profile.backgroundAlpha)
    end
    if self.Rep.background then
        self.Rep.background:SetVertexColor(0, 0, 0, profile.backgroundAlpha)
    end

    local startY = profile.yOffset
    self.XP.bar:ClearAllPoints()
    self.Rep.bar:ClearAllPoints()

    if effectiveMax then
        self.XP.bar:Hide()
        self.XP.txFrame:Hide()
        self.Rep.bar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, startY)
        self.Rep.bar:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, startY)
    else
        self.XP.bar:Show()
        self.XP.txFrame:Show()
        self.XP.bar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, startY)
        self.XP.bar:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, startY)
        self.Rep.bar:SetPoint("TOPLEFT", self.XP.bar, "BOTTOMLEFT", 0, -profile.barGap)
        self.Rep.bar:SetPoint("TOPRIGHT", self.XP.bar, "BOTTOMRIGHT", 0, -profile.barGap)
    end
end

function AB:UpdateVisibility()
    local alpha = 1
    if not self.state.isConfigMode then
        if self.db.profile.hideInCombat and self.state.inCombat then
            alpha = 0
        elseif self.db.profile.showOnMouseover and not self.state.isHovering then
            alpha = 0
        end
    end
    self.XP.bar:SetAlpha(alpha)
    self.Rep.bar:SetAlpha(alpha)
    self.textHolder:SetAlpha(alpha)
end
