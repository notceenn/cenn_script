-- Piano Spammer — 61 KEYS × 610/s = 37,210 remote/detik
-- + TP ke Piano & Auto WalkSpeed 100

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local PianoEvent = workspace:WaitForChild("GlobalPianoConnector", 10)

---------- CONFIG ----------
local NOTE_START     = 1          -- key paling rendah
local NOTE_END       = 61         -- key paling tinggi (sesuai game kamu)
local PER_KEY_RATE   = 610        -- tiap key ditembak berapa kali per detik
-- Total rate = (NOTE_END - NOTE_START + 1) * PER_KEY_RATE = 61 * 610 = 37,210/s

local NUM_KEYS   = NOTE_END - NOTE_START + 1
local TOTAL_RATE = NUM_KEYS * PER_KEY_RATE

-- ⭐ Fitur Baru: CFrame Piano & WalkSpeed
local PIANO_CFRAME = CFrame.new(363.90, 81.70, -1218.41) -- Koordinat dari gambar

local function setWalkSpeed()
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 100
        end
    end
end

-- Langsung set saat execute, dan set ulang saat respawn
setWalkSpeed()
player.CharacterAdded:Connect(function()
    task.wait(1) -- Tunggu character load sempurna
    setWalkSpeed()
end)

---------- State ----------
local enabled     = false
local fireCount   = 0
local spamThread  = nil
local isMinimized = false
local rateLastCount = 0
local rateLastTime  = os.clock()

---------- UI ----------
local W, H_OPEN, H_MIN = 300, 240, 40 -- H_OPEN ditambah biar muat tombol TP

local gui = Instance.new("ScreenGui")
gui.Name = "PianoSpammer"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, W, 0, H_OPEN)
main.Position = UDim2.new(0.02, 0, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.ClipsDescendants = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255, 100, 100)
stroke.Thickness = 2

local bar = Instance.new("Frame")
bar.Size = UDim2.new(1, 0, 0, H_MIN)
bar.BackgroundColor3 = Color3.fromRGB(14, 14, 24)
bar.BorderSizePixel = 0
bar.ZIndex = 2
bar.Parent = main
Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 12)

local barFix = Instance.new("Frame")
barFix.Size = UDim2.new(1, 0, 0, 12)
barFix.Position = UDim2.new(0, 0, 1, -12)
barFix.BackgroundColor3 = Color3.fromRGB(14, 14, 24)
barFix.BorderSizePixel = 0
barFix.ZIndex = 2
barFix.Parent = bar

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(1, -80, 1, 0)
titleLbl.Position = UDim2.new(0, 12, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = string.format("🎹  %d keys × %d/s", NUM_KEYS, PER_KEY_RATE)
titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLbl.TextSize = 13
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.ZIndex = 3
titleLbl.Parent = bar

local function makeBarBtn(x, color, label)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 26, 0, 26)
    btn.Position = UDim2.new(1, x, 0.5, -13)
    btn.BackgroundColor3 = color
    btn.Text = label
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.ZIndex = 3
    btn.Parent = bar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local minBtn   = makeBarBtn(-62, Color3.fromRGB(240, 170, 0), "─")
local closeBtn = makeBarBtn(-30, Color3.fromRGB(255, 60, 60),  "✕")

local body = Instance.new("Frame")
body.Size = UDim2.new(1, -16, 0, H_OPEN - H_MIN - 10)
body.Position = UDim2.new(0, 8, 0, H_MIN + 8)
body.BackgroundTransparency = 1
body.Parent = main

local pill = Instance.new("Frame")
pill.Size = UDim2.new(1, 0, 0, 34)
pill.BackgroundColor3 = Color3.fromRGB(30, 30, 44)
pill.BorderSizePixel = 0
pill.Parent = body
Instance.new("UICorner", pill).CornerRadius = UDim.new(0, 8)

local dot = Instance.new("Frame")
dot.Size = UDim2.new(0, 9, 0, 9)
dot.Position = UDim2.new(0, 12, 0.5, -4)
dot.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
dot.BorderSizePixel = 0
dot.Parent = pill
Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, -28, 1, 0)
statusLbl.Position = UDim2.new(0, 28, 0, 0)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "Inactive"
statusLbl.TextColor3 = Color3.fromRGB(200, 200, 215)
statusLbl.TextSize = 13
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextXAlignment = Enum.TextXAlignment.Left
statusLbl.Parent = pill

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, 0, 0, 40)
toggleBtn.Position = UDim2.new(0, 0, 0, 44)
toggleBtn.BackgroundColor3 = Color3.fromRGB(65, 175, 65)
toggleBtn.Text = "▶   Start ALL 61 KEYS"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 14
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.AutoButtonColor = false
toggleBtn.Parent = body
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

-- ⭐ TOMBOL TP KE PIANO
local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(1, 0, 0, 30)
tpBtn.Position = UDim2.new(0, 0, 0, 94)
tpBtn.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
tpBtn.Text = "📌 TP ke Piano"
tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpBtn.TextSize = 13
tpBtn.Font = Enum.Font.GothamBold
tpBtn.AutoButtonColor = false
tpBtn.Parent = body
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 8)

tpBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = PIANO_CFRAME
        end
    end
end)

local countLbl = Instance.new("TextLabel")
countLbl.Size = UDim2.new(1, 0, 0, 20)
countLbl.Position = UDim2.new(0, 0, 0, 134) -- Digeser ke bawah
countLbl.BackgroundTransparency = 1
countLbl.Text = "🎵  Fired: 0"
countLbl.TextColor3 = Color3.fromRGB(160, 160, 185)
countLbl.TextSize = 12
countLbl.Font = Enum.Font.Gotham
countLbl.TextXAlignment = Enum.TextXAlignment.Center
countLbl.Parent = body

local rateLbl = Instance.new("TextLabel")
rateLbl.Size = UDim2.new(1, 0, 0, 18)
rateLbl.Position = UDim2.new(0, 0, 0, 156) -- Digeser ke bawah
rateLbl.BackgroundTransparency = 1
rateLbl.Text = string.format("📊  Live: 0/s (target %d)", TOTAL_RATE)
rateLbl.TextColor3 = Color3.fromRGB(120, 220, 140)
rateLbl.TextSize = 12
rateLbl.Font = Enum.Font.GothamBold
rateLbl.TextXAlignment = Enum.TextXAlignment.Center
rateLbl.Parent = body

---------- Logic ----------
local function updateUI()
    if enabled then
        dot.BackgroundColor3 = Color3.fromRGB(70, 230, 70)
        statusLbl.Text = string.format("Spamming %d keys @ %d/s", NUM_KEYS, PER_KEY_RATE)
        toggleBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
        toggleBtn.Text = "⏹   Stop"
    else
        dot.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        statusLbl.Text = "Inactive"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(65, 175, 65)
        toggleBtn.Text = "▶   Start ALL 61 KEYS"
    end
    countLbl.Text = "🎵  Fired: " .. fireCount
end

local function startSpam()
    spamThread = task.spawn(function()
        local clock = os.clock
        local startT = clock()
        local baseCount = fireCount
        local n = NUM_KEYS
        local startNote = NOTE_START
        local totalRate = TOTAL_RATE
        local fire = PianoEvent.FireServer
        local obj  = PianoEvent
        local pcall_l = pcall

        while enabled do
            local elapsed      = clock() - startT
            local targetTotal  = math.floor(elapsed * totalRate)
            local alreadyFired = fireCount - baseCount
            local needed       = targetTotal - alreadyFired

            if needed > 0 then
                local offset = alreadyFired % n
                local ok = pcall_l(function()
                    local idx = offset
                    for _ = 1, needed do
                        fire(obj, "play", startNote + (idx % n))
                        idx += 1
                    end
                end)
                if ok then
                    fireCount += needed
                else
                    local idx = offset
                    for _ = 1, needed do
                        if pcall_l(fire, obj, "play", startNote + (idx % n)) then
                            fireCount += 1
                        end
                        idx += 1
                    end
                end
            end

            task.wait()
        end
    end)
end

toggleBtn.MouseButton1Click:Connect(function()
    if not PianoEvent then
        statusLbl.Text = "⚠️ Remote tidak ditemukan"
        return
    end
    enabled = not enabled
    updateUI()
    if enabled then
        rateLastCount = fireCount
        rateLastTime  = os.clock()
        startSpam()
    end
end)

minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local target = isMinimized and UDim2.new(0, W, 0, H_MIN) or UDim2.new(0, W, 0, H_OPEN)
    TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = target}):Play()
    minBtn.Text = isMinimized and "□" or "─"
end)

closeBtn.MouseButton1Click:Connect(function()
    enabled = false
    TweenService:Create(main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(main.Position.X.Scale, main.Position.X.Offset + W/2,
                             main.Position.Y.Scale, main.Position.Y.Offset + H_OPEN/2)
    }):Play()
    task.wait(0.25)
    if gui and gui.Parent then gui:Destroy() end
end)

task.spawn(function()
    while gui and gui.Parent do
        task.wait(1)
        local now = os.clock()
        local dCount = fireCount - rateLastCount
        local dTime  = now - rateLastTime
        local rate = dTime > 0 and (dCount / dTime) or 0
        rateLbl.Text = string.format("📊  Live: %.0f/s (target %d)", rate, TOTAL_RATE)
        if rate >= TOTAL_RATE * 0.9 then
            rateLbl.TextColor3 = Color3.fromRGB(120, 220, 140)
        else
            rateLbl.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        rateLastCount = fireCount
        rateLastTime  = now
    end
end)

task.spawn(function()
    while gui and gui.Parent do
        task.wait(0.2)
        if enabled then
            countLbl.Text = "🎵  Fired: " .. fireCount
        end
    end
end)

updateUI()
print(string.format("✅ Piano Spammer [%d keys × %d/s = %d total/s] + TP Piano & Speed 100 loaded!",
    NUM_KEYS, PER_KEY_RATE, TOTAL_RATE))