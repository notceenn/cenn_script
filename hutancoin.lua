-- Farming Script TURBO SAFE dengan UI
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- KOORDINAT
local BATU_POS = Vector3.new(315.43634, 59.6017876, -1051.05823)
local WATERFALL_CFRAME = CFrame.new(
    -494.550079, 65.4430389, -1504.82898,
    -0.994482219, -1.40715271e-08, -0.104905352,
    -1.18635848e-08, 1, -2.16709868e-08,
    0.104905352, -2.03068566e-08, -0.994482219
)

-- STATE
local farming = false
local farmThread = nil
local loopCount = 0

-- FUNGSI TELEPORT INSTANT
local function tpBatu()
    char = player.Character or player.CharacterAdded:Wait()
    hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(BATU_POS + Vector3.new(0, 3, 0))
end

local function tpWaterfall()
    char = player.Character or player.CharacterAdded:Wait()
    hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CFrame = WATERFALL_CFRAME
end

-- TRIGGER SEMUA PROMPT SEKALIGUS
local function triggerAllPrompts()
    for _, obj in ipairs(game.Workspace:GetDescendants()) do
        local prompt = obj:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            pcall(function()
                local partPos = obj.Parent:IsA("BasePart") and obj.Parent.Position
                    or (obj:IsA("BasePart") and obj.Position) or nil
                if partPos and (hrp.Position - partPos).Magnitude < 20 then
                    fireproximityprompt(prompt)
                end
            end)
        end
    end
end

-- LOOP dengan delay 1.5 detik
local function farmLoop(loopLabel)
    while farming do
        tpBatu()
        task.wait(1.5)
        triggerAllPrompts()
        task.wait(1.5)
        tpWaterfall()
        task.wait(1.5)
        triggerAllPrompts()
        task.wait(1.5)
        loopCount += 1
        loopLabel.Text = "Loop: " .. loopCount
    end
end

-- ========================
-- UI
-- ========================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FarmUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player.PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 230, 0, 160)
Frame.Position = UDim2.new(0.5, -115, 0.05, 0)
Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(80, 80, 160)
stroke.Thickness = 1.5
stroke.Parent = Frame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 60)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Frame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Text = "🌿 HUTAN COIN BY @OnlyGataa"
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(180, 180, 255)
Title.TextSize = 10
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local MinBtn = Instance.new("TextButton")
MinBtn.Text = "—"
MinBtn.Size = UDim2.new(0, 26, 0, 22)
MinBtn.Position = UDim2.new(1, -56, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 110)
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 14
MinBtn.Font = Enum.Font.GothamBold
MinBtn.BorderSizePixel = 0
MinBtn.Parent = TitleBar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 5)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "✕"
CloseBtn.Size = UDim2.new(0, 26, 0, 22)
CloseBtn.Position = UDim2.new(1, -28, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 13
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 5)

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 1, -32)
Content.Position = UDim2.new(0, 0, 0, 32)
Content.BackgroundTransparency = 1
Content.Parent = Frame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Text = "Status: OFF"
StatusLabel.Size = UDim2.new(1, 0, 0, 22)
StatusLabel.Position = UDim2.new(0, 0, 0, 6)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = Content

local LoopLabel = Instance.new("TextLabel")
LoopLabel.Text = "Loop: 0"
LoopLabel.Size = UDim2.new(1, 0, 0, 20)
LoopLabel.Position = UDim2.new(0, 0, 0, 28)
LoopLabel.BackgroundTransparency = 1
LoopLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
LoopLabel.TextSize = 12
LoopLabel.Font = Enum.Font.GothamBold
LoopLabel.Parent = Content

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Text = "▶ START"
ToggleBtn.Size = UDim2.new(0, 180, 0, 40)
ToggleBtn.Position = UDim2.new(0.5, -90, 0, 55)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 160, 80)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 13
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Parent = Content
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

local ResetBtn = Instance.new("TextButton")
ResetBtn.Text = "🔄 Reset Counter"
ResetBtn.Size = UDim2.new(0, 180, 0, 22)
ResetBtn.Position = UDim2.new(0.5, -90, 0, 102)
ResetBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
ResetBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
ResetBtn.TextSize = 11
ResetBtn.Font = Enum.Font.Gotham
ResetBtn.BorderSizePixel = 0
ResetBtn.Parent = Content
Instance.new("UICorner", ResetBtn).CornerRadius = UDim.new(0, 6)

-- ========================
-- LOGIC
-- ========================
local minimized = false

MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    Content.Visible = not minimized
    Frame.Size = minimized and UDim2.new(0, 230, 0, 34) or UDim2.new(0, 230, 0, 160)
    MinBtn.Text = minimized and "□" or "—"
end)

CloseBtn.MouseButton1Click:Connect(function()
    farming = false
    ScreenGui:Destroy()
end)

ResetBtn.MouseButton1Click:Connect(function()
    loopCount = 0
    LoopLabel.Text = "Loop: 0"
end)

ToggleBtn.MouseButton1Click:Connect(function()
    farming = not farming
    if farming then
        ToggleBtn.Text = "⏹ STOP"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        StatusLabel.Text = "Status: FARMING ⚡"
        StatusLabel.TextColor3 = Color3.fromRGB(80, 220, 100)
        farmThread = task.spawn(function()
            farmLoop(LoopLabel)
        end)
    else
        ToggleBtn.Text = "▶ START"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 160, 80)
        StatusLabel.Text = "Status: OFF"
        StatusLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
        if farmThread then
            task.cancel(farmThread)
            farmThread = nil
        end
    end
end)