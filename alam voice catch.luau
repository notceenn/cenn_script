-- GATAA - ALAM VOICE CATCH
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local speedMode = false
local totalCatch = 0
local lastCatchTime = 0
local minimized = false

local SELLER_POS = Vector3.new(641.89, -195.03, -984.25)
local ES_POS = Vector3.new(543.04, -197.57, -778.30)

-- ================= ANTI AFK =================
local function setupAntiAfk()
    LocalPlayer.Idled:Connect(function()
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end)
    end)
    task.spawn(function()
        while true do
            task.wait(60)
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0, 0))
            end)
        end
    end)
end

-- ================= TELEPORT =================
local function teleportToSeller()
    pcall(function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if hrp then
            hrp.CFrame = CFrame.new(SELLER_POS + Vector3.new(0, 3, 0))
            print("[TELEPORT] Berhasil ke penjual")
        end
    end)
end

local function teleportToEs()
    pcall(function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if hrp then
            hrp.CFrame = CFrame.new(ES_POS + Vector3.new(0, 3, 0))
            print("[TELEPORT] Berhasil ke tempat es")
        end
    end)
end

-- ================= FORCE CLICK =================
local function forceClick(button)
    if typeof(firesignal) == "function" then
        local ok = pcall(function() firesignal(button.MouseButton1Click) end)
        if ok then return true end
    end
    if typeof(getconnections) == "function" then
        local ok = pcall(function()
            for _, conn in pairs(getconnections(button.MouseButton1Click)) do
                conn:Fire()
            end
        end)
        if ok then return true end
    end
    if typeof(mouse1click) == "function" and typeof(mousemoveabs) == "function" then
        local ok = pcall(function()
            local pos = button.AbsolutePosition
            local size = button.AbsoluteSize
            mousemoveabs(pos.X + size.X / 2, pos.Y + size.Y / 2)
            task.wait()
            mouse1click()
        end)
        if ok then return true end
    end
    local ok = pcall(function()
        local pos = button.AbsolutePosition
        local size = button.AbsoluteSize
        local VIM = game:GetService("VirtualInputManager")
        VIM:SendMouseButtonEvent(pos.X + size.X / 2, pos.Y + size.Y / 2, 0, true, game, 0)
        task.wait()
        VIM:SendMouseButtonEvent(pos.X + size.X / 2, pos.Y + size.Y / 2, 0, false, game, 0)
    end)
    return ok
end

-- ================= HOOK =================
local hookInstalled = false
local function installHooks()
    if hookInstalled then return end
    hookInstalled = true

    pcall(function()
        local Config = require(ReplicatedStorage.Shared.Config)
        if Config.Animals and Config.Animals.Catch then
            Config.Animals.Catch.AnticipationMin = 2.8
            Config.Animals.Catch.AnticipationMax = 3.0
            Config.Animals.Catch.PostSwingDelay = 0.8
            Config.Animals.Catch.Cooldown = 0.05
        end
    end)

    local oldWait = task.wait
    task.wait = function(duration)
        if speedMode and duration and duration > 0.3 then
            return oldWait(duration * 0.3)
        end
        return oldWait(duration)
    end

    pcall(function()
        local CatchMinigame = require(LocalPlayer.PlayerScripts.Animals.CatchMinigame)
        if CatchMinigame then
            CatchMinigame.Play = function(...) return true end
        end
    end)
end

-- ================= HOOK CATCH COUNTER =================
local function hookCatchCounter()
    pcall(function()
        local Knit = require(ReplicatedStorage.Packages.Knit)
        task.spawn(function()
            task.wait(3)
            local CatchController = Knit.GetController("CatchController")
            if not CatchController then
                warn("[GATAA] CatchController tidak ditemukan")
                return
            end

            local oldFinish = CatchController._finishCatch
            CatchController._finishCatch = function(self, minigameResult, redeemResult)
                if type(redeemResult) == "table" and redeemResult.ok == true then
                    totalCatch = totalCatch + 1
                    print("[CATCH] Dapat hewan! Total:", totalCatch)
                end
                return oldFinish(self, minigameResult, redeemResult)
            end
        end)
    end)
end

-- ================= FIND CATCH BUTTON =================
local function findCatchButton()
    local catchGui = PlayerGui:FindFirstChild("CatchGui")
    if not catchGui then return nil end
    return catchGui:FindFirstChild("CatchButton")
end

-- ================= WATCH MINIGAME =================
local function watchMinigame()
    PlayerGui.ChildAdded:Connect(function(child)
        if not speedMode then return end
        if child.Name == "MinigameGui" then
            task.spawn(function()
                local gameArea = child:FindFirstChild("GameArea")
                local dragonfly = gameArea and gameArea:FindFirstChild("Dragonfly")
                if dragonfly then
                    local clicks = 0
                    while dragonfly.Parent and clicks < 100 and speedMode do
                        forceClick(dragonfly)
                        clicks = clicks + 1
                        task.wait(0.01)
                    end
                end
            end)
        end
    end)
end

-- ================= AUTO CATCH =================
local function startCatch()
    task.spawn(function()
        while speedMode do
            pcall(function()
                local currentTime = tick()
                if currentTime - lastCatchTime >= 0.1 then
                    local btn = findCatchButton()
                    if btn and btn.Visible and btn.ImageTransparency < 0.3 then
                        forceClick(btn)
                        lastCatchTime = currentTime
                    end
                end
            end)
            task.wait(0.01)
        end
    end)
end

-- ================= UI =================
local oldGui = PlayerGui:FindFirstChild("GataaAlamVoice")
if oldGui then oldGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GataaAlamVoice"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.5, -100, 0.5, -110)
Frame.Size = UDim2.new(0, 200, 0, 220)
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

local stroke = Instance.new("UIStroke", Frame)
stroke.Color = Color3.fromRGB(200, 200, 200)
stroke.Thickness = 1

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Parent = Frame
TopBar.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 30)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local TopBarFix = Instance.new("Frame")
TopBarFix.Parent = TopBar
TopBarFix.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
TopBarFix.BorderSizePixel = 0
TopBarFix.Position = UDim2.new(0, 0, 0.5, 0)
TopBarFix.Size = UDim2.new(1, 0, 0.5, 0)

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "GATAA · ALAM VOICE"
Title.TextColor3 = Color3.fromRGB(60, 60, 60)
Title.TextSize = 11
Title.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton")
MinBtn.Parent = TopBar
MinBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
MinBtn.Position = UDim2.new(1, -50, 0.5, -10)
MinBtn.Size = UDim2.new(0, 20, 0, 20)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.fromRGB(80, 80, 80)
MinBtn.TextSize = 14
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(1, 0)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 90, 90)
CloseBtn.Position = UDim2.new(1, -26, 0.5, -10)
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

-- Content
local Content = Instance.new("Frame")
Content.Parent = Frame
Content.BackgroundTransparency = 1
Content.Position = UDim2.new(0, 0, 0, 32)
Content.Size = UDim2.new(1, 0, 1, -32)

local function makeButton(text, yPos, bg, tc)
    local btn = Instance.new("TextButton")
    btn.Parent = Content
    btn.BackgroundColor3 = bg
    btn.Position = UDim2.new(0.06, 0, 0, yPos)
    btn.Size = UDim2.new(0.88, 0, 0, 32)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = tc or Color3.fromRGB(60, 60, 60)
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local BTNBG   = Color3.fromRGB(230, 230, 230)
local BTNBGON = Color3.fromRGB(80, 80, 80)

local CatchBtn    = makeButton("▶  START CATCH", 4, BTNBG)
local TeleportBtn = makeButton("⬆  TELEPORT PENJUAL", 42, BTNBG)
local EsBtn       = makeButton("❄  TELEPORT ES", 80, BTNBG)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = Content
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 0, 122)
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Total Catch: 0"
StatusLabel.TextColor3 = Color3.fromRGB(130, 130, 130)
StatusLabel.TextSize = 11

local AfkInfo = Instance.new("TextLabel")
AfkInfo.Parent = Content
AfkInfo.BackgroundTransparency = 1
AfkInfo.Position = UDim2.new(0, 0, 0, 140)
AfkInfo.Size = UDim2.new(1, 0, 0, 16)
AfkInfo.Font = Enum.Font.Gotham
AfkInfo.Text = "🛡 Anti-AFK aktif"
AfkInfo.TextColor3 = Color3.fromRGB(160, 160, 160)
AfkInfo.TextSize = 10

-- Update status
task.spawn(function()
    while ScreenGui.Parent do
        StatusLabel.Text = "Total Catch: " .. totalCatch
        task.wait(1)
    end
end)

-- ================= MINIMIZE =================
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    Content.Visible = not minimized
    if minimized then
        Frame.Size = UDim2.new(0, 200, 0, 30)
        MinBtn.Text = "+"
    else
        Frame.Size = UDim2.new(0, 200, 0, 220)
        MinBtn.Text = "−"
    end
end)

-- ================= EVENTS =================
CatchBtn.MouseButton1Click:Connect(function()
    speedMode = not speedMode
    if speedMode then
        installHooks()
        CatchBtn.Text = "⏹  STOP CATCH"
        CatchBtn.BackgroundColor3 = BTNBGON
        CatchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        startCatch()
    else
        CatchBtn.Text = "▶  START CATCH"
        CatchBtn.BackgroundColor3 = BTNBG
        CatchBtn.TextColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

TeleportBtn.MouseButton1Click:Connect(function()
    teleportToSeller()
end)

EsBtn.MouseButton1Click:Connect(function()
    teleportToEs()
end)

CloseBtn.MouseButton1Click:Connect(function()
    speedMode = false
    ScreenGui:Destroy()
end)

-- ================= INIT =================
setupAntiAfk()
watchMinigame()
hookCatchCounter()

print("[GATAA] ALAM VOICE CATCH loaded!")