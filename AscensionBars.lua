-- ==========================================================
-- AscensionBars - Version 5.0.0
-- ==========================================================
local ADDON_NAME = "AscensionBars"
local AB = LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME, "AceEvent-3.0", "AceConsole-3.0")

-- ==========================================================
-- INITIALIZATION
-- ==========================================================
function AB:OnInitialize()
    -- Initialize Database first
    self.db = LibStub("AceDB-3.0"):New("AscensionBarsDB", self.defaults, true)

    -- Initialize State immediately after DB to prevent nil errors in events/methods
    self.state = {
        lastParagonScanTime = 0,
        cachedPendingParagons = {},
        cachedClassColor = nil,
        isConfigMode = false,
        inCombat = false,
        isHovering = false,
        debugMode = false,
        eventHandlers = {},
        updatePending = false
    }

    -- Determine font to use
    self.FONT_TO_USE = GameFontNormal:GetFont() or "Fonts\\FRIZQT__.TTF"

    -- Register Options and Dialogs
    LibStub("AceConfig-3.0"):RegisterOptionsTable(ADDON_NAME, self:GetOptionsTable())
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(ADDON_NAME, "Ascension Bars")

    self:RegisterChatCommand("ab", function()
        -- Use modern Settings API for Dragonflight/War Within
        if Settings and Settings.OpenToCategory then
            Settings.OpenToCategory(self.optionsFrame.name)
        else
            -- Fallback for older clients if needed, though you target Retail
            InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
        end
    end)

    self:RegisterChatCommand("abdebug", function()
        self.db.profile.debugMode = not self.db.profile.debugMode
        self:ToggleDebugMode()
        print("AscensionBars: Debug mode " .. (self.db.profile.debugMode and "enabled" or "disabled"))
    end)

    self:CreateFrames()
end

function AB:OnEnable()
    self:RegisterEvent("PLAYER_XP_UPDATE", "UpdateDisplay")
    self:RegisterEvent("UPDATE_EXHAUSTION", "UpdateDisplay")
    self:RegisterEvent("PLAYER_LEVEL_UP", "UpdateDisplay")
    self:RegisterEvent("UPDATE_FACTION", "OnUpdateFaction")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "OnUpdateFaction")
    self:RegisterEvent("PLAYER_REGEN_DISABLED", "OnCombatStart")
    self:RegisterEvent("PLAYER_REGEN_ENABLED", "OnCombatEnd")
    self:RegisterEvent("QUEST_TURNED_IN", "OnQuestTurnIn")

    self:HideBlizzardFrames()
    self:ScanParagonRewards()
    self:UpdateDisplay(true)

    -- Initialize debug mode if enabled
    if self.db.profile.debugMode then
        self:ToggleDebugMode()
    end
end

-- ==========================================================
-- EVENT HANDLERS
-- ==========================================================
function AB:OnUpdateFaction()
    self:ScanParagonRewards()
end

function AB:OnCombatStart()
    self.state.inCombat = true
    self:DebugPrint("Combat started")
    self:UpdateVisibility()
end

function AB:OnCombatEnd()
    self.state.inCombat = false
    self:DebugPrint("Combat ended")
    self:UpdateVisibility()
end

function AB:OnQuestTurnIn()
    C_Timer.After(1, function()
        self:ScanParagonRewards()
    end)
end

-- ==========================================================
-- DEBUG
-- ==========================================================
function AB:ToggleDebugMode()
    if self.state then
        self.state.debugMode = self.db.profile.debugMode
    end
end

function AB:DebugPrint(msg)
    if self.db and self.db.profile and self.db.profile.debugMode then
        self:Print("|cffFF0000[DEBUG]|r " .. tostring(msg))
    end
end

-- ==========================================================
-- DISABLE
-- ==========================================================
function AB:OnDisable()
    self:CleanupTextures()

    -- Reset frames to default state
    if self.XP and self.XP.bar then self.XP.bar:Hide() end
    if self.Rep and self.Rep.bar then self.Rep.bar:Hide() end
    if self.textHolder then self.textHolder:Hide() end

    self:DebugPrint("Addon disabled")
end
