-- CENN HUB! - Coin Hutan Fishing
-- Teleport to Seller Feature + Get Fish Exploit

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Seller Location CFrame
local SellerCFrame = CFrame.new(-83.2018051, 33.3287544, -1031.65247, -0.0907148197, 3.74077835e-08, 0.995876908, 2.16429674e-09, 1, -3.73655098e-08, -0.995876908, -1.23423238e-09, -0.0907148197)

-- Remove existing GUI if any
if playerGui:FindFirstChild("CennHubGUI") then
    playerGui.CennHubGUI:Destroy()
end

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CennHubGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 230)
mainFrame.Position = UDim2.new(0.5, -150, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 20, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(130, 80, 220)
uiStroke.Thickness = 1.5
uiStroke.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 36)
header.BackgroundColor3 = Color3.fromRGB(45, 25, 70)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 10)
headerCorner.Parent = header

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 10)
headerFix.Position = UDim2.new(0, 0, 1, -10)
headerFix.BackgroundColor3 = Color3.fromRGB(45, 25, 70)
headerFix.BorderSizePixel = 0
headerFix.ZIndex = 0
headerFix.Parent = header

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -70, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "CENN HUB! - Coin Hutan Fishing"
title.TextColor3 = Color3.fromRGB(220, 200, 255)
title.TextSize = 13
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextTruncate = Enum.TextTruncate.AtEnd
title.Parent = header

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 26, 0, 26)
minimizeBtn.Position = UDim2.new(1, -62, 0.5, -13)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(70, 50, 100)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(230, 220, 255)
minimizeBtn.TextSize = 18
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.AutoButtonColor = true
minimizeBtn.Parent = header

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minimizeBtn

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -32, 0.5, -13)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- Content
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -20, 1, -50)
content.Position = UDim2.new(0, 10, 0, 44)
content.BackgroundTransparency = 1
content.Parent = mainFrame

-- Warning Label
local warnLabel = Instance.new("TextLabel")
warnLabel.Name = "Warning"
warnLabel.Size = UDim2.new(1, 0, 0, 30)
warnLabel.BackgroundTransparency = 1
warnLabel.Text = "⚠️ Wajib Beli Pancingan Koin Seharga 11 Coin\nsebelum Menggunakan Script!"
warnLabel.TextColor3 = Color3.fromRGB(255, 200, 80)
warnLabel.TextSize = 11
warnLabel.Font = Enum.Font.GothamBold
warnLabel.TextXAlignment = Enum.TextXAlignment.Center
warnLabel.TextWrapped = true
warnLabel.Parent = content

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 0, 32)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Idle"
statusLabel.TextColor3 = Color3.fromRGB(180, 170, 200)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = content

-- Get Fish Button
local getFishBtn = Instance.new("TextButton")
getFishBtn.Name = "GetFishBtn"
getFishBtn.Size = UDim2.new(1, 0, 0, 40)
getFishBtn.Position = UDim2.new(0, 0, 0, 56)
getFishBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 100)
getFishBtn.Text = "🐟 Get Fish "
getFishBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
getFishBtn.TextSize = 14
getFishBtn.Font = Enum.Font.GothamBold
getFishBtn.AutoButtonColor = true
getFishBtn.Parent = content

local fishCorner = Instance.new("UICorner")
fishCorner.CornerRadius = UDim.new(0, 8)
fishCorner.Parent = getFishBtn

-- Teleport to Seller Button
local teleportBtn = Instance.new("TextButton")
teleportBtn.Name = "TeleportBtn"
teleportBtn.Size = UDim2.new(1, 0, 0, 40)
teleportBtn.Position = UDim2.new(0, 0, 0, 102)
teleportBtn.BackgroundColor3 = Color3.fromRGB(130, 80, 220)
teleportBtn.Text = "📍 Teleport ke Penjual"
teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportBtn.TextSize = 14
teleportBtn.Font = Enum.Font.GothamBold
teleportBtn.AutoButtonColor = true
teleportBtn.Parent = content

local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0, 8)
tpCorner.Parent = teleportBtn

-- Functions
local function updateStatus(text)
    statusLabel.Text = "Status: " .. text
end

local function teleportToSeller()
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:FindFirstChild("HumanoidRootPart")

    if hrp then
        hrp.CFrame = SellerCFrame
        updateStatus("Teleported to seller!")
    else
        updateStatus("Character not found")
    end
end

local function getFishExploit()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    -- Cari Broken Rod di Backpack
    local backpack = player:FindFirstChild("Backpack")
    local rod = nil

    if backpack then
        rod = backpack:FindFirstChild("Broken Rod")
    end

    -- Jika tidak ada di Backpack, cek di Character (sudah dipegang)
    if not rod then
        rod = character:FindFirstChild("Broken Rod")
    end

    -- Jika masih tidak ada, coba tunggu sebentar
    if not rod then
        updateStatus("Beli Rod Dulu TOLOL!")
        return
    end

    -- Equip rod jika ada di Backpack
    if backpack and rod.Parent == backpack then
        humanoid:EquipTool(rod)
        updateStatus("Equipping Broken Rod...")
        task.wait(0.3)
    end

    -- Pastikan rod sudah ada di Character setelah equip
    rod = character:FindFirstChild("Broken Rod")
    if not rod then
        updateStatus("Gagal equip Broken Rod!")
        return
    end

    local args = {
        rod,
        {
            Sell_Price_KG = 999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999,
            Fish_Name = "HUTAN KONTOL MEMEK",
            FishImage = "90405868254318",
            Weight = 999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
        }
    }

    local remote = game:GetService("ReplicatedStorage"):WaitForChild("Fishing_System"):WaitForChild("Remotes"):WaitForChild("FinalTask")
    remote:FireServer(unpack(args))
    updateStatus("Fish exploit fired!")
end

-- Button Events
getFishBtn.MouseButton1Click:Connect(function()
    updateStatus("Executing fish exploit...")
    getFishExploit()
end)

teleportBtn.MouseButton1Click:Connect(function()
    updateStatus("Teleporting...")
    teleportToSeller()
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Minimize functionality
local isMinimized = false
local fullHeight = 230
local minHeight = 36

minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized

    if isMinimized then
        mainFrame:TweenSize(UDim2.new(0, 300, 0, minHeight), "Out", "Quad", 0.25, true)
        content.Visible = false
        minimizeBtn.Text = "+"
    else
        mainFrame:TweenSize(UDim2.new(0, 300, 0, fullHeight), "Out", "Quad", 0.25, true)
        content.Visible = true
        minimizeBtn.Text = "-"
    end
end)

-- Make frame draggable
local UserInputService = game:GetService("UserInputService")
local draggingFrame = false
local dragStart = nil
local startPos = nil

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingFrame = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingFrame = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingFrame and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

print("CENN HUB! - Coin Hutan Fishing loaded.")
updateStatus("Ready")