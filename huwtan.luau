    local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local RS               = game:GetService("ReplicatedStorage")
local LocalPlayer      = Players.LocalPlayer

local function GetGuiParent()
    if typeof(gethui) == "function" then
        local ok, hui = pcall(gethui)
        if ok and hui then return hui end
    end
    local ok, pg = pcall(function() return LocalPlayer:WaitForChild("PlayerGui", 5) end)
    if ok and pg then return pg end
    return game:GetService("CoreGui")
end

local ACCENT   = Color3.fromRGB(255, 255, 255)
local BG       = Color3.fromRGB(18, 18, 18)
local ELEM     = Color3.fromRGB(28, 28, 28)
local ELEM_HOV = Color3.fromRGB(44, 44, 44)
local TEXT     = Color3.fromRGB(235, 235, 235)
local SUB      = Color3.fromRGB(140, 140, 140)
local STROKE   = Color3.fromRGB(255, 255, 255) 
local BG_TRANS       = 0.45 
local ELEM_TRANS     = 0.55 
local ELEM_HOV_TRANS = 0.35 
local STROKE_TRANS   = 0.85 

local function corner(inst, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 6)
    c.Parent = inst
    return c
end
local function stroke(inst, col, t, tr)
    local s = Instance.new("UIStroke")
    s.Color = col or STROKE
    s.Thickness = t or 1
    s.Transparency = tr or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = inst
    return s
end
local function pad(inst, l, r, t, b)
    local p = Instance.new("UIPadding")
    p.PaddingLeft   = UDim.new(0, l or 8)
    p.PaddingRight  = UDim.new(0, r or 8)
    p.PaddingTop    = UDim.new(0, t or 8)
    p.PaddingBottom = UDim.new(0, b or 8)
    p.Parent = inst
end
local function tween(inst, time, props)
    TweenService:Create(inst, TweenInfo.new(time or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GATAA_HUTAN_VIP"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = GetGuiParent()

local W, H = 260, 380
local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.Size = UDim2.new(0, W, 0, H)
main.BackgroundColor3 = BG
main.BackgroundTransparency = BG_TRANS
main.BorderSizePixel = 0
main.Parent = screenGui
corner(main, 10)
stroke(main, STROKE, 1, 0.3)

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = ELEM
header.BackgroundTransparency = ELEM_TRANS
header.BorderSizePixel = 0
header.Parent = main
corner(header, 10)
local headerCover = Instance.new("Frame")
headerCover.Size = UDim2.new(1, 0, 0.5, 0)
headerCover.Position = UDim2.new(0, 0, 0.5, 0)
headerCover.BackgroundColor3 = ELEM
headerCover.BackgroundTransparency = ELEM_TRANS
headerCover.BorderSizePixel = 0
headerCover.Parent = header

local titleLbl = Instance.new("TextLabel")
titleLbl.BackgroundTransparency = 1
titleLbl.Position = UDim2.new(0, 10, 0, 0)
titleLbl.Size = UDim2.new(1, -70, 1, 0)
titleLbl.Font = Enum.Font.GothamBold
titleLbl.Text = "GATAA HUTAN VIP"
titleLbl.TextColor3 = TEXT
titleLbl.TextSize = 11
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.Parent = header

local function headerBtn(txt, xOff)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 22, 0, 22)
    b.Position = UDim2.new(1, xOff, 0.5, -11)
    b.BackgroundColor3 = ELEM
    b.BackgroundTransparency = ELEM_TRANS
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamBold
    b.Text = txt
    b.TextColor3 = SUB
    b.TextSize = 12
    b.AutoButtonColor = false
    b.Parent = header
    corner(b, 5)
    b.MouseEnter:Connect(function() tween(b, 0.1, { BackgroundColor3 = ELEM_HOV, TextColor3 = TEXT }) end)
    b.MouseLeave:Connect(function() tween(b, 0.1, { BackgroundColor3 = ELEM,     TextColor3 = SUB  }) end)
    return b
end
local minBtn   = headerBtn("–", -56)
local closeBtn = headerBtn("×", -30)

local content = Instance.new("ScrollingFrame")
content.Position = UDim2.new(0, 0, 0, 30)
content.Size = UDim2.new(1, 0, 1, -30)
content.BackgroundTransparency = ELEM_TRANS
content.BorderSizePixel = 0
content.ScrollBarThickness = 3
content.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.Parent = main
pad(content, 8, 8, 8, 8)
local list = Instance.new("UIListLayout")
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Padding = UDim.new(0, 6)
list.Parent = content

local function MakeSection(text)
    local s = Instance.new("TextLabel")
    s.Size = UDim2.new(1, 0, 0, 14)
    s.BackgroundTransparency = 1
    s.Font = Enum.Font.GothamBold
    s.Text = string.upper(text)
    s.TextColor3 = SUB
    s.TextSize = 9
    s.TextXAlignment = Enum.TextXAlignment.Left
    s.Parent = content
    return s
end

local function MakeNote(text)
    local s = Instance.new("TextLabel")
    s.Size = UDim2.new(1, 0, 0, 22)
    s.BackgroundTransparency = 1
    s.Font = Enum.Font.Gotham
    s.Text = text
    s.TextColor3 = Color3.fromRGB(105, 105, 105)
    s.TextSize = 9
    s.TextWrapped = true
    s.TextXAlignment = Enum.TextXAlignment.Left
    s.Parent = content
    return s
end

local function MakeToggle(text, default, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 28)
    row.BackgroundColor3 = ELEM
    row.BackgroundTransparency = ELEM_TRANS
    row.BorderSizePixel = 0
    row.Parent = content
    corner(row, 6)
    stroke(row, STROKE, 1, 0.5)

    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.Size = UDim2.new(1, -55, 1, 0)
    lbl.Font = Enum.Font.GothamMedium
    lbl.Text = text
    lbl.TextColor3 = TEXT
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTruncate = Enum.TextTruncate.AtEnd
    lbl.Parent = row

    local state = default == true
    local pill = Instance.new("Frame")
    pill.AnchorPoint = Vector2.new(1, 0.5)
    pill.Position = UDim2.new(1, -10, 0.5, 0)
    pill.Size = UDim2.new(0, 30, 0, 16)
    pill.BackgroundColor3 = ELEM
    pill.BackgroundTransparency = ELEM_TRANS
    pill.BorderSizePixel = 0
    pill.Parent = row
    corner(pill, 8)

    local knob = Instance.new("Frame")
    knob.AnchorPoint = Vector2.new(0, 0.5)
    knob.Position = state and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.BackgroundColor3 = state and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(180, 180, 180)
    knob.BorderSizePixel = 0
    knob.Parent = pill
    corner(knob, 6)

    local hit = Instance.new("TextButton")
    hit.Size = UDim2.new(1, 0, 1, 0)
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.Parent = row

    local function render()
        tween(pill, 0.15, { BackgroundColor3 = state and ACCENT or Color3.fromRGB(50, 50, 50) })
        tween(knob, 0.15, {
            Position = state and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
            BackgroundColor3 = state and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(180, 180, 180),
        })
    end

    hit.MouseButton1Click:Connect(function()
        state = not state
        render()
        if callback then pcall(callback, state) end
    end)

    return {
        Set = function(v, silent)
            state = v == true
            render()
            if not silent and callback then pcall(callback, state) end
        end,
        Get = function() return state end,
    }
end

local function MakeSlider(text, min, max, default, step, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 42)
    row.BackgroundColor3 = ELEM
    row.BackgroundTransparency = ELEM_TRANS
    row.BorderSizePixel = 0
    row.Parent = content
    corner(row, 6)
    stroke(row, STROKE, 1, 0.5)

    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 10, 0, 4)
    lbl.Size = UDim2.new(1, -100, 0, 14)
    lbl.Font = Enum.Font.GothamMedium
    lbl.Text = text
    lbl.TextColor3 = TEXT
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTruncate = Enum.TextTruncate.AtEnd
    lbl.Parent = row

    local inputBox = Instance.new("TextBox")
    inputBox.AnchorPoint = Vector2.new(1, 0)
    inputBox.Position = UDim2.new(1, -8, 0, 3)
    inputBox.Size = UDim2.new(0, 76, 0, 16)
    inputBox.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    inputBox.BorderSizePixel = 0
    inputBox.Font = Enum.Font.GothamBold
    inputBox.Text = tostring(default)
    inputBox.TextColor3 = ACCENT
    inputBox.TextSize = 10
    inputBox.TextXAlignment = Enum.TextXAlignment.Center
    inputBox.ClearTextOnFocus = false
    inputBox.Parent = row
    corner(inputBox, 4)
    local inputStroke = stroke(inputBox, STROKE, 1, 0.6)

    local track = Instance.new("Frame")
    track.Position = UDim2.new(0, 10, 1, -14)
    track.Size = UDim2.new(1, -20, 0, 4)
    track.BackgroundColor3 = ELEM
    track.BackgroundTransparency = ELEM_TRANS
    track.BorderSizePixel = 0
    track.Parent = row
    corner(track, 2)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = ACCENT
    fill.BorderSizePixel = 0
    fill.Parent = track
    corner(fill, 2)

    local value = default
    local dragging = false
    local typing = false

    local function fmt(v)
        if step and step < 0.01 then return string.format("%.3f", v) end
        if step and step < 1 then return string.format("%.2f", v) end
        return tostring(math.floor(v + 0.5))
    end

    local function setVal(v, skipInputUpdate)
        v = tonumber(v) or value
        if step and step > 0 then
            v = math.floor(v / step + 0.5) * step
        end
        value = v
        local clamped = math.clamp(v, min, max)
        local pct = (clamped - min) / math.max(1e-6, max - min)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        if not skipInputUpdate and not typing then
            inputBox.Text = fmt(v)
        end
        if callback then pcall(callback, value) end
    end

    local hit = Instance.new("TextButton")
    hit.Size = UDim2.new(1, 0, 0, 20)
    hit.Position = UDim2.new(0, 0, 1, -22)
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.Parent = row

    local function updateFromX(px)
        local rel = (px - track.AbsolutePosition.X) / math.max(1, track.AbsoluteSize.X)
        setVal(min + math.clamp(rel, 0, 1) * (max - min))
    end

    hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromX(input.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromX(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    inputBox.Focused:Connect(function()
        typing = true
        tween(inputStroke, 0.1, { Color = ACCENT, Transparency = 0.1 })
    end)
    inputBox.FocusLost:Connect(function(enterPressed)
        typing = false
        tween(inputStroke, 0.15, { Color = STROKE, Transparency = 0.6 })
        local num = tonumber(inputBox.Text)
        if num then
            setVal(num, true)
        end
        inputBox.Text = fmt(value)
    end)

    setVal(default, true)

    return {
        Set = function(v) setVal(v) end,
        Get = function() return value end,
    }
end

local function MakeButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 28)
    btn.BackgroundColor3 = ELEM
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = TEXT
    btn.TextSize = 10
    btn.AutoButtonColor = false
    btn.Parent = content
    corner(btn, 6)
    stroke(btn, STROKE, 1, 0.5)
    btn.MouseEnter:Connect(function() tween(btn, 0.1, { BackgroundColor3 = ELEM_HOV }) end)
    btn.MouseLeave:Connect(function() tween(btn, 0.1, { BackgroundColor3 = ELEM }) end)
    btn.MouseButton1Click:Connect(function() if callback then pcall(callback) end end)
    return btn
end

local function Notify(titleText, msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "GATAA HUTAN VIP" .. tostring(titleText),
            Text = tostring(msg),
            Duration = 2,
        })
    end)
end

local function MakeDragHandle(handle)
    local dragging, dragStart, startPos = false, nil, nil
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos  = main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

MakeDragHandle(header)

local EDGE = 6
local edgeTop = Instance.new("Frame")
edgeTop.Size = UDim2.new(1, 0, 0, EDGE)
edgeTop.Position = UDim2.new(0, 0, 0, 0)
edgeTop.BackgroundTransparency = 1
edgeTop.ZIndex = 5
edgeTop.Parent = main

local edgeBottom = Instance.new("Frame")
edgeBottom.Size = UDim2.new(1, 0, 0, EDGE)
edgeBottom.Position = UDim2.new(0, 0, 1, -EDGE)
edgeBottom.BackgroundTransparency = 1
edgeBottom.ZIndex = 5
edgeBottom.Parent = main

local edgeLeft = Instance.new("Frame")
edgeLeft.Size = UDim2.new(0, EDGE, 1, 0)
edgeLeft.Position = UDim2.new(0, 0, 0, 0)
edgeLeft.BackgroundTransparency = 1
edgeLeft.ZIndex = 5
edgeLeft.Parent = main

local edgeRight = Instance.new("Frame")
edgeRight.Size = UDim2.new(0, EDGE, 1, 0)
edgeRight.Position = UDim2.new(1, -EDGE, 0, 0)
edgeRight.BackgroundTransparency = 1
edgeRight.ZIndex = 5
edgeRight.Parent = main

MakeDragHandle(edgeTop)
MakeDragHandle(edgeBottom)
MakeDragHandle(edgeLeft)
MakeDragHandle(edgeRight)

local miniIcon = Instance.new("TextButton")
miniIcon.Name = "MiniIcon"
miniIcon.Size = UDim2.new(0, 36, 0, 36)
miniIcon.Position = UDim2.new(0, 30, 0, 30)
miniIcon.AnchorPoint = Vector2.new(0.5, 0.5)
miniIcon.BackgroundColor3 = ELEM
miniIcon.BackgroundTransparency = ELEM_TRANS
miniIcon.BorderSizePixel = 0
miniIcon.Font = Enum.Font.GothamBlack
miniIcon.Text = "G"
miniIcon.TextColor3 = ACCENT
miniIcon.TextSize = 15
miniIcon.Visible = false
miniIcon.Parent = screenGui
corner(miniIcon, 10)
stroke(miniIcon, STROKE, 1, 0.4)

local savedOpenPosition = main.Position
local savedMiniPosition = nil
local minimized = false

local function setMinimized(state)
    if minimized == state then return end
    minimized = state
    if state then
        savedOpenPosition = main.Position
        main.Visible = false
        if savedMiniPosition then
            miniIcon.Position = savedMiniPosition
        else
            miniIcon.Position = main.Position
        end
        miniIcon.Visible = true
    else
        savedMiniPosition = miniIcon.Position
        main.Position = savedOpenPosition
        miniIcon.Visible = false
        main.Visible = true
    end
end

minBtn.MouseButton1Click:Connect(function() setMinimized(true) end)

do
    local dragging, dragStart, startPos = false, nil, nil
    local pressPos, moved = nil, false
    miniIcon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = miniIcon.Position
            pressPos  = input.Position
            moved     = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if (input.Position - pressPos).Magnitude > 5 then moved = true end
            miniIcon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging and not moved then
                setMinimized(false)
            end
            dragging = false
        end
    end)
end

closeBtn.MouseButton1Click:Connect(function()
    tween(main, 0.15, { BackgroundTransparency = 1 })
    task.delay(0.16, function() screenGui:Destroy() end)
end)

MakeSection("Forest Fling")

MakeButton("Run Server (WM_Req)", function()
    if RS:FindFirstChild("WM_Req") then
        Notify("Fling", "Server script already active")
        return
    end
    task.spawn(function()
        local ok, err = pcall(function()
            local remote  = Instance.new("RemoteEvent")
            remote.Name   = "WM_Req"
            remote.Parent = RS
            local function applyMass(char, density)
                if not char then return end
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                        p.CustomPhysicalProperties = PhysicalProperties.new(density, 0.3, 0.0, 0.1, 0.1)
                    end
                end
            end
            remote.OnServerEvent:Connect(function(sender, density)
                applyMass(sender.Character, density)
            end)
        end)
        Notify("Fling", ok and "Server script executed!" or ("Failed: " .. tostring(err)))
    end)
end)

-- ============================================================
-- MODIFIED: Brutal (Optimized Anti-Lag & 5 Million Coordinate)
-- ============================================================
MakeSection("Brutal")

local wBrut_enabled = false
local wBrut_lastPax = nil

-- KOORDINAT DIUBAH MENJADI 5 JUTA
local TARGET_CFRAME = CFrame.new(5000000, 5000000, 5000000)
local TARGET_POS    = TARGET_CFRAME.Position

-- [OPTIMASI ANTI-LAG] Fungsi mencari penumpang tanpa scan seluruh map
local function wBrut_getPax()
    local char = LocalPlayer.Character
    local myHum = char and char:FindFirstChildOfClass("Humanoid")
    local mySeat = myHum and myHum.SeatPart
    local myModel = mySeat and mySeat.Parent
    
    if not myModel then return nil end -- Jika kita tidak sedang di kendaraan, langsung keluar

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local pChar = plr.Character
            local pHum = pChar and pChar:FindFirstChildOfClass("Humanoid")
            local pSeat = pHum and pHum.SeatPart
            -- Cek apakah penumpang duduk di kendaraan yang SAMA
            if pSeat and pSeat.Parent == myModel then
                return pChar
            end
        end
    end
    return nil
end

local function wBrut_flingVictim(targetChar)
    if not targetChar then return end
    local root = targetChar:FindFirstChild("HumanoidRootPart")
    if root then
        local bp = Instance.new("BodyPosition")
        bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bp.Position = TARGET_POS
        bp.Parent = root
        
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = (TARGET_POS - root.Position).Unit * 100000 
        bv.Parent = root
        
        task.delay(3, function()
            if bp and bp.Parent then bp:Destroy() end
            if bv and bv.Parent then bv:Destroy() end
        end)
    end
end

RunService.Heartbeat:Connect(function()
    if not wBrut_enabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    
    local passenger = wBrut_getPax()
    
    if passenger ~= wBrut_lastPax then
        if passenger then
            wBrut_flingVictim(passenger)
        end
    end
    
    wBrut_lastPax = passenger
end)

LocalPlayer.CharacterAdded:Connect(function()
    wBrut_lastPax = nil
end)

MakeToggle("Brutal (Kirim ke Void)", false, function(state)
    wBrut_enabled = state
    if not state then
        wBrut_lastPax = nil
    end
end)

-- ============================================================
-- CHANGED: WalkFling (Tanpa Noclip)
-- ============================================================
MakeSection("WalkFling")

local _wfActive      = false
local _wfLoopThread  = nil

local function _wfLoop()
    local movel = 0.1
    repeat
        RunService.Heartbeat:Wait()
        local ch   = LocalPlayer and LocalPlayer.Character
        local root = ch and ch:FindFirstChild("HumanoidRootPart")

        while not (ch and ch.Parent and root and root.Parent) do
            RunService.Heartbeat:Wait()
            ch   = LocalPlayer and LocalPlayer.Character
            root = ch and ch:FindFirstChild("HumanoidRootPart")
        end

        local vel = root.AssemblyLinearVelocity
        root.AssemblyLinearVelocity = vel * 1e36 + Vector3.new(0, 1e36, 0)

        RunService.RenderStepped:Wait()
        if ch and ch.Parent and root and root.Parent then
            root.AssemblyLinearVelocity = vel
        end

        RunService.Stepped:Wait()
        if ch and ch.Parent and root and root.Parent then
            root.AssemblyLinearVelocity = vel + Vector3.new(0, movel, 0)
            movel = movel * -1
        end
    until not _wfActive
end

MakeToggle("WalkFling", false, function(state)
    _wfActive = state
    if state then
        _wfLoopThread = task.spawn(_wfLoop)
    end
end)

-- ============================================================
-- END CHANGED WALKFLING
-- ============================================================

-- ============================================================
-- CHANGED: Auto Sit (Hanya Tool & Optimasi Bebas Lag)
-- ============================================================
MakeSection("Auto Sit")

local wAS = {
    excludedPlayers = {},
    enabled         = false,
    wbModel         = nil,
    wbSeat          = nil,
    wbTick          = 0,
    maxDist         = 3000,
    autoTurun       = false,
    turunDelay      = 0.01,
    sitStartTick    = 0,
    sitTracked      = false,
    lastWB          = nil
}

local function wAS_isSeatFree(wbModel, myHum)
    for _, p in ipairs(wbModel:GetDescendants()) do
        if p:IsA("VehicleSeat") or p:IsA("Seat") then
            local occ = nil
            pcall(function() occ = p.Occupant end)
            if occ and occ ~= myHum then return false end
        end
    end
    return true
end

local function wAS_findPusher(wbModel)
    local handlesPart = nil
    pcall(function()
        for _, p in ipairs(wbModel:GetDescendants()) do
            if p:IsA("BasePart") and p.Name:lower() == "handles" then
                handlesPart = p; break
            end
        end
        if not handlesPart then
            for _, p in ipairs(wbModel:GetDescendants()) do
                if p:IsA("BasePart") then handlesPart = p; break end
            end
        end
    end)
    local function humFromPart(part)
        if not part then return nil end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local ch = plr.Character
                if ch and part:IsDescendantOf(ch) then
                    return ch:FindFirstChildOfClass("Humanoid")
                end
            end
        end
        return nil
    end
    local pusherHum = nil
    pcall(function()
        for _, w in ipairs(wbModel:GetDescendants()) do
            if w:IsA("Weld") or w:IsA("WeldConstraint") then
                pusherHum = humFromPart(w.Part0) or humFromPart(w.Part1)
                if pusherHum then return end
            end
        end
    end)
    if pusherHum then return pusherHum end
    pcall(function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local ch = plr.Character
                if ch then
                    for _, w in ipairs(ch:GetDescendants()) do
                        if w:IsA("Weld") or w:IsA("WeldConstraint") then
                            local p0inWB = w.Part0 and w.Part0:IsDescendantOf(wbModel)
                            local p1inWB = w.Part1 and w.Part1:IsDescendantOf(wbModel)
                            if p0inWB or p1inWB then
                                pusherHum = ch:FindFirstChildOfClass("Humanoid")
                                return
                            end
                        end
                    end
                end
            end
        end
    end)
    if pusherHum then return pusherHum end
    if handlesPart then
        local nearDist = 10
        pcall(function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    local ch   = plr.Character
                    local root = ch and ch:FindFirstChild("HumanoidRootPart")
                    if root then
                        local d = (root.Position - handlesPart.Position).Magnitude
                        if d < nearDist then
                            nearDist  = d
                            pusherHum = ch:FindFirstChildOfClass("Humanoid")
                        end
                    end
                end
            end
        end)
    end
    return pusherHum
end

local function wAS_humToPlayerName(hum)
    if not hum then return nil end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local ch = plr.Character
            if ch and ch:FindFirstChildOfClass("Humanoid") == hum then
                return plr.Name
            end
        end
    end
    return nil
end

local VEHICLE_PATTERNS_AS = {
    "wheel.*barrow", "^carriage$", "carriage", "gerobak", "^cart$", "vehicle",
}

local function wAS_findNearestWB(root, maxDist)
    local char  = LocalPlayer.Character
    local myHum = char and char:FindFirstChildOfClass("Humanoid")
    if myHum and myHum.SeatPart then
        local seatTool = myHum.SeatPart:FindFirstAncestorOfClass("Tool")
        if seatTool then return seatTool end
    end
    local best, bestDist = nil, maxDist
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") then
            local lname = obj.Name:lower()
            local isVehicle = false
            for _, pat in ipairs(VEHICLE_PATTERNS_AS) do
                if lname:match(pat) then isVehicle = true; break end
            end
            if isVehicle and obj ~= wAS.lastWB and wAS_isSeatFree(obj, myHum) then
                local pusherBlocking = false
                pcall(function()
                    local ph = wAS_findPusher(obj)
                    if ph then
                        local pName = wAS_humToPlayerName(ph)
                        if pName and wAS.excludedPlayers[pName] then
                            pusherBlocking = true
                            return
                        end
                        local pusherSeated = ph.SeatPart ~= nil
                        if not pusherSeated then
                            local stOk, st = pcall(function() return ph:GetState() end)
                            pusherSeated = stOk and (st == Enum.HumanoidStateType.Seated)
                        end
                        pusherBlocking = pusherSeated
                    end
                end)
                if not pusherBlocking then
                    local wbClosestDist = math.huge
                    for _, p in ipairs(obj:GetDescendants()) do
                        if p:IsA("BasePart") then
                            local d = (root.Position - p.Position).Magnitude
                            if d < wbClosestDist then
                                wbClosestDist = d
                            end
                        end
                    end
                    if wbClosestDist < bestDist then
                        bestDist = wbClosestDist
                        best = obj
                    end
                end
            end
        end
    end
    return best
end

local function wAS_getSeat(wbModel)
    if not wbModel then return nil end
    for _, p in ipairs(wbModel:GetDescendants()) do
        if p:IsA("VehicleSeat") then return p end
    end
    for _, p in ipairs(wbModel:GetDescendants()) do
        if p:IsA("Seat") then return p end
    end
    return nil
end

local function wAS_cleanup()
    wAS.wbModel      = nil
    wAS.wbSeat       = nil
    wAS.wbTick       = 0
    wAS.sitStartTick = 0
    wAS.sitTracked   = false
end

workspace.DescendantAdded:Connect(function(obj)
    if not wAS.enabled then return end
    if obj:IsA("Tool") then
        local n = obj.Name:lower()
        for _, pat in ipairs(VEHICLE_PATTERNS_AS) do
            if n:match(pat) then
                wAS.wbTick = 20
                break
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if not wAS.enabled then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not root or not hum then return end
    
    wAS.wbTick = wAS.wbTick + 1
    if wAS.wbTick >= 20 then
        wAS.wbTick = 0
        if wAS.wbModel and not wAS.wbModel.Parent then wAS_cleanup() end
        local found = wAS_findNearestWB(root, wAS.maxDist)
        if found and found ~= wAS.wbModel then
            wAS.wbModel = found
            wAS.wbSeat  = wAS_getSeat(found)
        elseif not found then
            wAS_cleanup()
        end
    end
    if wAS.wbSeat and wAS.wbSeat.Parent then
        pcall(function()
            if hum.SeatPart == wAS.wbSeat then
                if not hum.Sit then hum.Sit = true end
                if wAS.autoTurun then
                    if not wAS.sitTracked then
                        wAS.sitStartTick = tick()
                        wAS.sitTracked   = true
                    else
                        if tick() - wAS.sitStartTick >= wAS.turunDelay then
                            if wAS.wbModel then wAS.lastWB = wAS.wbModel end
                            hum.Sit = false
                            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
                            wAS_cleanup()
                        end
                    end
                end
            elseif not hum.SeatPart then
                wAS.sitTracked = false
                wAS.wbSeat:Sit(hum)
            end
        end)
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    wAS.wbModel      = nil
    wAS.wbSeat       = nil
    wAS.wbTick       = 0
    wAS.sitStartTick = 0
    wAS.sitTracked   = false
    wAS.lastWB       = nil
    
    if wAS.enabled then
        task.wait(0.5)
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            local found = wAS_findNearestWB(root, wAS.maxDist)
            if found then
                wAS.wbModel = found
                wAS.wbSeat  = wAS_getSeat(found)
            end
        end
    end
end)


MakeToggle("Auto Sit", false, function(state)
    wAS.enabled = state
    if state then
        wAS.lastWB = nil
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            local found = wAS_findNearestWB(root, wAS.maxDist)
            if found then
                wAS.wbModel = found
                wAS.wbSeat  = wAS_getSeat(found)
            end
        end
    else
        wAS_cleanup()
    end
end)

MakeToggle("Auto Turun", false, function(state)
    wAS.autoTurun    = state
    wAS.sitStartTick = 0
    wAS.sitTracked   = false
    wAS.lastWB       = nil
end)

-- ============================================================
-- PINDAH: Tombol !re ke bawah Auto Turun
-- ============================================================
MakeButton("Kirim !re (Respawn)", function()
    local char = LocalPlayer.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    pcall(function()
        game:GetService("Chat"):Chat(humanoid, "!re", Enum.ChatColor.Green)
    end)
    pcall(function()
        game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("!re")
    end)
    Notify("Chat", "Sent !re")
end)
-- ============================================================

-- ============================================================
-- CHANGED: Exclude Player (Input Teks)
-- ============================================================
local exclLabel = Instance.new("TextLabel")
exclLabel.Size = UDim2.new(1, 0, 0, 12)
exclLabel.BackgroundTransparency = 1
exclLabel.Font = Enum.Font.Gotham
exclLabel.Text = "Exclude Player (ketik nama & tekan Enter):"
exclLabel.TextColor3 = SUB
exclLabel.TextSize = 9
exclLabel.TextXAlignment = Enum.TextXAlignment.Left
exclLabel.Parent = content

local exclBox = Instance.new("TextBox")
exclBox.Size = UDim2.new(1, 0, 0, 24)
exclBox.BackgroundColor3 = ELEM
exclBox.BackgroundTransparency = ELEM_TRANS
exclBox.BorderSizePixel = 0
exclBox.Font = Enum.Font.GothamMedium
exclBox.PlaceholderText = "Ketik nama player..."
exclBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
exclBox.Text = ""
exclBox.TextColor3 = TEXT
exclBox.TextSize = 10
exclBox.ClearTextOnFocus = false
exclBox.Parent = content
corner(exclBox, 6)
stroke(exclBox, STROKE, 1, 0.5)

local exclFrame = Instance.new("Frame")
exclFrame.Size = UDim2.new(1, 0, 0, 80)
exclFrame.BackgroundColor3 = ELEM
exclFrame.BackgroundTransparency = ELEM_TRANS
exclFrame.BorderSizePixel = 0
exclFrame.Parent = content
corner(exclFrame, 6)
stroke(exclFrame, STROKE, 1, 0.5)

local exclScroll = Instance.new("ScrollingFrame")
exclScroll.Size = UDim2.new(1, -6, 1, -6)
exclScroll.Position = UDim2.new(0, 3, 0, 3)
exclScroll.BackgroundTransparency = 1
exclScroll.BorderSizePixel = 0
exclScroll.ScrollBarThickness = 3
exclScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
exclScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
exclScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
exclScroll.Parent = exclFrame
local exclList = Instance.new("UIListLayout")
exclList.SortOrder = Enum.SortOrder.LayoutOrder
exclList.Padding = UDim.new(0, 3)
exclList.Parent = exclScroll

local function refreshExclList()
    for _, child in ipairs(exclScroll:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextLabel") then 
            child:Destroy() 
        end
    end

    local hasAny = false
    for name, _ in pairs(wAS.excludedPlayers) do
        hasAny = true
        local row = Instance.new("TextButton")
        row.Size = UDim2.new(1, 0, 0, 22)
        row.BackgroundColor3 = Color3.fromRGB(38, 22, 22)
        row.BackgroundTransparency = ELEM_TRANS
        row.BorderSizePixel = 0
        row.Font = Enum.Font.GothamMedium
        row.Text = "  ❌ " .. name .. " (Klik hapus)"
        row.TextColor3 = Color3.fromRGB(220, 90, 90)
        row.TextSize = 9
        row.TextXAlignment = Enum.TextXAlignment.Left
        row.TextTruncate = Enum.TextTruncate.AtEnd
        row.AutoButtonColor = false
        row.Parent = exclScroll
        corner(row, 4)

        row.MouseButton1Click:Connect(function()
            wAS.excludedPlayers[name] = nil
            refreshExclList()
        end)
    end

    if not hasAny then
        local empty = Instance.new("TextLabel")
        empty.Size = UDim2.new(1, 0, 0, 22)
        empty.BackgroundTransparency = 1
        empty.Font = Enum.Font.Gotham
        empty.Text = "Belum ada player di-exclude."
        empty.TextColor3 = Color3.fromRGB(100, 100, 100)
        empty.TextSize = 9
        empty.TextXAlignment = Enum.TextXAlignment.Center
        empty.Parent = exclScroll
    end
end

exclBox.FocusLost:Connect(function(enterPressed)
    if not enterPressed then return end
    local query = exclBox.Text:lower()
    if query == "" then return end

    local foundPlayer = nil
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if plr.Name:lower():find(query) or plr.DisplayName:lower():find(query) then
                foundPlayer = plr
                break
            end
        end
    end

    if foundPlayer then
        if wAS.excludedPlayers[foundPlayer.Name] then
            wAS.excludedPlayers[foundPlayer.Name] = nil
            Notify("Exclude", "Membatalkan exclude: " .. foundPlayer.Name)
        else
            wAS.excludedPlayers[foundPlayer.Name] = true
            Notify("Exclude", "Mengecualikan: " .. foundPlayer.Name)
        end
        refreshExclList()
    else
        Notify("Exclude", "Player tidak ditemukan.")
    end
    exclBox.Text = ""
end)

refreshExclList()
-- ============================================================

-- ============================================================
-- ADDED: Wheelbarrow Owner Detector
-- ============================================================
MakeSection("Wheelbarrow Detector")

local wDetect_enabled   = false
local wDetect_highlights = {}
local wDetect_conn      = nil
local wDetect_lastCheck = 0

local function wDetect_hasWheelbarrow(plr)
    local backpack = plr:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local n = tool.Name:lower()
                if n:find("wheelbarrow") or n:find("wheel") or n:find("barrow") or n:find("gerobak") then
                    return true
                end
            end
        end
    end
    local char = plr.Character
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                local n = tool.Name:lower()
                if n:find("wheelbarrow") or n:find("wheel") or n:find("barrow") or n:find("gerobak") then
                    return true
                end
            end
        end
    end
    return false
end

local function wDetect_update()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            if char then
                local hasWB = wDetect_hasWheelbarrow(plr)
                local hl = wDetect_highlights[plr]

                if hasWB then
                    if not hl or not hl.Parent then
                        if hl then pcall(function() hl:Destroy() end) end
                        hl = Instance.new("Highlight")
                        hl.Name = "WheelbarrowHighlight"
                        hl.FillColor = Color3.fromRGB(255, 255, 0)
                        hl.OutlineColor = Color3.fromRGB(255, 255, 0)
                        hl.FillTransparency = 0.6
                        hl.OutlineTransparency = 0.3
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.Adornee = char
                        hl.Parent = char
                        wDetect_highlights[plr] = hl
                    else
                        hl.Adornee = char
                    end
                else
                    if hl then
                        hl:Destroy()
                        wDetect_highlights[plr] = nil
                    end
                end
            else
                if wDetect_highlights[plr] then
                    wDetect_highlights[plr]:Destroy()
                    wDetect_highlights[plr] = nil
                end
            end
        end
    end
end

local function wDetect_hookPlayer(plr)
    if plr == LocalPlayer then return end
    plr.CharacterAdded:Connect(function()
        task.wait(0.5)
        if wDetect_enabled then wDetect_update() end
    end)
    plr.CharacterRemoving:Connect(function()
        if wDetect_highlights[plr] then
            wDetect_highlights[plr]:Destroy()
            wDetect_highlights[plr] = nil
        end
    end)
end

for _, plr in ipairs(Players:GetPlayers()) do wDetect_hookPlayer(plr) end
Players.PlayerAdded:Connect(wDetect_hookPlayer)
Players.PlayerRemoving:Connect(function(plr)
    if wDetect_highlights[plr] then
        wDetect_highlights[plr]:Destroy()
        wDetect_highlights[plr] = nil
    end
end)

MakeToggle("Detect Wheelbarrow Owner", false, function(state)
    wDetect_enabled = state
    if state then
        wDetect_update()
        wDetect_conn = RunService.Heartbeat:Connect(function()
            if not wDetect_enabled then return end
            if tick() - wDetect_lastCheck > 0.1 then
                wDetect_lastCheck = tick()
                wDetect_update()
            end
        end)
    else
        if wDetect_conn then
            wDetect_conn:Disconnect()
            wDetect_conn = nil
        end
        for plr, hl in pairs(wDetect_highlights) do
            if hl then hl:Destroy() end
        end
        table.clear(wDetect_highlights)
    end
end)
-- ============================================================

MakeSection("Wheelbarrow Fly")

local wFly_speed   = 60
local wFly_enabled = false
local wFly_UIS     = UserInputService

local wFly_thumbX  = 0
local wFly_thumbY  = 0
local wFly_mobUp   = false
local wFly_mobDown = false
local wFly_mobFwd  = false
local wFly_mobBwd  = false
local wFly_mobUpB  = nil
local wFly_mobDnB  = nil
local wFly_mobFwdB = nil
local wFly_mobBwdB = nil

local wFly_wbLV      = nil
local wFly_wbAtt     = nil
local wFly_wbBase    = nil
local wFly_wbWelds   = {}
local wFly_wbAnchSave = {}
local wFly_wbModel   = nil
local wFly_wbTick    = 0
local wFly_wbSeat    = nil
local wFly_savedWS   = 16
local wFly_savedJP   = 50

pcall(function()
    wFly_UIS.ThumbstickMoved:Connect(function(stick, pos)
        if stick == Enum.KeyCode.Thumbstick1 then
            wFly_thumbX = pos.X
            wFly_thumbY = pos.Y
        end
    end)
end)

local wFly_isTouch = (function()
    local ok, v = pcall(function() return wFly_UIS.TouchEnabled end)
    return ok and v == true
end)()

task.spawn(function()
    if not wFly_isTouch then return end
    local playerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
    if not playerGui then return end
    task.wait(1.5)

    local gui          = Instance.new("ScreenGui")
    gui.Name           = "DWbFlyMobile"
    gui.ResetOnSpawn   = false
    gui.IgnoreGuiInset = true
    gui.Parent         = playerGui

    local BTN  = 48
    local STEP = 54
    local CX   = 136
    local CY   = 148

    local function mkBtn(icon)
        local b = Instance.new("TextButton")
        b.Size                   = UDim2.new(0, BTN, 0, BTN)
        b.BackgroundColor3       = Color3.fromRGB(14, 14, 14)
        b.BackgroundTransparency = 0.28
        b.TextColor3             = Color3.fromRGB(210, 210, 210)
        b.Text                   = icon
        b.TextSize               = 19
        b.Font                   = Enum.Font.GothamBold
        b.AutoButtonColor        = false
        b.Visible                = false
        b.Parent                 = gui
        corner(b, 10)
        stroke(b, Color3.fromRGB(160, 160, 160), 1, 0.55)
        return b
    end

    local half = BTN / 2
    wFly_mobFwdB          = mkBtn("▲")
    wFly_mobFwdB.Position = UDim2.new(1, -(CX + half), 1, -(CY + STEP + half))
    wFly_mobBwdB          = mkBtn("▼")
    wFly_mobBwdB.Position = UDim2.new(1, -(CX + half), 1, -(CY - STEP + half))
    wFly_mobUpB           = mkBtn("\u{2191}")
    wFly_mobUpB.Position  = UDim2.new(1, -(CX + STEP + half), 1, -(CY + half))
    wFly_mobDnB           = mkBtn("\u{2193}")
    wFly_mobDnB.Position  = UDim2.new(1, -(CX - STEP + half), 1, -(CY + half))

    local function bindBtn(btn, onBegin, onEnd)
        btn.InputBegan:Connect(function(i)
            if i.UserInputType ~= Enum.UserInputType.Touch then return end
            btn.BackgroundTransparency = 0.08
            onBegin()
        end)
        btn.InputEnded:Connect(function(i)
            if i.UserInputType ~= Enum.UserInputType.Touch then return end
            btn.BackgroundTransparency = 0.28
            onEnd()
        end)
    end
    bindBtn(wFly_mobFwdB, function() wFly_mobFwd  = true  end, function() wFly_mobFwd  = false end)
    bindBtn(wFly_mobBwdB, function() wFly_mobBwd  = true  end, function() wFly_mobBwd  = false end)
    bindBtn(wFly_mobUpB,  function() wFly_mobUp   = true  end, function() wFly_mobUp   = false end)
    bindBtn(wFly_mobDnB,  function() wFly_mobDown = true  end, function() wFly_mobDown = false end)
end)

local function wFly_makeLV(part)
    local att             = Instance.new("Attachment")
    att.Position          = Vector3.zero
    att.Parent            = part
    local lv              = Instance.new("LinearVelocity")
    lv.Attachment0        = att
    lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
    lv.RelativeTo         = Enum.ActuatorRelativeTo.World
    lv.VectorVelocity     = Vector3.zero
    lv.MaxForce           = math.huge
    lv.Parent             = part
    return lv, att
end

local function wFly_cleanupWb()
    pcall(function() if wFly_wbLV  then wFly_wbLV:Destroy()  end end)
    pcall(function() if wFly_wbAtt then wFly_wbAtt:Destroy() end end)
    for _, w in ipairs(wFly_wbWelds) do pcall(function() w:Destroy() end) end
    wFly_wbWelds = {}
    for part, wasAnch in pairs(wFly_wbAnchSave) do
        pcall(function() part.Anchored = wasAnch end)
    end
    wFly_wbAnchSave = {}
    wFly_wbLV, wFly_wbAtt, wFly_wbBase, wFly_wbModel = nil, nil, nil, nil
    wFly_wbSeat = nil
end

local VEHICLE_PATTERNS_FLY = {
    "wheel.*barrow", "^carriage$", "carriage", "gerobak", "^cart$", "vehicle",
}
local function wFly_findNearestWB(root, maxDist)
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.SeatPart then
            local seatModel = hum.SeatPart:FindFirstAncestorOfClass("Model")
            if seatModel then return seatModel end
        end
    end
    local best, bestDist = nil, maxDist
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local lname = obj.Name:lower()
            local isVehicle = false
            for _, pat in ipairs(VEHICLE_PATTERNS_FLY) do
                if lname:match(pat) then isVehicle = true; break end
            end
            if isVehicle then
                for _, p in ipairs(obj:GetDescendants()) do
                    if p:IsA("BasePart") then
                        local d = (root.Position - p.Position).Magnitude
                        if d < bestDist then bestDist = d; best = obj end
                        break
                    end
                end
            end
        end
    end
    return best
end

local function wFly_attachWb(wbModel)
    wFly_cleanupWb()
    local base = wbModel:FindFirstChild("Base") or wbModel:FindFirstChild("Chassis")
    if not base then
        for _, p in ipairs(wbModel:GetDescendants()) do
            if p:IsA("VehicleSeat") or p:IsA("Seat") then base = p; break end
        end
    end
    if not base then
        for _, p in ipairs(wbModel:GetDescendants()) do
            if p:IsA("BasePart") then base = p; break end
        end
    end
    if not base then return end
    wFly_wbModel = wbModel
    wFly_wbBase  = base
    wFly_wbAnchSave[base] = base.Anchored
    pcall(function() base.Anchored = false end)
    for _, p in ipairs(wbModel:GetDescendants()) do
        if p:IsA("BasePart") and p ~= base then
            wFly_wbAnchSave[p] = p.Anchored
            pcall(function() p.Anchored = false end)
            local wc   = Instance.new("WeldConstraint")
            wc.Part0   = base
            wc.Part1   = p
            wc.Parent  = base
            table.insert(wFly_wbWelds, wc)
        end
    end
    for _, inst in ipairs(base:GetDescendants()) do
        if inst:IsA("BodyVelocity") then
            pcall(function() inst.maxForce = Vector3.zero end)
        elseif inst:IsA("BodyAngularVelocity") then
            pcall(function() inst.maxTorque = Vector3.zero end)
        end
    end
    for _, inst in ipairs(wbModel:GetDescendants()) do
        if inst:IsA("BodyVelocity") then
            pcall(function() inst.maxForce = Vector3.zero end)
        elseif inst:IsA("BodyAngularVelocity") then
            pcall(function() inst.maxTorque = Vector3.zero end)
        end
    end
    wFly_wbLV, wFly_wbAtt = wFly_makeLV(base)
    wFly_wbSeat = nil
    for _, p in ipairs(wbModel:GetDescendants()) do
        if p:IsA("Seat") or p:IsA("VehicleSeat") then wFly_wbSeat = p; break end
    end
end

RunService.Heartbeat:Connect(function()
    if not wFly_enabled then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not root then return end
    local cam = workspace.CurrentCamera
    if not cam then return end
    wFly_wbTick = wFly_wbTick + 1
    if wFly_wbTick >= 20 then
        wFly_wbTick = 0
        if wFly_wbModel and not wFly_wbModel.Parent then wFly_cleanupWb() end
        local found = wFly_findNearestWB(root, 8)
        if found and found ~= wFly_wbModel then
            wFly_attachWb(found)
        elseif not found and wFly_wbModel then
            wFly_cleanupWb()
        end
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(function()
            if hum.JumpPower ~= 0  then hum.JumpPower = 0  end
        end)
        if wFly_wbSeat then
            pcall(function()
                if hum.SeatPart == wFly_wbSeat then
                    if not hum.Sit then hum.Sit = true end
                elseif not hum.SeatPart then
                    wFly_wbSeat:Sit(hum)
                end
            end)
        end
    end
    local hDir = Vector3.zero
    local vY   = 0
    if wFly_isTouch then
        local dz = 0.15
        if math.abs(wFly_thumbX) > dz or math.abs(wFly_thumbY) > dz then
            local fwd = cam.CFrame.LookVector
            local rgt = cam.CFrame.RightVector
            fwd = Vector3.new(fwd.X, 0, fwd.Z)
            rgt = Vector3.new(rgt.X, 0, rgt.Z)
            if fwd.Magnitude > 0.01 then fwd = fwd.Unit end
            if rgt.Magnitude > 0.01 then rgt = rgt.Unit end
            hDir = rgt * wFly_thumbX + fwd * wFly_thumbY
        end
        if wFly_mobFwd or wFly_mobBwd then
            local fwd = cam.CFrame.LookVector
            fwd = Vector3.new(fwd.X, 0, fwd.Z)
            if fwd.Magnitude > 0.01 then fwd = fwd.Unit end
            if wFly_mobFwd then hDir = hDir + fwd end
            if wFly_mobBwd then hDir = hDir - fwd end
        end
        if wFly_mobUp   then vY =  1 end
        if wFly_mobDown then vY = -1 end
    else
        local lv = cam.CFrame.LookVector
        local rv = cam.CFrame.RightVector
        local flatFwd = Vector3.new(lv.X, 0, lv.Z)
        local flatRgt = Vector3.new(rv.X, 0, rv.Z)
        if flatFwd.Magnitude > 0.01 then flatFwd = flatFwd.Unit end
        if flatRgt.Magnitude > 0.01 then flatRgt = flatRgt.Unit end
        if wFly_UIS:IsKeyDown(Enum.KeyCode.W) then hDir = hDir + flatFwd end
        if wFly_UIS:IsKeyDown(Enum.KeyCode.S) then hDir = hDir - flatFwd end
        if wFly_UIS:IsKeyDown(Enum.KeyCode.A) then hDir = hDir - flatRgt end
        if wFly_UIS:IsKeyDown(Enum.KeyCode.D) then hDir = hDir + flatRgt end
        if wFly_UIS:IsKeyDown(Enum.KeyCode.Space)     then vY =  1 end
        if wFly_UIS:IsKeyDown(Enum.KeyCode.LeftShift) then vY = -1 end
    end
    if hDir.Magnitude > 0.01 then hDir = hDir.Unit end
    local vel = Vector3.new(hDir.X, vY, hDir.Z) * wFly_speed
    pcall(function()
        root.AssemblyLinearVelocity  = vel
        root.AssemblyAngularVelocity = Vector3.zero
    end)
    if wFly_wbLV and wFly_wbLV.Parent then
        wFly_wbLV.VectorVelocity = vel
    end
    if wFly_wbBase and wFly_wbBase.Parent then
        pcall(function()
            wFly_wbBase.AssemblyAngularVelocity = Vector3.zero
            wFly_wbBase.AssemblyLinearVelocity  = vel
        end)
    end
end)

MakeSlider("Fly Speed", 10, 300, 60, 5, function(v) wFly_speed = v end)
MakeToggle("Wheelbarrow Fly", false, function(state)
    wFly_enabled = state
    pcall(function()
        if wFly_mobUpB  then wFly_mobUpB.Visible  = state end
        if wFly_mobDnB  then wFly_mobDnB.Visible  = state end
        if wFly_mobFwdB then wFly_mobFwdB.Visible = state end
        if wFly_mobBwdB then wFly_mobBwdB.Visible = state end
    end)
    if state then
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                pcall(function()
                    wFly_savedWS = hum.WalkSpeed
                    wFly_savedJP = hum.JumpPower
                    hum.WalkSpeed = 16
                    hum.JumpPower = 0
                end)
            end
            local found = wFly_findNearestWB(root, 8)
            if found then wFly_attachWb(found) end
        end
    else
        local char = LocalPlayer.Character
        if char then
            local hum  = char:FindFirstChildOfClass("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")
            if hum then
                pcall(function()
                    hum.WalkSpeed = wFly_savedWS
                    hum.JumpPower = wFly_savedJP
                end)
            end
            if root then
                pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
            end
        end
        wFly_cleanupWb()
        wFly_wbTick = 0
        wFly_thumbX, wFly_thumbY = 0, 0
        wFly_mobUp, wFly_mobDown = false, false
        wFly_mobFwd, wFly_mobBwd = false, false
    end
end)

LocalPlayer.CharacterAdded:Connect(function(newChar)
    if not wFly_enabled then return end
    wFly_cleanupWb()
    wFly_wbTick = 0
    task.wait(0.3)
    local hum = newChar:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(function()
            wFly_savedWS = hum.WalkSpeed
            wFly_savedJP = hum.JumpPower
        end)
    end
end)

-- ============================================================
-- CHANGED: Movement (Standard WalkSpeed)
-- ============================================================
MakeSection("Movement")

local wsValue = 30

local function applyWalkSpeed()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = wsValue
    end
end

MakeSlider("Walk Speed", 1, 300, 30, 1, function(v)
    wsValue = v
    if wFly_enabled then
        wFly_savedWS = v 
    end
    applyWalkSpeed()
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    applyWalkSpeed()
end)

-- ============================================================
-- UPDATED: Weight Control (Max 100.000)
-- ============================================================
MakeSection("Weight Control")

local customWeightDensity = 1000
local weightEnabled = false

local function applyWeight()
    local char = LocalPlayer.Character
    if not char then return end
    
    if weightEnabled then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function()
                    part.CustomPhysicalProperties = PhysicalProperties.new(customWeightDensity, 0.3, 0.5, 1, 1)
                end)
            end
        end
    else
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function()
                    part.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5, 1, 1)
                end)
            end
        end
    end
end

MakeNote("Max 100.000. Jika loncat-loncat, turunkan angkanya!")

MakeSlider("Density (Berat)", 0.01, 100000, 1000, 10, function(v)
    customWeightDensity = v
    applyWeight()
end)

MakeToggle("Aktifkan Berat Custom", false, function(state)
    weightEnabled = state
    applyWeight()
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    applyWeight()
end)

-- ============================================================
-- ADDED: Extra Services for new features
-- ============================================================
local VirtualInputManager = game:GetService("VirtualInputManager")

-- ============================================================
-- ADDED: Stone & Spam
-- ============================================================
MakeSection("Stone & Spam")

local STONE_CFRAME        = CFrame.new(311.80, 60.66, -1048.49)
local SPAM_isBusy         = false
local SPAM_isSpamming     = false
local SPAM_spamConn       = nil
local SPAM_promptSet      = {}

local function SPAM_fixPrompt(obj)
    if obj:IsA("ProximityPrompt") then
        obj.HoldDuration = 0
        SPAM_promptSet[obj] = true
        obj.Destroying:Connect(function() SPAM_promptSet[obj] = nil end)
    end
end

for _, obj in ipairs(workspace:GetDescendants()) do SPAM_fixPrompt(obj) end
workspace.DescendantAdded:Connect(SPAM_fixPrompt)

local function SPAM_promptPosition(prompt)
    local p = prompt.Parent
    if not p then return nil end
    if p:IsA("BasePart") then return p.Position end
    if p:IsA("Attachment") then return p.WorldPosition end
    if p:IsA("Model") then return p:GetPivot().Position end
    return nil
end

local function SPAM_takeStone(callback)
    if SPAM_isBusy then
        if callback then callback(false, "busy") end
        return
    end
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        if callback then callback(false, "no-hrp") end
        return
    end
    SPAM_isBusy = true
    local originalCFrame = hrp.CFrame
    pcall(function() hrp.CFrame = STONE_CFRAME end)
    task.wait(0.5)
    local found = false
    pcall(function()
        local best, bestDist = nil, math.huge
        for obj in pairs(SPAM_promptSet) do
            if obj.Parent then
                local text = (obj.ActionText .. " " .. obj.ObjectText):lower()
                if text:find("batu") or text:find("bawa") or text:find("ambil") then
                    local pos = SPAM_promptPosition(obj)
                    local d   = pos and (pos - hrp.Position).Magnitude or math.huge
                    if d < bestDist then best, bestDist = obj, d end
                end
            end
        end
        if best then fireproximityprompt(best); found = true end
        task.wait(0.1)
        pcall(function()
            VirtualInputManager:SendKeyEvent(true,  Enum.KeyCode.E, false, game)
            task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
        end)
        task.wait(0.3)
    end)
    pcall(function() hrp.CFrame = originalCFrame end)
    SPAM_isBusy = false
    if callback then callback(true, found) end
end

local function SPAM_findTool(char, backpack)
    if char then
        for _, obj in ipairs(char:GetChildren()) do
            if obj:IsA("Tool") then return obj end
        end
    end
    if backpack then
        for _, obj in ipairs(backpack:GetChildren()) do
            if obj:IsA("Tool") then return obj end
        end
    end
    return nil
end

local function SPAM_startSpam()
    if SPAM_spamConn then SPAM_spamConn:Disconnect() end
    SPAM_isSpamming = true
    SPAM_spamConn = RunService.Heartbeat:Connect(function()
        if SPAM_isBusy then return end
        local char     = LocalPlayer.Character
        local hum      = char and char:FindFirstChildOfClass("Humanoid")
        local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        if not hum or hum.Health <= 0 then return end
        local tool = SPAM_findTool(char, backpack)
        if not tool then return end
        if tool.Parent == char then
            pcall(function() hum:UnequipTools() end)
        else
            pcall(function() hum:EquipTool(tool) end)
        end
    end)
end

local function SPAM_stopSpam()
    SPAM_isSpamming = false
    if SPAM_spamConn then SPAM_spamConn:Disconnect(); SPAM_spamConn = nil end
    local char = LocalPlayer.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if hum then pcall(function() hum:UnequipTools() end) end
end

MakeButton("📍 Ambil Batu (TP + E)", function()
    if SPAM_isBusy then
        Notify("Stone", "Masih sibuk...")
        return
    end
    Notify("Stone", "Teleport & ambil batu...")
    SPAM_takeStone(function(ok, found)
        if not ok then
            Notify("Stone", "Gagal — HRP tidak ada")
        else
            Notify("Stone", found and "Batu diambil!" or "Tombol E ditekan")
        end
    end)
end)

MakeToggle("Spam Tool", false, function(state)
    if state then
        SPAM_startSpam()
    else
        SPAM_stopSpam()
    end
end)

-- ============================================================
-- ADDED: Anti Fling
-- ============================================================
local AF_PLAYER_RADIUS = 80
local AF_PART_RADIUS   = 30
local AF_PART_VEL      = 70
local AF_PART_ANG      = 40
local AF_VEL_EXTRA     = 120
local AF_UP_LIMIT      = 150
local AF_ANG_LIMIT     = 50

local AF_enabled    = false
local AF_conns      = {}
local AF_charConns  = setmetatable({}, { __mode = "k" })
local AF_charParts  = setmetatable({}, { __mode = "k" })
local AF_isCharPart = setmetatable({}, { __mode = "k" })
local AF_flipped    = setmetatable({}, { __mode = "k" })
local AF_softParts  = setmetatable({}, { __mode = "k" })

local AF_overlap = OverlapParams.new()
AF_overlap.FilterType        = Enum.RaycastFilterType.Exclude
AF_overlap.MaxParts          = 60
AF_overlap.RespectCanCollide = false
local AF_overlapChar = nil
local AF_safeChar, AF_lastSafe, AF_badStreak = nil, nil, 0

local function AF_trackChar(char)
    local list = {}
    for _, d in ipairs(char:GetDescendants()) do
        if d:IsA("BasePart") then list[#list+1] = d; AF_isCharPart[d] = true end
    end
    AF_charParts[char] = list
    AF_charConns[char] = char.DescendantAdded:Connect(function(d)
        if d:IsA("BasePart") then list[#list+1] = d; AF_isCharPart[d] = true end
    end)
end

local function AF_untrackChar(char)
    AF_charParts[char] = nil
    local c = AF_charConns[char]
    if c then c:Disconnect() end
    AF_charConns[char] = nil
end

local function AF_trackPlayer(plr)
    if plr == LocalPlayer then return end
    if plr.Character then AF_trackChar(plr.Character) end
    table.insert(AF_conns, plr.CharacterAdded:Connect(AF_trackChar))
    table.insert(AF_conns, plr.CharacterRemoving:Connect(AF_untrackChar))
end

local function AF_applyStates(on)
    local char = LocalPlayer.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(function()
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, not on)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,     not on)
        end)
    end
end

local function AF_stepped()
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local myPos = hrp.Position

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local c    = plr.Character
            local list = c and AF_charParts[c]
            local root = c and c:FindFirstChild("HumanoidRootPart")
            if list and root and (root.Position - myPos).Magnitude < AF_PLAYER_RADIUS then
                for i = 1, #list do
                    local p = list[i]
                    if p.CanCollide then p.CanCollide = false; AF_flipped[p] = true end
                end
            end
        end
    end

    if char ~= AF_overlapChar then
        AF_overlap.FilterDescendantsInstances = { char }
        AF_overlapChar = char
    end
    local myRoot = hrp.AssemblyRootPart
    local now    = os.clock()
    local parts  = workspace:GetPartBoundsInRadius(myPos, AF_PART_RADIUS, AF_overlap)
    for i = 1, #parts do
        local p = parts[i]
        if not p.Anchored and not AF_isCharPart[p] and p.AssemblyRootPart ~= myRoot then
            if p.AssemblyLinearVelocity.Magnitude > AF_PART_VEL
               or p.AssemblyAngularVelocity.Magnitude > AF_PART_ANG then
                if p.CanCollide then p.CanCollide = false; AF_softParts[p] = now
                elseif AF_softParts[p] then AF_softParts[p] = now end
            end
        end
    end
    for p, t in pairs(AF_softParts) do
        if now - t > 0.4 then
            if p.Parent then p.CanCollide = true end
            AF_softParts[p] = nil
        end
    end
end

local function AF_heartbeat()
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if not (hrp and hum) or hum.Health <= 0 then return end
    if char ~= AF_safeChar then AF_safeChar = char; AF_lastSafe = nil; AF_badStreak = 0 end
    if hum.SeatPart then AF_lastSafe = nil; return end

    local lv    = hrp.AssemblyLinearVelocity
    local av    = hrp.AssemblyAngularVelocity
    local horiz = math.sqrt(lv.X*lv.X + lv.Z*lv.Z)
    local bad   = horiz > (hum.WalkSpeed + AF_VEL_EXTRA)
               or lv.Y > AF_UP_LIMIT
               or av.Magnitude > AF_ANG_LIMIT

    if bad and AF_badStreak < 30 then
        AF_badStreak += 1
        hrp.AssemblyLinearVelocity  = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        if AF_lastSafe then hrp.CFrame = AF_lastSafe end
    else
        if not bad then AF_badStreak = 0 end
        AF_lastSafe = hrp.CFrame
    end
end

local function AF_set(on)
    if on == AF_enabled then return end
    AF_enabled = on
    if on then
        for _, plr in ipairs(Players:GetPlayers()) do AF_trackPlayer(plr) end
        table.insert(AF_conns, Players.PlayerAdded:Connect(AF_trackPlayer))
        table.insert(AF_conns, RunService.Stepped:Connect(AF_stepped))
        table.insert(AF_conns, RunService.Heartbeat:Connect(AF_heartbeat))
        AF_applyStates(true)
    else
        for _, c in ipairs(AF_conns) do c:Disconnect() end
        AF_conns = {}
        for ch in pairs(AF_charConns) do AF_untrackChar(ch) end
        for p in pairs(AF_softParts) do if p.Parent then p.CanCollide = true end end
        for p in pairs(AF_flipped) do if p.Parent then p.CanCollide = true end end
        table.clear(AF_softParts); table.clear(AF_flipped); table.clear(AF_isCharPart)
        AF_safeChar, AF_lastSafe, AF_badStreak, AF_overlapChar = nil, nil, 0, nil
        AF_applyStates(false)
    end
end

MakeToggle("Anti Fling", false, function(state)
    AF_set(state)
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 10)
    if hum and AF_enabled then AF_applyStates(true) end
end)

-- ============================================================
-- ADDED: Piano Spam
-- ============================================================
MakeSection("Piano Spam")

local PIANO_EVENT_NAME    = "GlobalPianoConnector"
local PIANO_NOTE_START    = 1
local PIANO_NOTE_END      = 61
local PIANO_PER_KEY_RATE  = 610
local PIANO_NUM_KEYS      = PIANO_NOTE_END - PIANO_NOTE_START + 1
local PIANO_TOTAL_RATE    = PIANO_NUM_KEYS * PIANO_PER_KEY_RATE

local PIANO_CFRAME_1 = CFrame.new(363.90, 81.70, -1218.41)
local PIANO_CFRAME_2 = CFrame.new(80.75, 69.53, -763.07)

local PIANO_enabled   = false
local PIANO_fireCount = 0
local PIANO_thread    = nil

local function PIANO_getEvent()
    local ev = workspace:FindFirstChild(PIANO_EVENT_NAME)
    if ev and ev:IsA("RemoteEvent") then return ev end
    return nil
end

local function PIANO_startSpam()
    if PIANO_thread then
        pcall(function() task.cancel(PIANO_thread) end)
        PIANO_thread = nil
    end
    PIANO_thread = task.spawn(function()
        local clock      = os.clock
        local startT     = clock()
        local baseCount  = PIANO_fireCount
        local n          = PIANO_NUM_KEYS
        local startNote  = PIANO_NOTE_START
        local totalRate  = PIANO_TOTAL_RATE
        local pcall_l    = pcall

        while PIANO_enabled do
            local ev = PIANO_getEvent()
            if not ev then
                PIANO_enabled = false
                Notify("Piano", "Remote hilang")
                if pianoToggle then pianoToggle:Set(false, true) end
                break
            end

            local fire  = ev.FireServer
            local obj   = ev
            local elapsed      = clock() - startT
            local targetTotal  = math.floor(elapsed * totalRate)
            local alreadyFired = PIANO_fireCount - baseCount
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
                    PIANO_fireCount += needed
                else
                    local idx = offset
                    for _ = 1, needed do
                        if pcall_l(fire, obj, "play", startNote + (idx % n)) then
                            PIANO_fireCount += 1
                        end
                        idx += 1
                    end
                end
            end

            task.wait()
        end
    end)
end

local pianoToggle
pianoToggle = MakeToggle(
    string.format("Piano Spam (%d×%d/s)", PIANO_NUM_KEYS, PIANO_PER_KEY_RATE),
    false,
    function(state)
        if state then
            local ev = PIANO_getEvent()
            if not ev then
                Notify("Piano", PIANO_EVENT_NAME .. " tidak ditemukan")
                if pianoToggle then pianoToggle:Set(false, true) end
                return
            end
            PIANO_enabled = true
            PIANO_startSpam()
        else
            PIANO_enabled = false
            if PIANO_thread then
                pcall(function() task.cancel(PIANO_thread) end)
                PIANO_thread = nil
            end
        end
    end
)

MakeButton("📌 TP ke Piano 1", function()
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = PIANO_CFRAME_1 end
end)

MakeButton("📌 TP ke Piano 2", function()
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = PIANO_CFRAME_2 end
end)

-- ============================================================
-- ADDED: Blokir Remote Event (SUPER CEPAT)
-- ============================================================
local remoteBlockEnabled = false
local targetBlockRemote = nil
local activeWrappers = {}

MakeToggle("Blokir Remote Play (Anti-Lag)", false, function(state)
    remoteBlockEnabled = state
    targetBlockRemote = workspace:FindFirstChild("GlobalPianoConnector")
    
    if state then
        if targetBlockRemote then
            pcall(function()
                for _, conn in pairs(getconnections(targetBlockRemote.OnClientEvent)) do
                    if not activeWrappers[conn] then
                        local oldFunc = conn.Function
                        if oldFunc then
                            conn:Disconnect()
                            local newConn = targetBlockRemote.OnClientEvent:Connect(function(action, ...)
                                if remoteBlockEnabled and action == "play" then return end
                                return oldFunc(action, ...)
                            end)
                            activeWrappers[newConn] = true
                        end
                    end
                end
            end)
            Notify("Piano", "Remote 'Play' ditolak secepat mungkin.")
        else
            Notify("Piano", "Remote tidak ditemukan.")
        end
    else
        Notify("Piano", "Blokir Remote dimatikan.")
    end
end)

task.spawn(function()
    while true do
        RunService.Stepped:Wait()
        if remoteBlockEnabled then
            if not targetBlockRemote or not targetBlockRemote.Parent then
                targetBlockRemote = workspace:FindFirstChild("GlobalPianoConnector")
                table.clear(activeWrappers)
            end
            if targetBlockRemote then
                pcall(function()
                    for _, conn in pairs(getconnections(targetBlockRemote.OnClientEvent)) do
                        if not activeWrappers[conn] then
                            local oldFunc = conn.Function
                            if oldFunc then
                                conn:Disconnect()
                                local newConn = targetBlockRemote.OnClientEvent:Connect(function(action, ...)
                                    if remoteBlockEnabled and action == "play" then return end
                                    return oldFunc(action, ...)
                                end)
                                activeWrappers[newConn] = true
                            end
                        end
                    end
                end)
            end
        else
            table.clear(activeWrappers)
        end
    end
end)
-- ============================================================