-- ============================================================
-- PIANO SPAM + BLOKIR REMOTE (Anti-Lag)
-- Standalone Script — Optimized for Mobile
-- Fix: Blocker pakai event-driven (DescendantAdded/Removing)
--      bukan RunService.Stepped loop per-frame
-- ============================================================

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local LocalPlayer      = Players.LocalPlayer

-- ============================================================
-- GUI PARENT HELPER
-- ============================================================
local function GetGuiParent()
    if typeof(gethui) == "function" then
        local ok, hui = pcall(gethui)
        if ok and hui then return hui end
    end
    local ok, pg = pcall(function() return LocalPlayer:WaitForChild("PlayerGui", 5) end)
    if ok and pg then return pg end
    return game:GetService("CoreGui")
end

-- ============================================================
-- DESIGN TOKENS
-- ============================================================
local BG         = Color3.fromRGB(14, 14, 14)
local ELEM       = Color3.fromRGB(22, 22, 22)
local ELEM_HOV   = Color3.fromRGB(38, 38, 38)
local TEXT       = Color3.fromRGB(230, 230, 230)
local SUB        = Color3.fromRGB(120, 120, 120)
local ACCENT     = Color3.fromRGB(255, 255, 255)
local STROKE_COL = Color3.fromRGB(255, 255, 255)
local ON_COL     = Color3.fromRGB(80, 220, 120)   -- hijau saat aktif
local OFF_COL    = Color3.fromRGB(55, 55, 55)
local KNOB_ON    = Color3.fromRGB(14, 14, 14)
local KNOB_OFF   = Color3.fromRGB(160, 160, 160)

-- ============================================================
-- TINY HELPERS
-- ============================================================
local function corner(inst, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 6)
    c.Parent = inst
    return c
end

local function uiStroke(inst, col, thick, tr)
    local s = Instance.new("UIStroke")
    s.Color            = col or STROKE_COL
    s.Thickness        = thick or 1
    s.Transparency     = tr or 0
    s.ApplyStrokeMode  = Enum.ApplyStrokeMode.Border
    s.Parent           = inst
    return s
end

local function tween(inst, t, props)
    TweenService:Create(inst, TweenInfo.new(t or 0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function Notify(tag, msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title    = "[Piano] " .. tostring(tag),
            Text     = tostring(msg),
            Duration = 2,
        })
    end)
end

-- ============================================================
-- SCREEN GUI
-- ============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name           = "PIANO_SPAM_GUI"
screenGui.ResetOnSpawn   = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent         = GetGuiParent()

-- ============================================================
-- MAIN WINDOW
-- ============================================================
local W, H = 240, 220

local main = Instance.new("Frame")
main.Name                   = "Main"
main.AnchorPoint            = Vector2.new(0.5, 0.5)
main.Position               = UDim2.new(0.5, 0, 0.5, 0)
main.Size                   = UDim2.new(0, W, 0, H)
main.BackgroundColor3       = BG
main.BackgroundTransparency = 0.12
main.BorderSizePixel        = 0
main.Parent                 = screenGui
corner(main, 10)
uiStroke(main, STROKE_COL, 1, 0.75)

-- ============================================================
-- HEADER
-- ============================================================
local header = Instance.new("Frame")
header.Size                   = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3       = ELEM
header.BackgroundTransparency = 0.3
header.BorderSizePixel        = 0
header.Parent                 = main
corner(header, 10)

-- cover bawah header agar tidak ada radius bawah
local hCover = Instance.new("Frame")
hCover.Size                   = UDim2.new(1, 0, 0.5, 0)
hCover.Position               = UDim2.new(0, 0, 0.5, 0)
hCover.BackgroundColor3       = ELEM
hCover.BackgroundTransparency = 0.3
hCover.BorderSizePixel        = 0
hCover.Parent                 = header

local titleLbl = Instance.new("TextLabel")
titleLbl.BackgroundTransparency = 1
titleLbl.Position               = UDim2.new(0, 10, 0, 0)
titleLbl.Size                   = UDim2.new(1, -70, 1, 0)
titleLbl.Font                   = Enum.Font.GothamBold
titleLbl.Text                   = "🎹 Piano Tools"
titleLbl.TextColor3             = TEXT
titleLbl.TextSize               = 11
titleLbl.TextXAlignment         = Enum.TextXAlignment.Left
titleLbl.Parent                 = header

-- Header Buttons (– dan ×)
local function makeHBtn(txt, xOff)
    local b = Instance.new("TextButton")
    b.Size                   = UDim2.new(0, 22, 0, 22)
    b.Position               = UDim2.new(1, xOff, 0.5, -11)
    b.BackgroundColor3       = ELEM
    b.BackgroundTransparency = 0.4
    b.BorderSizePixel        = 0
    b.Font                   = Enum.Font.GothamBold
    b.Text                   = txt
    b.TextColor3             = SUB
    b.TextSize               = 12
    b.AutoButtonColor        = false
    b.Parent                 = header
    corner(b, 5)
    b.MouseEnter:Connect(function() tween(b, 0.1, { BackgroundColor3 = ELEM_HOV, TextColor3 = TEXT }) end)
    b.MouseLeave:Connect(function() tween(b, 0.1, { BackgroundColor3 = ELEM,     TextColor3 = SUB  }) end)
    return b
end
local minBtn   = makeHBtn("–", -56)
local closeBtn = makeHBtn("×", -30)

-- ============================================================
-- DRAG HEADER
-- ============================================================
local function makeDraggable(handle)
    local dragging, dragStart, startPos = false, nil, nil
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end
makeDraggable(header)

-- ============================================================
-- MINI ICON (minimize)
-- ============================================================
local miniIcon = Instance.new("TextButton")
miniIcon.Name                   = "MiniIcon"
miniIcon.Size                   = UDim2.new(0, 36, 0, 36)
miniIcon.Position               = UDim2.new(0, 40, 0, 40)
miniIcon.AnchorPoint            = Vector2.new(0.5, 0.5)
miniIcon.BackgroundColor3       = ELEM
miniIcon.BackgroundTransparency = 0.2
miniIcon.BorderSizePixel        = 0
miniIcon.Font                   = Enum.Font.GothamBlack
miniIcon.Text                   = "🎹"
miniIcon.TextColor3             = ACCENT
miniIcon.TextSize               = 18
miniIcon.Visible                = false
miniIcon.Parent                 = screenGui
corner(miniIcon, 10)
uiStroke(miniIcon, STROKE_COL, 1, 0.5)

local savedOpenPos  = main.Position
local savedMiniPos  = nil
local minimized     = false

local function setMinimized(state)
    if minimized == state then return end
    minimized = state
    if state then
        savedOpenPos  = main.Position
        main.Visible  = false
        miniIcon.Position = savedMiniPos or main.Position
        miniIcon.Visible  = true
    else
        savedMiniPos  = miniIcon.Position
        main.Position = savedOpenPos
        miniIcon.Visible = false
        main.Visible     = true
    end
end

minBtn.MouseButton1Click:Connect(function() setMinimized(true) end)

do  -- draggable mini icon + tap to restore
    local drag, dStart, dPos = false, nil, nil
    local pressPos, moved = nil, false
    miniIcon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            drag     = true
            dStart   = input.Position
            dPos     = miniIcon.Position
            pressPos = input.Position
            moved    = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if drag and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dStart
            if (input.Position - pressPos).Magnitude > 5 then moved = true end
            miniIcon.Position = UDim2.new(dPos.X.Scale, dPos.X.Offset + d.X, dPos.Y.Scale, dPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            if drag and not moved then setMinimized(false) end
            drag = false
        end
    end)
end

closeBtn.MouseButton1Click:Connect(function()
    tween(main, 0.15, { BackgroundTransparency = 1 })
    task.delay(0.17, function() screenGui:Destroy() end)
end)

-- ============================================================
-- CONTENT AREA
-- ============================================================
local content = Instance.new("ScrollingFrame")
content.Position              = UDim2.new(0, 0, 0, 30)
content.Size                  = UDim2.new(1, 0, 1, -30)
content.BackgroundTransparency = 1
content.BorderSizePixel       = 0
content.ScrollBarThickness    = 3
content.ScrollBarImageColor3  = Color3.fromRGB(70, 70, 70)
content.CanvasSize            = UDim2.new(0, 0, 0, 0)
content.AutomaticCanvasSize   = Enum.AutomaticSize.Y
content.Parent                = main

local uiPad = Instance.new("UIPadding")
uiPad.PaddingLeft   = UDim.new(0, 8)
uiPad.PaddingRight  = UDim.new(0, 8)
uiPad.PaddingTop    = UDim.new(0, 8)
uiPad.PaddingBottom = UDim.new(0, 8)
uiPad.Parent        = content

local list = Instance.new("UIListLayout")
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Padding   = UDim.new(0, 6)
list.Parent    = content

-- ============================================================
-- UI COMPONENTS
-- ============================================================
local function MakeSection(text)
    local s = Instance.new("TextLabel")
    s.Size                   = UDim2.new(1, 0, 0, 14)
    s.BackgroundTransparency = 1
    s.Font                   = Enum.Font.GothamBold
    s.Text                   = string.upper(text)
    s.TextColor3             = SUB
    s.TextSize               = 9
    s.TextXAlignment         = Enum.TextXAlignment.Left
    s.Parent                 = content
    return s
end

local function MakeToggle(text, default, callback)
    local row = Instance.new("Frame")
    row.Size                   = UDim2.new(1, 0, 0, 28)
    row.BackgroundColor3       = ELEM
    row.BackgroundTransparency = 0.3
    row.BorderSizePixel        = 0
    row.Parent                 = content
    corner(row, 6)
    uiStroke(row, STROKE_COL, 1, 0.8)

    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Position               = UDim2.new(0, 10, 0, 0)
    lbl.Size                   = UDim2.new(1, -55, 1, 0)
    lbl.Font                   = Enum.Font.GothamMedium
    lbl.Text                   = text
    lbl.TextColor3             = TEXT
    lbl.TextSize               = 10
    lbl.TextXAlignment         = Enum.TextXAlignment.Left
    lbl.TextTruncate           = Enum.TextTruncate.AtEnd
    lbl.Parent                 = row

    local state = default == true

    local pill = Instance.new("Frame")
    pill.AnchorPoint           = Vector2.new(1, 0.5)
    pill.Position              = UDim2.new(1, -10, 0.5, 0)
    pill.Size                  = UDim2.new(0, 30, 0, 16)
    pill.BackgroundColor3      = state and ON_COL or OFF_COL
    pill.BackgroundTransparency = 0
    pill.BorderSizePixel        = 0
    pill.Parent                 = row
    corner(pill, 8)

    local knob = Instance.new("Frame")
    knob.AnchorPoint      = Vector2.new(0, 0.5)
    knob.Position         = state and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
    knob.Size             = UDim2.new(0, 12, 0, 12)
    knob.BackgroundColor3 = state and KNOB_ON or KNOB_OFF
    knob.BorderSizePixel  = 0
    knob.Parent           = pill
    corner(knob, 6)

    local hit = Instance.new("TextButton")
    hit.Size                   = UDim2.new(1, 0, 1, 0)
    hit.BackgroundTransparency = 1
    hit.Text                   = ""
    hit.Parent                 = row

    local function render()
        tween(pill, 0.14, { BackgroundColor3 = state and ON_COL or OFF_COL })
        tween(knob, 0.14, {
            Position      = state and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
            BackgroundColor3 = state and KNOB_ON or KNOB_OFF,
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

local function MakeButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size                   = UDim2.new(1, 0, 0, 28)
    btn.BackgroundColor3       = ELEM
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel        = 0
    btn.Font                   = Enum.Font.GothamBold
    btn.Text                   = text
    btn.TextColor3             = TEXT
    btn.TextSize               = 10
    btn.AutoButtonColor        = false
    btn.Parent                 = content
    corner(btn, 6)
    uiStroke(btn, STROKE_COL, 1, 0.8)
    btn.MouseEnter:Connect(function() tween(btn, 0.1, { BackgroundColor3 = ELEM_HOV }) end)
    btn.MouseLeave:Connect(function() tween(btn, 0.1, { BackgroundColor3 = ELEM     }) end)
    btn.MouseButton1Click:Connect(function() if callback then pcall(callback) end end)
    return btn
end

-- ============================================================
-- PIANO CONFIG
-- ============================================================
local PIANO_EVENT_NAME   = "GlobalPianoConnector"
local PIANO_NOTE_START   = 1
local PIANO_NOTE_END     = 61
local PIANO_PER_KEY_RATE = 610
local PIANO_NUM_KEYS     = PIANO_NOTE_END - PIANO_NOTE_START + 1
local PIANO_TOTAL_RATE   = PIANO_NUM_KEYS * PIANO_PER_KEY_RATE

-- Koordinat teleport ke dua piano (sesuaikan dengan map game)
local PIANO_CFRAME_1 = CFrame.new(363.90, 81.70,  -1218.41)
local PIANO_CFRAME_2 = CFrame.new( 80.75, 69.53,   -763.07)

local PIANO_enabled   = false
local PIANO_fireCount = 0
local PIANO_thread    = nil

local function PIANO_getEvent()
    local ev = workspace:FindFirstChild(PIANO_EVENT_NAME)
    if ev and ev:IsA("RemoteEvent") then return ev end
    return nil
end

-- ============================================================
-- PIANO SPAM LOGIC
-- ============================================================
local function PIANO_startSpam()
    if PIANO_thread then
        pcall(function() task.cancel(PIANO_thread) end)
        PIANO_thread = nil
    end

    PIANO_thread = task.spawn(function()
        local clock     = os.clock
        local startT    = clock()
        local baseCount = PIANO_fireCount
        local n         = PIANO_NUM_KEYS
        local startNote = PIANO_NOTE_START
        local totRate   = PIANO_TOTAL_RATE
        local pcall_l   = pcall

        while PIANO_enabled do
            local ev = PIANO_getEvent()
            if not ev then
                PIANO_enabled = false
                Notify("Error", "Remote '" .. PIANO_EVENT_NAME .. "' hilang!")
                if pianoToggle then pianoToggle:Set(false, true) end
                break
            end

            local fire       = ev.FireServer
            local obj        = ev
            local elapsed    = clock() - startT
            local targetTot  = math.floor(elapsed * totRate)
            local alreadyFired = PIANO_fireCount - baseCount
            local needed     = targetTot - alreadyFired

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

-- ============================================================
-- BLOKIR REMOTE (Anti-Lag Piano) — OPTIMIZED: event-driven, zero per-frame loop
-- ============================================================
local remoteBlockEnabled = false
local targetBlockRemote  = nil
local activeWrappers     = {}

-- Pasang wrapper sekali saja, tidak perlu loop
local function setupBlocker()
    if not targetBlockRemote then return end
    -- Cegah pasang ulang kalau sudah ada wrapper aktif
    if next(activeWrappers) then return end
    pcall(function()
        for _, conn in pairs(getconnections(targetBlockRemote.OnClientEvent)) do
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
    end)
end

local function teardownBlocker()
    table.clear(activeWrappers)
    -- Reconnect listener asli tidak diperlukan karena game akan re-attach sendiri
end

-- DescendantAdded: tangkap saat remote muncul (tanpa loop)
workspace.DescendantAdded:Connect(function(obj)
    if not remoteBlockEnabled then return end
    if obj.Name == PIANO_EVENT_NAME and obj:IsA("RemoteEvent") then
        targetBlockRemote = obj
        table.clear(activeWrappers)
        -- Tunggu 1 frame agar game sempat attach listener-nya duluan
        task.defer(setupBlocker)
    end
end)

-- DescendantRemoving: bersihkan kalau remote hilang
workspace.DescendantRemoving:Connect(function(obj)
    if obj == targetBlockRemote then
        targetBlockRemote = nil
        table.clear(activeWrappers)
    end
end)

-- ============================================================
-- UI SECTIONS & CONTROLS
-- ============================================================

MakeSection("Piano Spam")

pianoToggle = MakeToggle(
    string.format("Piano Spam (%d×%d/s)", PIANO_NUM_KEYS, PIANO_PER_KEY_RATE),
    false,
    function(state)
        if state then
            local ev = PIANO_getEvent()
            if not ev then
                Notify("Error", PIANO_EVENT_NAME .. " tidak ditemukan!")
                if pianoToggle then pianoToggle:Set(false, true) end
                return
            end
            PIANO_enabled = true
            PIANO_startSpam()
            Notify("Piano Spam", "Mulai spam " .. PIANO_NUM_KEYS .. " nada/frame")
        else
            PIANO_enabled = false
            if PIANO_thread then
                pcall(function() task.cancel(PIANO_thread) end)
                PIANO_thread = nil
            end
            Notify("Piano Spam", "Dihentikan")
        end
    end
)

MakeButton("📌 TP ke Piano 1", function()
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = PIANO_CFRAME_1
        Notify("TP", "Teleport ke Piano 1")
    else
        Notify("TP", "Karakter tidak ditemukan")
    end
end)

MakeButton("📌 TP ke Piano 2", function()
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = PIANO_CFRAME_2
        Notify("TP", "Teleport ke Piano 2")
    else
        Notify("TP", "Karakter tidak ditemukan")
    end
end)

MakeSection("Anti Lag")

MakeToggle("Blokir Remote Play (Anti-Lag)", false, function(state)
    remoteBlockEnabled = state
    if state then
        -- Seed remote sekarang kalau sudah ada di workspace
        local ev = workspace:FindFirstChild(PIANO_EVENT_NAME)
        if ev and ev:IsA("RemoteEvent") then
            targetBlockRemote = ev
            task.defer(setupBlocker)
            Notify("Anti-Lag", "Remote 'play' diblokir")
        else
            Notify("Anti-Lag", "Remote belum ada, akan auto-block saat muncul")
        end
    else
        teardownBlocker()
        Notify("Anti-Lag", "Blokir remote dimatikan")
    end
end)

-- ============================================================
-- END OF SCRIPT
-- ============================================================
