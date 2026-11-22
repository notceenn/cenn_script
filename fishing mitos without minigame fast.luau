-- ============================================================
-- AUTO FISHING SCRIPT (GATAA MITOS FISHING! - RANDOM HOLD TIME)
-- EDIT: Randomized hold time for manual cast simulation
-- ============================================================

local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local PlayerGui = lp:WaitForChild("PlayerGui")

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
    clickDelay   = 0.08,   
    safeMode     = true,
    debugPrint   = true,
    stuckTimeout = 11,     
    hideMinigame = true, 
}

local State = {
    totalFish    = 0,
    totalCast    = 0,
    logLines     = {},
    maxLog       = 8,
    lastCastTime = 0,      
}

-- ============================================================
-- UI BUILD (Sama persis)
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
    orange=Color3.fromRGB(255, 165, 0)
}

local FULL_HEIGHT = 360  
local MINI_HEIGHT = 36   

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 280, 0, FULL_HEIGHT)
Main.Position = UDim2.new(0, 20, 0.5, -180)
Main.BackgroundColor3 = C.bg
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = C.border; MainStroke.Thickness = 1.5

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

local Body = Instance.new("Frame", Main)
Body.Size = UDim2.new(1, 0, 1, -36); Body.Position = UDim2.new(0, 0, 0, 36)
Body.BackgroundTransparency = 1

local StatusBadge = Instance.new("Frame", Body)
StatusBadge.Size = UDim2.new(1, 0, 0, 32); StatusBadge.Position = UDim2.new(0, 0, 0, 10)
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

local StatRow = Instance.new("Frame", Body)
StatRow.Size = UDim2.new(1, 0, 0, 52); StatRow.Position = UDim2.new(0, 0, 0, 52)
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

local BtnToggle = Instance.new("TextButton", Body)
BtnToggle.Size = UDim2.new(1, 0, 0, 36); BtnToggle.Position = UDim2.new(0, 0, 0, 116)
BtnToggle.BackgroundColor3 = C.accentDim; BtnToggle.Text = "▶  MULAI AUTO FISHING"
BtnToggle.Font = Enum.Font.GothamBold; BtnToggle.TextSize = 13; BtnToggle.TextColor3 = C.accent
Instance.new("UICorner", BtnToggle).CornerRadius = UDim.new(0, 8)
local ToggleStroke = Instance.new("UIStroke", BtnToggle); ToggleStroke.Color = C.border

local TPRow = Instance.new("Frame", Body)
TPRow.Size = UDim2.new(1, 0, 0, 30); TPRow.Position = UDim2.new(0, 0, 0, 160)
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

local LogBox = Instance.new("Frame", Body)
LogBox.Size = UDim2.new(1, 0, 0, 100); LogBox.Position = UDim2.new(0, 0, 0, 198)
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

local function hideMinigameUI()
    if not Settings.hideMinigame then return end
    task.spawn(function()
        for i = 1, 20 do
            for _, gui in pairs(PlayerGui:GetChildren()) do
                if gui:IsA("ScreenGui") and gui.Name ~= "AutoFishUI" then
                    local target = gui:FindFirstChild(TargetName, true)
                    if target and target.Parent and target.Parent.Parent then
                        target.Parent.Parent.Visible = false
                    end
                end
            end
            task.wait(0.05)
        end
    end)
end

-- 🆕 FUNGSI CAST INSTAN (RANDOM HOLD TIME)
local function instantCast()
    if not Settings.enabled then return end
    task.spawn(function()
        local char = lp.Character
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if not tool then return end

        -- Kalau masih animasi pull, klik terus sampai bisa
        local timeout = os.clock() + 2
        while lp:GetAttribute(StateAttribute) ~= nil and os.clock() < timeout do
            tool:Activate()
            RunService.Heartbeat:Wait()
        end

        -- Lakukan Cast kilat
        tool:Activate()
        
        -- 🆕 RANDOM HOLD TIME (0.05 sampai 0.25 detik)
        -- Ini bakal ngerandom power di Cobalt, gak bakal sama terus
        local randomHoldTime = rng:NextNumber(0.05, 0.25) 
        task.wait(randomHoldTime) 
        
        -- Lepas tombol
        pcall(function() firesignal(tool.Deactivated) end)

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
    
    hideMinigameUI()

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

-- INSTANT RECAST PAS GAME ENDED
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