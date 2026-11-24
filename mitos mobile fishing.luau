-- ============================================================
-- AUTO FISHING SCRIPT (GATAA MITOS FISHING! - ANDROID SPOOF)
-- + ANNOUNCE MONITOR → DISCORD WEBHOOK
-- ============================================================
-- FIXED: Webhook menggunakan executor HTTP (request/http_request)
--        bukan HttpService:PostAsync (tidak bisa dari LocalScript)
-- ============================================================

local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local lp = Players.LocalPlayer
local PlayerGui = lp:WaitForChild("PlayerGui")

-- 🆕 SPOOFING DEVICE
local DeviceModule = require(RS:WaitForChild("Shared"):WaitForChild("Modules"):WaitForChild("Device"))
DeviceModule.IsMobile = function() return false end

local FishingService = RS:WaitForChild("Packages"):WaitForChild("Knit")
    :WaitForChild("Services"):WaitForChild("FishingService")

local ClickRF       = FishingService:WaitForChild("RF"):WaitForChild("Click")
local GameStartedRE = FishingService:WaitForChild("RE"):WaitForChild("GameStarted")
local GameEndedRE   = FishingService:WaitForChild("RE"):WaitForChild("GameEnded")

local Config = require(RS:WaitForChild("Shared"):WaitForChild("Config"))
local TargetName = Config.Fishing.Game.Names.Target
local StateAttribute = Config.Fishing.StateAttribute

local Settings = {
    enabled      = false,
    clickDelay   = 0.12,
    safeMode     = true,
    debugPrint   = true,
    stuckTimeout = 15,
    hideMinigame = false,
    webhookURL   = "",
    monitorAnnounce = true,
}

local State = {
    totalFish    = 0,
    totalCast    = 0,
    logLines     = {},
    maxLog       = 8,
    lastCastTime = 0,
}

-- ============================================================
-- HTTP HELPER (kompatibel dengan semua executor)
-- Executor seperti Synapse X, KRNL, Fluxus, dll pakai
-- request() atau http_request() bukan HttpService:PostAsync
-- ============================================================
local function httpPost(url, body)
    -- Coba request() dulu (Synapse X, KRNL, Fluxus, Solara, dll)
    if request then
        return request({
            Url     = url,
            Method  = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body    = body,
        })
    end
    -- Fallback: http_request() (beberapa executor lama)
    if http_request then
        return http_request({
            Url     = url,
            Method  = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body    = body,
        })
    end
    -- Fallback terakhir: HttpService (biasanya gagal di LocalScript, tapi dicoba)
    return HttpService:PostAsync(url, body, Enum.HttpContentType.ApplicationJson)
end

-- ============================================================
-- WEBHOOK FUNCTION (diperbaiki)
-- ============================================================
local function sendWebhook(title, message, color, pingEveryone)
    if Settings.webhookURL == "" then return false, "URL kosong" end

    -- Validasi URL lebih ketat
    local url = Settings.webhookURL
    if not url:match("https://discord%.com/api/webhooks/%d+/.+") and
       not url:match("https://discordapp%.com/api/webhooks/%d+/.+") and
       not url:match("https://ptb%.discord%.com/api/webhooks/%d+/.+") and
       not url:match("https://canary%.discord%.com/api/webhooks/%d+/.+") then
        return false, "Format URL webhook tidak valid"
    end

    color = color or 16711680 -- merah default

    local contentStr = ""
    if pingEveryone then
        contentStr = "@everyone"
    end

    local payload = HttpService:JSONEncode({
        content  = contentStr,
        username = "GATAA MITOS FISHING",
        embeds   = {{
            title       = title,
            description = message,
            color       = color,
            timestamp   = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            footer      = {
                text     = "GATAA MITOS FISHING • " .. os.date("%H:%M:%S"),
            },
        }}
    })

    local ok, result = pcall(httpPost, url, payload)

    if not ok then
        return false, tostring(result)
    end

    -- Cek status code jika executor mendukung
    if type(result) == "table" and result.StatusCode then
        if result.StatusCode >= 200 and result.StatusCode < 300 then
            return true, "OK (" .. result.StatusCode .. ")"
        else
            -- Coba baca pesan error dari Discord
            local errMsg = "HTTP " .. result.StatusCode
            if result.Body then
                local ok2, decoded = pcall(HttpService.JSONDecode, HttpService, result.Body)
                if ok2 and decoded and decoded.message then
                    errMsg = errMsg .. ": " .. decoded.message
                end
            end
            return false, errMsg
        end
    end

    -- Jika executor tidak return status code, anggap sukses
    return true, "Terkirim"
end

-- ============================================================
-- ANNOUNCE MONITOR
-- ============================================================
local Knit = RS:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services")

-- Serializer rekursif: handle table bersarang, Instance, Enum, dll
local function serialize(val, depth, seen)
    depth = depth or 0
    seen  = seen or {}
    local t = type(val)

    if t == "string"  then return '"' .. val:gsub('"', '\\"'):gsub("\n", "\\n") .. '"' end
    if t == "number"  then return tostring(val) end
    if t == "boolean" then return tostring(val) end
    if t == "nil"     then return "nil" end

    if t == "table" then
        if seen[val] then return "{...}" end -- cegah circular reference
        seen[val] = true
        if depth >= 4 then return "{...}" end -- batas kedalaman

        local parts = {}
        -- Coba cek apakah ada field teks yang umum (Message, Text, Title, dll)
        local priorityKeys = {"Message","message","Text","text","Title","title","Content","content","Description","description","Body","body"}
        local handled = {}

        for _, k in ipairs(priorityKeys) do
            if val[k] ~= nil then
                table.insert(parts, tostring(k) .. " = " .. serialize(val[k], depth+1, seen))
                handled[k] = true
            end
        end

        for k, v in pairs(val) do
            if not handled[k] then
                local ks = type(k) == "string" and k or ("[" .. tostring(k) .. "]")
                table.insert(parts, ks .. " = " .. serialize(v, depth+1, seen))
            end
        end

        seen[val] = nil
        if #parts == 0 then return "{}" end
        return "{\n" .. string.rep("  ", depth+1) .. table.concat(parts, ",\n" .. string.rep("  ", depth+1)) .. "\n" .. string.rep("  ", depth) .. "}"
    end

    -- Instance Roblox
    if t == "userdata" then
        local ok, name = pcall(function() return val.Name end)
        local ok2, cn  = pcall(function() return val.ClassName end)
        if ok and ok2 then return "[" .. tostring(cn) .. ": " .. tostring(name) .. "]" end
        return tostring(val)
    end

    return tostring(val)
end

-- Konversi semua args event ke string yang mudah dibaca
local function argsToReadable(...)
    local args = {...}
    if #args == 0 then return "(tidak ada data)" end

    -- Jika arg pertama adalah string, kemungkinan itu pesan utama
    -- Tampilkan dengan prioritas
    local lines = {}
    for i, v in ipairs(args) do
        lines[i] = "arg[" .. i .. "] = " .. serialize(v, 0, {})
    end
    return table.concat(lines, "\n")
end

-- Ekstrak teks pesan dari event data (coba berbagai field umum)
local function extractMessage(...)
    local args = {...}
    -- Cek arg string langsung
    for _, v in ipairs(args) do
        if type(v) == "string" and #v > 0 then
            return v
        end
    end
    -- Cek dalam table
    for _, v in ipairs(args) do
        if type(v) == "table" then
            local candidates = {
                v.Message, v.message, v.Text, v.text,
                v.Title, v.title, v.Content, v.content,
                v.Description, v.description, v.Body, v.body,
                v.Announcement, v.announcement, v.Notice, v.notice,
            }
            for _, c in ipairs(candidates) do
                if type(c) == "string" and #c > 0 then
                    return c
                end
            end
        end
    end
    return nil
end

local monitorTargets = {
    { path = Knit:WaitForChild("AnnounceService"):WaitForChild("RE"):WaitForChild("Announced"),           label = "AnnounceService",    emoji = "📣" },
    { path = Knit:WaitForChild("ChatNotificationService"):WaitForChild("RE"):WaitForChild("Message"),     label = "ChatNotification",   emoji = "💬" },
    { path = Knit:WaitForChild("NotificationService"):WaitForChild("RE"):WaitForChild("Show"),            label = "NotificationService",emoji = "🔔" },
    { path = Knit:WaitForChild("LuckBoostService"):WaitForChild("RE"):WaitForChild("Announced"),          label = "LuckBoost",          emoji = "🍀" },
}

for _, target in ipairs(monitorTargets) do
    target.path.OnClientEvent:Connect(function(...)
        if not Settings.monitorAnnounce then return end

        -- Serialisasi data lengkap untuk debug
        local rawDump = argsToReadable(...)

        -- Coba ekstrak pesan utama
        local mainMsg = extractMessage(...)

        print("[ANNOUNCE MONITOR] " .. target.label .. " fired!")
        print(rawDump)

        -- Buat isi embed Discord yang informatif
        local embedDesc = ""
        if mainMsg then
            embedDesc = "**📨 Pesan:**\n> " .. mainMsg:gsub("\n", "\n> ") .. "\n\n"
        end
        embedDesc = embedDesc .. "**📦 Raw Data:**\n```lua\n" .. rawDump:sub(1, 900) .. "\n```"

        -- Kirim ke webhook
        task.spawn(function()
            local ok, err = sendWebhook(
                target.emoji .. " " .. target.label .. " — Notif dari Admin!",
                embedDesc,
                16744272, -- orange
                true      -- ping @everyone
            )
            if not ok then
                print("[WEBHOOK ERROR] " .. target.label .. ": " .. tostring(err))
            end
        end)
    end)
end

-- ============================================================
-- UI BUILD
-- ============================================================
if PlayerGui:FindFirstChild("AutoFishUI") then PlayerGui.AutoFishUI:Destroy() end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFishUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = PlayerGui

local C = {
    bg=Color3.fromRGB(13,17,23), panel=Color3.fromRGB(21,27,35), border=Color3.fromRGB(48,90,140),
    accent=Color3.fromRGB(56,139,253), accentDim=Color3.fromRGB(30,70,130), green=Color3.fromRGB(50,215,100),
    red=Color3.fromRGB(240,70,70), text=Color3.fromRGB(220,230,240), textDim=Color3.fromRGB(100,120,150),
    logBg=Color3.fromRGB(10,13,18), statBg=Color3.fromRGB(17,23,32), white=Color3.fromRGB(255,255,255),
    orange=Color3.fromRGB(255,165,0), yellow=Color3.fromRGB(255,220,50),
}

local FULL_HEIGHT = 480
local MINI_HEIGHT = 36

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 280, 0, FULL_HEIGHT)
Main.Position = UDim2.new(0, 20, 0.5, -240)
Main.BackgroundColor3 = C.bg
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = C.border; MainStroke.Thickness = 1.5

-- TITLE BAR
local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1, 0, 0, 36)
TitleBar.BackgroundColor3 = C.panel
TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

local TitleFix = Instance.new("Frame", TitleBar)
TitleFix.Size = UDim2.new(1, 0, 0.5, 0); TitleFix.Position = UDim2.new(0, 0, 0.5, 0)
TitleFix.BackgroundColor3 = C.panel; TitleFix.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1, -110, 1, 0); Title.Position = UDim2.new(0, 38, 0, 0); Title.BackgroundTransparency = 1
Title.Text = "GATAA MITOS FISHING!"; Title.Font = Enum.Font.GothamBold
Title.TextSize = 14; Title.TextColor3 = C.text; Title.TextXAlignment = Enum.TextXAlignment.Left

local BtnMin = Instance.new("TextButton", TitleBar)
BtnMin.Size = UDim2.new(0, 24, 0, 24); BtnMin.Position = UDim2.new(1, -56, 0, 6)
BtnMin.BackgroundColor3 = Color3.fromRGB(25,55,25)
BtnMin.Text = "−"; BtnMin.TextColor3 = C.green
BtnMin.Font = Enum.Font.GothamBold; BtnMin.TextSize = 16
Instance.new("UICorner", BtnMin).CornerRadius = UDim.new(0, 6)

local BtnClose = Instance.new("TextButton", TitleBar)
BtnClose.Size = UDim2.new(0, 24, 0, 24); BtnClose.Position = UDim2.new(1, -28, 0, 6)
BtnClose.BackgroundColor3 = Color3.fromRGB(80,25,25)
BtnClose.Text = "✕"; BtnClose.TextColor3 = C.red
BtnClose.Font = Enum.Font.GothamBold; BtnClose.TextSize = 13
Instance.new("UICorner", BtnClose).CornerRadius = UDim.new(0, 6)

-- BODY
local Body = Instance.new("Frame", Main)
Body.Size = UDim2.new(1, -20, 1, -46)
Body.Position = UDim2.new(0, 10, 0, 42)
Body.BackgroundTransparency = 1

-- STATUS
local StatusBadge = Instance.new("Frame", Body)
StatusBadge.Size = UDim2.new(1, 0, 0, 32); StatusBadge.Position = UDim2.new(0, 0, 0, 0)
StatusBadge.BackgroundColor3 = C.statBg
Instance.new("UICorner", StatusBadge).CornerRadius = UDim.new(0, 8)
local StatusDot = Instance.new("Frame", StatusBadge)
StatusDot.Size = UDim2.new(0, 8, 0, 8); StatusDot.Position = UDim2.new(0, 10, 0.5, -4)
StatusDot.BackgroundColor3 = C.red
Instance.new("UICorner", StatusDot).CornerRadius = UDim.new(0.5, 0)
local StatusLabel = Instance.new("TextLabel", StatusBadge)
StatusLabel.Size = UDim2.new(1, -28, 1, 0); StatusLabel.Position = UDim2.new(0, 24, 0, 0)
StatusLabel.BackgroundTransparency = 1; StatusLabel.Text = "Status: Idle"
StatusLabel.Font = Enum.Font.Gotham; StatusLabel.TextSize = 12
StatusLabel.TextColor3 = C.textDim; StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- STAT ROW
local StatRow = Instance.new("Frame", Body)
StatRow.Size = UDim2.new(1, 0, 0, 52); StatRow.Position = UDim2.new(0, 0, 0, 40)
StatRow.BackgroundTransparency = 1
local StatLayout = Instance.new("UIListLayout", StatRow)
StatLayout.FillDirection = Enum.FillDirection.Horizontal; StatLayout.Padding = UDim.new(0, 8)

local function makeStatBox(label, order)
    local Box = Instance.new("Frame", StatRow)
    Box.Size = UDim2.new(0.48, 0, 1, 0); Box.BackgroundColor3 = C.statBg; Box.LayoutOrder = order
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 8)
    local Lbl = Instance.new("TextLabel", Box)
    Lbl.Size = UDim2.new(1, 0, 0, 18); Lbl.Position = UDim2.new(0, 0, 0, 6)
    Lbl.BackgroundTransparency = 1; Lbl.Text = label
    Lbl.Font = Enum.Font.Gotham; Lbl.TextSize = 10; Lbl.TextColor3 = C.textDim
    local Val = Instance.new("TextLabel", Box)
    Val.Size = UDim2.new(1, 0, 0, 22); Val.Position = UDim2.new(0, 0, 0, 24)
    Val.BackgroundTransparency = 1; Val.Text = "0"
    Val.Font = Enum.Font.GothamBold; Val.TextSize = 18; Val.TextColor3 = C.accent
    return Val
end
local FishCount = makeStatBox("IKAN DAPAT", 1)
local CastCount = makeStatBox("TOTAL CAST", 2)

-- TOGGLE BTN
local BtnToggle = Instance.new("TextButton", Body)
BtnToggle.Size = UDim2.new(1, 0, 0, 36); BtnToggle.Position = UDim2.new(0, 0, 0, 100)
BtnToggle.BackgroundColor3 = C.accentDim; BtnToggle.Text = "▶  MULAI AUTO FISHING"
BtnToggle.Font = Enum.Font.GothamBold; BtnToggle.TextSize = 13; BtnToggle.TextColor3 = C.accent
Instance.new("UICorner", BtnToggle).CornerRadius = UDim.new(0, 8)
local ToggleStroke = Instance.new("UIStroke", BtnToggle); ToggleStroke.Color = C.border

-- TP BUTTONS
local TPRow = Instance.new("Frame", Body)
TPRow.Size = UDim2.new(1, 0, 0, 30); TPRow.Position = UDim2.new(0, 0, 0, 144)
TPRow.BackgroundTransparency = 1
local TPLayout = Instance.new("UIListLayout", TPRow)
TPLayout.FillDirection = Enum.FillDirection.Horizontal
TPLayout.Padding = UDim.new(0, 6)

local function makeTPBtn(text, order)
    local btn = Instance.new("TextButton", TPRow)
    btn.Size = UDim2.new(0.31, 0, 1, 0)
    btn.BackgroundColor3 = C.statBg
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextColor3 = C.orange
    btn.LayoutOrder = order
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = C.border
    return btn
end

local BtnTPFish = makeTPBtn("📍 Fish NPC", 1)
local BtnTPRod  = makeTPBtn("🏪 Rod Shop", 2)
local BtnTPSpot = makeTPBtn("🎣 Spot", 3)

-- LOG BOX
local LogBox = Instance.new("Frame", Body)
LogBox.Size = UDim2.new(1, 0, 0, 90); LogBox.Position = UDim2.new(0, 0, 0, 182)
LogBox.BackgroundColor3 = C.logBg; LogBox.ClipsDescendants = true
Instance.new("UICorner", LogBox).CornerRadius = UDim.new(0, 8)
local LogStroke = Instance.new("UIStroke", LogBox); LogStroke.Color = Color3.fromRGB(30,40,55)
local LogText = Instance.new("TextLabel", LogBox)
LogText.Size = UDim2.new(1, -16, 1, -16); LogText.Position = UDim2.new(0, 8, 0, 8)
LogText.BackgroundTransparency = 1; LogText.Text = "Menunggu..."
LogText.Font = Enum.Font.Code; LogText.TextSize = 10
LogText.TextColor3 = Color3.fromRGB(80,160,100); LogText.TextXAlignment = Enum.TextXAlignment.Left
LogText.TextYAlignment = Enum.TextYAlignment.Top; LogText.TextWrapped = true; LogText.RichText = true

-- ============================================================
-- WEBHOOK SECTION UI
-- ============================================================
local WebhookSection = Instance.new("Frame", Body)
WebhookSection.Size = UDim2.new(1, 0, 0, 118)
WebhookSection.Position = UDim2.new(0, 0, 0, 280)
WebhookSection.BackgroundColor3 = C.statBg
WebhookSection.BorderSizePixel = 0
Instance.new("UICorner", WebhookSection).CornerRadius = UDim.new(0, 8)
local WSStroke = Instance.new("UIStroke", WebhookSection)
WSStroke.Color = C.border; WSStroke.Thickness = 1

-- Section title
local WebhookTitle = Instance.new("TextLabel", WebhookSection)
WebhookTitle.Size = UDim2.new(1, -10, 0, 20)
WebhookTitle.Position = UDim2.new(0, 10, 0, 6)
WebhookTitle.BackgroundTransparency = 1
WebhookTitle.Text = "📡 ANNOUNCE MONITOR → DISCORD"
WebhookTitle.Font = Enum.Font.GothamBold
WebhookTitle.TextSize = 11
WebhookTitle.TextColor3 = C.yellow
WebhookTitle.TextXAlignment = Enum.TextXAlignment.Left

-- Webhook input box
local WebhookInput = Instance.new("TextBox", WebhookSection)
WebhookInput.Size = UDim2.new(1, -16, 0, 28)
WebhookInput.Position = UDim2.new(0, 8, 0, 30)
WebhookInput.BackgroundColor3 = C.logBg
WebhookInput.Text = Settings.webhookURL
WebhookInput.PlaceholderText = "Paste Discord Webhook URL..."
WebhookInput.Font = Enum.Font.Code
WebhookInput.TextSize = 9
WebhookInput.TextColor3 = C.text
WebhookInput.PlaceholderColor3 = C.textDim
WebhookInput.ClearTextOnFocus = false
WebhookInput.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", WebhookInput).CornerRadius = UDim.new(0, 6)
local WIStroke = Instance.new("UIStroke", WebhookInput)
WIStroke.Color = C.border; WIStroke.Thickness = 1

local WIPad = Instance.new("UIPadding", WebhookInput)
WIPad.PaddingLeft = UDim.new(0, 6)

-- Button row
local WBtnRow = Instance.new("Frame", WebhookSection)
WBtnRow.Size = UDim2.new(1, -16, 0, 28)
WBtnRow.Position = UDim2.new(0, 8, 0, 64)
WBtnRow.BackgroundTransparency = 1

local BtnSaveWebhook = Instance.new("TextButton", WBtnRow)
BtnSaveWebhook.Size = UDim2.new(0.48, 0, 1, 0)
BtnSaveWebhook.Position = UDim2.new(0, 0, 0, 0)
BtnSaveWebhook.BackgroundColor3 = Color3.fromRGB(25,55,25)
BtnSaveWebhook.Text = "💾 Simpan"
BtnSaveWebhook.Font = Enum.Font.GothamBold
BtnSaveWebhook.TextSize = 11
BtnSaveWebhook.TextColor3 = C.green
Instance.new("UICorner", BtnSaveWebhook).CornerRadius = UDim.new(0, 6)

local BtnTestWebhook = Instance.new("TextButton", WBtnRow)
BtnTestWebhook.Size = UDim2.new(0.48, 0, 1, 0)
BtnTestWebhook.Position = UDim2.new(0.52, 0, 0, 0)
BtnTestWebhook.BackgroundColor3 = Color3.fromRGB(30,50,80)
BtnTestWebhook.Text = "🧪 Test Ping"
BtnTestWebhook.Font = Enum.Font.GothamBold
BtnTestWebhook.TextSize = 11
BtnTestWebhook.TextColor3 = C.accent
Instance.new("UICorner", BtnTestWebhook).CornerRadius = UDim.new(0, 6)

-- Monitor toggle
local MonitorToggleBtn = Instance.new("TextButton", WebhookSection)
MonitorToggleBtn.Size = UDim2.new(1, -16, 0, 20)
MonitorToggleBtn.Position = UDim2.new(0, 8, 0, 96)
MonitorToggleBtn.BackgroundTransparency = 1
MonitorToggleBtn.Text = "🔔 Monitor: ON  |  Tap untuk toggle"
MonitorToggleBtn.Font = Enum.Font.Gotham
MonitorToggleBtn.TextSize = 10
MonitorToggleBtn.TextColor3 = C.green
MonitorToggleBtn.TextXAlignment = Enum.TextXAlignment.Left

-- ============================================================
-- UI LOGIC
-- ============================================================
local function updateStatus(text, isActive)
    StatusLabel.Text = "Status: " .. text
    StatusDot.BackgroundColor3 = isActive and C.green or C.red
end

local function addLog(msg)
    print("[GATAA MITOS FISHING] " .. msg)
    table.insert(State.logLines, msg)
    if #State.logLines > State.maxLog then table.remove(State.logLines, 1) end
    local lines = {}
    for _, line in ipairs(State.logLines) do
        local color = line:find("IKAN") and "ffd060"
            or (line:find("Error") or line:find("❌")) and "f04646"
            or line:find("⚠️") and "ffaa00"
            or line:find("📍") and "ffa500"
            or line:find("🔄") and "38bdfd"
            or line:find("📡") and "50cc88"
            or line:find("✅") and "50ee88"
            or "80a0c0"
        table.insert(lines, '<font color="#' .. color .. '">' .. line .. '</font>')
    end
    LogText.Text = table.concat(lines, "\n")
end

local function updateToggleBtn()
    if Settings.enabled then
        BtnToggle.Text = "⏹  BERHENTI"
        BtnToggle.BackgroundColor3 = Color3.fromRGB(60,20,20)
        BtnToggle.TextColor3 = C.red; ToggleStroke.Color = C.red
    else
        BtnToggle.Text = "▶  MULAI AUTO FISHING"
        BtnToggle.BackgroundColor3 = C.accentDim
        BtnToggle.TextColor3 = C.accent; ToggleStroke.Color = C.border
    end
end

local function updateMonitorBtn()
    if Settings.monitorAnnounce then
        MonitorToggleBtn.Text = "🔔 Monitor: ON  |  Tap untuk toggle"
        MonitorToggleBtn.TextColor3 = C.green
    else
        MonitorToggleBtn.Text = "🔕 Monitor: OFF  |  Tap untuk toggle"
        MonitorToggleBtn.TextColor3 = C.red
    end
end

local function teleportTo(pos, name)
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = lp.Character.HumanoidRootPart
        hrp.CFrame = CFrame.new(pos.X, pos.Y + 3, pos.Z)
        addLog("📍 TP ke " .. name)
        updateStatus("TP ke " .. name, false)
    else
        addLog("❌ Karakter tidak ditemukan!")
    end
end

-- ============================================================
-- WEBHOOK BUTTON EVENTS (diperbaiki)
-- ============================================================

-- Validasi URL Discord Webhook
local function isValidWebhookURL(url)
    return url ~= "" and (
        url:match("https://discord%.com/api/webhooks/%d+/.+") or
        url:match("https://discordapp%.com/api/webhooks/%d+/.+") or
        url:match("https://ptb%.discord%.com/api/webhooks/%d+/.+") or
        url:match("https://canary%.discord%.com/api/webhooks/%d+/.+")
    )
end

BtnSaveWebhook.MouseButton1Click:Connect(function()
    local url = WebhookInput.Text:match("^%s*(.-)%s*$") -- trim whitespace

    if not isValidWebhookURL(url) then
        addLog("❌ URL tidak valid! Harus discord.com/api/webhooks/...")
        BtnSaveWebhook.Text = "❌ Invalid!"
        BtnSaveWebhook.BackgroundColor3 = Color3.fromRGB(80,20,20)
        task.delay(2, function()
            BtnSaveWebhook.Text = "💾 Simpan"
            BtnSaveWebhook.BackgroundColor3 = Color3.fromRGB(25,55,25)
        end)
        return
    end

    Settings.webhookURL = url
    WebhookInput.Text = url -- set juga ke input box (supaya keliatan bersih)
    addLog("📡 Webhook URL disimpan!")
    BtnSaveWebhook.Text = "✅ Tersimpan"
    task.delay(2, function() BtnSaveWebhook.Text = "💾 Simpan" end)
end)

BtnTestWebhook.MouseButton1Click:Connect(function()
    -- Jika belum disimpan tapi ada isi di input, coba gunakan dari input
    local url = Settings.webhookURL
    if url == "" then
        url = WebhookInput.Text:match("^%s*(.-)%s*$")
        if isValidWebhookURL(url) then
            Settings.webhookURL = url
            addLog("📡 URL disimpan otomatis dari input...")
        else
            addLog("❌ Simpan webhook URL yang valid dulu!")
            return
        end
    end

    addLog("🧪 Mengirim test ping ke Discord...")
    BtnTestWebhook.Text = "⏳ Mengirim..."
    BtnTestWebhook.BackgroundColor3 = Color3.fromRGB(50,50,20)

    -- Jalankan di thread terpisah supaya UI tidak freeze
    task.spawn(function()
        local ok, err = sendWebhook(
            "🧪 Test Ping Berhasil!",
            "✅ **Bot monitor aktif dan siap!**\n\nWebhook terhubung dengan benar ke **GATAA MITOS FISHING**.\n\n📌 Monitor aktif untuk:\n- AnnounceService\n- ChatNotification\n- NotificationService\n- LuckBoost",
            3066993, -- hijau
            false    -- jangan ping @everyone saat test
        )

        if ok then
            addLog("✅ Test ping berhasil terkirim!")
            BtnTestWebhook.Text = "✅ Berhasil!"
            BtnTestWebhook.BackgroundColor3 = Color3.fromRGB(20,55,20)
        else
            addLog("❌ Gagal kirim: " .. tostring(err))
            BtnTestWebhook.Text = "❌ Gagal!"
            BtnTestWebhook.BackgroundColor3 = Color3.fromRGB(80,20,20)
        end

        task.delay(2.5, function()
            BtnTestWebhook.Text = "🧪 Test Ping"
            BtnTestWebhook.BackgroundColor3 = Color3.fromRGB(30,50,80)
        end)
    end)
end)

MonitorToggleBtn.MouseButton1Click:Connect(function()
    Settings.monitorAnnounce = not Settings.monitorAnnounce
    updateMonitorBtn()
    addLog("Monitor: " .. (Settings.monitorAnnounce and "ON ✅" or "OFF 🔕"))
end)

BtnTPFish.MouseButton1Click:Connect(function() teleportTo(Vector3.new(-904.02, 86.28, 1083.28), "Fish NPC") end)
BtnTPRod.MouseButton1Click:Connect(function() teleportTo(Vector3.new(-930.40, 85.07, 1277.26), "Rod Shop") end)
BtnTPSpot.MouseButton1Click:Connect(function() teleportTo(Vector3.new(-992.25, 85.39, 1231.90), "Spot Mancing") end)

BtnClose.MouseButton1Click:Connect(function()
    Settings.enabled = false
    if getgenv().AutoFish then getgenv().AutoFish.stop() end
    ScreenGui:Destroy()
end)

local isMinimized = false
BtnMin.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        Body.Visible = false
        Main.Size = UDim2.new(0, 280, 0, MINI_HEIGHT)
        BtnMin.Text = "□"
        BtnMin.TextColor3 = C.accent
    else
        Body.Visible = true
        Main.Size = UDim2.new(0, 280, 0, FULL_HEIGHT)
        BtnMin.Text = "−"
        BtnMin.TextColor3 = C.green
    end
end)

-- ============================================================
-- FISHING LOGIC
-- ============================================================
local isProcessing = false
local rng = Random.new()

local function safeInvoke(rf, ...)
    local args = {...}
    local ok, result = pcall(function() return rf:InvokeServer(table.unpack(args)) end)
    if ok then return result end
    addLog("Error Invoke: " .. tostring(result))
    return nil
end

local function instantCast()
    if not Settings.enabled then return end
    task.spawn(function()
        local char = lp.Character
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if not tool then return end

        local timeout = os.clock() + 2
        while lp:GetAttribute(StateAttribute) ~= nil and os.clock() < timeout do
            tool:Activate()
            task.wait(0.05)
        end

        task.wait(0.1)
        tool:Activate()

        local randomHoldTime = rng:NextNumber(0.08, 0.22)
        task.wait(randomHoldTime)

        pcall(function() tool:Deactivate() end)

        State.totalCast = State.totalCast + 1
        CastCount.Text = tostring(State.totalCast)
        addLog("Cast #" .. State.totalCast)
        updateStatus("Menunggu gigitan...", true)
        State.lastCastTime = os.clock()
    end)
end

local function handleMinigame(data)
    if isProcessing then return end
    if not Settings.enabled then return end

    isProcessing = true
    State.lastCastTime = 0
    updateStatus("Minigame aktif!", true)

    local success, err = pcall(function()
        local turns    = data.Turns or {}
        local required = data.Required or 3
        local hits     = 0
        local interval = data.Interval or 1.0
        local startAt  = data.StartAt or workspace:GetServerTimeNow()

        addLog(string.format("Req:%d | Int:%.1fs | Turns:%d", required, interval, #turns))

        for index, isTelur in ipairs(turns) do
            if not Settings.enabled then break end
            if hits >= required then break end

            local turnActiveAt = startAt + (index - 1) * interval

            while workspace:GetServerTimeNow() < turnActiveAt - Settings.clickDelay do
                RunService.Heartbeat:Wait()
            end

            if workspace:GetServerTimeNow() > (data.EndAt or turnActiveAt + 2) then
                addLog("Waktu habis!")
                break
            end

            if isTelur then
                addLog(string.format("Klik TELUR idx=%d", index))
                local result = safeInvoke(ClickRF, index)

                if result then
                    hits = result.Hits or (hits + 1)
                    if result.Ended or hits >= required then
                        State.totalFish = State.totalFish + 1
                        FishCount.Text = tostring(State.totalFish)
                        addLog("✓ IKAN DAPAT! Total: " .. State.totalFish)
                        break
                    end
                end
            end
        end
    end)

    isProcessing = false

    if not success then
        addLog("❌ Error: " .. tostring(err))
    end
end

lp.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    addLog("🛡️ Anti-AFK: idle dicegah")
end)

task.spawn(function()
    while task.wait(1) do
        if Settings.enabled and not isProcessing and State.lastCastTime > 0 then
            local elapsed = os.clock() - State.lastCastTime
            if elapsed >= Settings.stuckTimeout then
                addLog(string.format("⚠️ Stuck %.0fs! Auto recast...", elapsed))
                State.lastCastTime = os.clock()
                instantCast()
            end
        end
    end
end)

local conn = GameStartedRE.OnClientEvent:Connect(function(data)
    task.spawn(handleMinigame, data)
end)

local connEnded = GameEndedRE.OnClientEvent:Connect(function(success, itemName)
    if not Settings.enabled then return end
    if success then
        updateStatus("Instant Recast...", true)
        instantCast()
    else
        task.wait(1.5)
        instantCast()
    end
end)

BtnToggle.MouseButton1Click:Connect(function()
    Settings.enabled = not Settings.enabled
    updateToggleBtn()
    if Settings.enabled then
        updateStatus("Aktif - Casting...", true)
        instantCast()
    else
        updateStatus("Idle", false)
        State.lastCastTime = 0
        addLog("Auto fishing DIMATIKAN")
    end
end)

-- DRAG
local dragging, dragStart, startPos = false, nil, nil
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = Main.Position
    end
end)
TitleBar.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)
TitleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

getgenv().AutoFish = {
    start = function() Settings.enabled = true; updateToggleBtn(); instantCast() end,
    stop  = function() Settings.enabled = false; updateToggleBtn() end,
}

addLog("Script siap! Tekan MULAI.")
addLog("📡 Monitor announce: AKTIF")
