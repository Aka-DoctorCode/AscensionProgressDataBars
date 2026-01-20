local AB = LibStub("AceAddon-3.0"):GetAddon("AscensionBars")

function AB:GetClassColor()
    if not self.state.cachedClassColor then
        local class = select(2, UnitClass("player"))
        self.state.cachedClassColor = RAID_CLASS_COLORS[class] or { r = 1, g = 1, b = 1, a = 1 }
    end
    return self.state.cachedClassColor
end

function AB:DebugPrint(msg)
    if self.db.profile.debugMode then
        print("AscensionBars: " .. msg)
    end
end

function AB:ToggleDebugMode()
    if self.db.profile.debugMode then
        self:DebugPrint("Debug mode enabled")
    else
        self:DebugPrint("Debug mode disabled")
    end
end

function AB:ScanParagonRewards()
    local pending = {}
    if C_Reputation then
        for i = 1, C_Reputation.GetNumFactions() do
            local d = C_Reputation.GetFactionDataByIndex(i)
            if d and d.factionID and C_Reputation.IsFactionParagon(d.factionID) then
                local _, _, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(d.factionID)
                if hasRewardPending then
                    table.insert(pending, { name = d.name })
                end
            end
        end
    end
    self.state.cachedPendingParagons = pending
    self:UpdateDisplay()
end

function AB:HideBlizzardFrames()
    local frames = {
        MainMenuExpBar,
        MainMenuBarMaxLevelBar,
        ReputationWatchBar,
        StatusTrackingBarManager,
        ExpBar,
        ReputationBar,
        HonorBar,
        ArtifactWatchBar,
        AzeriteBar
    }
    for _, frame in pairs(frames) do
        if frame then
            frame:UnregisterAllEvents()
            frame:Hide()
            frame:SetAlpha(0)
            frame.Show = function() end
        end
    end
end

function AB:FormatXP()
    local c, m = UnitXP("player"), UnitXPMax("player")
    local pct = (m > 0 and c / m * 100) or 0
    local profile = self.db.profile

    local txt = ""
    if profile.showAbsoluteValues then
        txt = string.format("Level %d | %s/%s",
            UnitLevel("player"),
            BreakUpLargeNumbers(c),
            BreakUpLargeNumbers(m))
        if profile.showPercentage then
            txt = txt .. string.format(" (%.1f%%)", pct)
        end
    elseif profile.showPercentage then
        txt = string.format("Level %d | %.1f%%", UnitLevel("player"), pct)
    else
        txt = string.format("Level %d", UnitLevel("player"))
    end

    local r = GetXPExhaustion()
    if r and r > 0 then
        txt = txt .. string.format(" | Rested %.1f%%", (m > 0 and r / m * 100) or 0)
    end
    return txt
end

function AB:AddTooltip(bar, text)
    if not bar or not text then return end

    bar:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
        GameTooltip:SetText(text)
        GameTooltip:Show()
    end)

    bar:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end

function AB:LoadPreset(presetName)
    local presets = {
        minimal = {
            barHeightXP = 3,
            barHeightRep = 3,
            textSize = 10,
            showOnMouseover = true,
            showRestedBar = false,
        },
        detailed = {
            barHeightXP = 8,
            barHeightRep = 8,
            textSize = 14,
            showRestedBar = true,
            showAbsoluteValues = true,
            showPercentage = true,
        },
        classic = {
            useClassColorXP = true,
            useReactionColorRep = true,
            barHeightXP = 5,
            barHeightRep = 5,
            textSize = 12,
        }
    }

    if presets[presetName] then
        for k, v in pairs(presets[presetName]) do
            self.db.profile[k] = v
        end
        self:UpdateDisplay()
        self:DebugPrint("Loaded preset: " .. presetName)
    else
        self:DebugPrint("Unknown preset: " .. presetName)
    end
end
