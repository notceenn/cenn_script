-- ============================================================
-- CENN MEGA HUB
-- DWheelBarrow + Stone/Spam/AntiFling + Piano + AntiPaused
-- UI style: Sharp dark, high-contrast text
-- ============================================================

local Players             = game:GetService("Players")
local RunService          = game:GetService("RunService")
local UserInputService    = game:GetService("UserInputService")
local TweenService        = game:GetService("TweenService")
local RS                  = game:GetService("ReplicatedStorage")
local StarterGui          = game:GetService("StarterGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer         = Players.LocalPlayer

-- ============================================================
-- GUI PARENT
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
-- THEME  — high-contrast, vivid, readable
-- ============================================================
local ACCENT        = Color3.fromRGB(99, 179, 255)    -- biru cerah
local ACCENT2       = Color3.fromRGB(120, 255, 180)   -- hijau mint (on)
local BG            = Color3.fromRGB(12, 12, 16)
local ELEM          = Color3.fromRGB(22, 24, 32)
local ELEM_HOV      = Color3.fromRGB(36, 40, 54)
local TEXT          = Color3.fromRGB(240, 240, 255)   -- putih kebiruan, solid
local TEXT_DIM      = Color3.fromRGB(170, 175, 200)   -- tetap terbaca, bukan abu
local LABEL_COL     = Color3.fromRGB(99, 179, 255)    -- section label = accent
local STROKE_COL    = Color3.fromRGB(55, 65, 100)
local TOGGLE_OFF    = Color3.fromRGB(50, 55, 75)
local NOTE_COL      = Color3.fromRGB(160, 165, 190)   -- note text, cukup terang
local BG_TRANS      = 0.08
local ELEM_TRANS    = 0.0
local STROKE_TRANS  = 0.0

-- ============================================================
-- UI HELPERS
-- ============================================================
local function corner(inst, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 6)
    c.Parent = inst
    return c
end
local function mkstroke(inst, col, t, tr)
    local s = Instance.new("UIStroke")
    s.Color = col or STROKE_COL
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
local function tw(inst, time, props)
    TweenService:Create(inst, TweenInfo.new(time or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

-- ============================================================
-- SCREEN GUI + MAIN FRAME
-- ============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name           = "CennMegaHub"
screenGui.ResetOnSpawn   = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent         = GetGuiParent()

local W, H = 268, 530
local main = Instance.new("Frame")
main.Name                   = "Main"
main.AnchorPoint            = Vector2.new(0.5, 0.5)
main.Position               = UDim2.new(0.5, 0, 0.5, 0)
main.Size                   = UDim2.new(0, W, 0, H)
main.BackgroundColor3       = BG
main.BackgroundTransparency = BG_TRANS
main.BorderSizePixel        = 0
main.Parent                 = screenGui
corner(main, 8)
mkstroke(main, STROKE_COL, 1, 0)

-- Header gradient bar
local header = Instance.new("Frame")
header.Size                   = UDim2.new(1, 0, 0, 34)
header.BackgroundColor3       = Color3.fromRGB(18, 22, 38)
header.BackgroundTransparency = 0
header.BorderSizePixel        = 0
header.Parent                 = main
corner(header, 8)
-- cover bottom corners of header
local headerCover = Instance.new("Frame")
headerCover.Size                   = UDim2.new(1, 0, 0.5, 0)
headerCover.Position               = UDim2.new(0, 0, 0.5, 0)
headerCover.BackgroundColor3       = Color3.fromRGB(18, 22, 38)
headerCover.BackgroundTransparency = 0
headerCover.BorderSizePixel        = 0
headerCover.Parent                 = header

-- accent bar on top of header
local accentBar = Instance.new("Frame")
accentBar.Size                = UDim2.new(1, 0, 0, 2)
accentBar.Position            = UDim2.new(0, 0, 0, 0)
accentBar.BackgroundColor3    = ACCENT
accentBar.BackgroundTransparency = 0
accentBar.BorderSizePixel     = 0
accentBar.Parent              = header
-- top corners only
local accentBarCorner = Instance.new("UICorner")
accentBarCorner.CornerRadius  = UDim.new(0, 8)
accentBarCorner.Parent        = accentBar

-- dot indicator
local dot = Instance.new("Frame")
dot.Size                = UDim2.new(0, 7, 0, 7)
dot.Position            = UDim2.new(0, 10, 0.5, -3)
dot.BackgroundColor3    = ACCENT2
dot.BackgroundTransparency = 0
dot.BorderSizePixel     = 0
dot.Parent              = header
corner(dot, 4)

local titleLbl = Instance.new("TextLabel")
titleLbl.BackgroundTransparency = 1
titleLbl.Position               = UDim2.new(0, 24, 0, 0)
titleLbl.Size                   = UDim2.new(1, -75, 1, 0)
titleLbl.Font                   = Enum.Font.GothamBold
titleLbl.Text                   = "CENN MEGA HUB"
titleLbl.TextColor3             = TEXT
titleLbl.TextSize               = 12
titleLbl.TextXAlignment         = Enum.TextXAlignment.Left
titleLbl.Parent                 = header

local function headerBtn(txt, xOff)
    local b = Instance.new("TextButton")
    b.Size                   = UDim2.new(0, 24, 0, 24)
    b.Position               = UDim2.new(1, xOff, 0.5, -12)
    b.BackgroundColor3       = Color3.fromRGB(30, 35, 55)
    b.BackgroundTransparency = 0
    b.BorderSizePixel        = 0
    b.Font                   = Enum.Font.GothamBold
    b.Text                   = txt
    b.TextColor3             = TEXT_DIM
    b.TextSize               = 13
    b.AutoButtonColor        = false
    b.Parent                 = header
    corner(b, 5)
    mkstroke(b, STROKE_COL, 1, 0)
    b.MouseEnter:Connect(function() tw(b, 0.1, { BackgroundColor3 = ELEM_HOV, TextColor3 = TEXT }) end)
    b.MouseLeave:Connect(function() tw(b, 0.1, { BackgroundColor3 = Color3.fromRGB(30, 35, 55), TextColor3 = TEXT_DIM }) end)
    return b
end
local minBtn   = headerBtn("–", -58)
local closeBtn = headerBtn("×", -30)

-- Content scroll
local content = Instance.new("ScrollingFrame")
content.Position               = UDim2.new(0, 0, 0, 34)
content.Size                   = UDim2.new(1, 0, 1, -34)
content.BackgroundTransparency = 1
content.BorderSizePixel        = 0
content.ScrollBarThickness     = 3
content.ScrollBarImageColor3   = Color3.fromRGB(80, 100, 160)
content.CanvasSize             = UDim2.new(0, 0, 0, 0)
content.AutomaticCanvasSize    = Enum.AutomaticSize.Y
content.Parent                 = main
pad(content, 8, 8, 8, 8)
local list = Instance.new("UIListLayout")
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Padding   = UDim.new(0, 5)
list.Parent    = content

-- Drag
local dragging, dragStart, startPos = false, nil, nil
header.InputBegan:Connect(function(input)
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
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
       or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Mini icon
local miniIcon = Instance.new("TextButton")
miniIcon.Name                   = "MiniIcon"
miniIcon.Size                   = UDim2.new(0, 38, 0, 38)
miniIcon.Position               = UDim2.new(0, 30, 0, 30)
miniIcon.AnchorPoint            = Vector2.new(0.5, 0.5)
miniIcon.BackgroundColor3       = Color3.fromRGB(18, 22, 38)
miniIcon.BackgroundTransparency = 0
miniIcon.BorderSizePixel        = 0
miniIcon.Font                   = Enum.Font.GothamBlack
miniIcon.Text                   = "C"
miniIcon.TextColor3             = ACCENT
miniIcon.TextSize               = 16
miniIcon.Visible                = false
miniIcon.Parent                 = screenGui
corner(miniIcon, 10)
mkstroke(miniIcon, STROKE_COL, 1, 0)

local savedOpenPos  = main.Position
local savedMiniPos  = nil
local minimized     = false

local function setMinimized(state)
    if minimized == state then return end
    minimized = state
    if state then
        savedOpenPos = main.Position
        main.Visible = false
        miniIcon.Position = savedMiniPos or main.Position
        miniIcon.Visible  = true
    else
        savedMiniPos = miniIcon.Position
        main.Position = savedOpenPos
        miniIcon.Visible = false
        main.Visible = true
    end
end

minBtn.MouseButton1Click:Connect(function() setMinimized(true) end)

do
    local dr, ds2, sp2, pp, mv = false, nil, nil, nil, false
    miniIcon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            dr = true; ds2 = input.Position; sp2 = miniIcon.Position
            pp = input.Position; mv = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dr and (input.UserInputType == Enum.UserInputType.MouseMovement
           or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - ds2
            if (input.Position - pp).Magnitude > 5 then mv = true end
            miniIcon.Position = UDim2.new(sp2.X.Scale, sp2.X.Offset + delta.X, sp2.Y.Scale, sp2.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            if dr and not mv then setMinimized(false) end
            dr = false
        end
    end)
end

-- ============================================================
-- UI COMPONENT HELPERS
-- ============================================================
local function MakeSection(text)
    local wrap = Instance.new("Frame")
    wrap.Size                   = UDim2.new(1, 0, 0, 20)
    wrap.BackgroundTransparency = 1
    wrap.Parent                 = content

    local line = Instance.new("Frame")
    line.Size             = UDim2.new(1, 0, 0, 1)
    line.Position         = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = STROKE_COL
    line.BackgroundTransparency = 0.3
    line.BorderSizePixel  = 0
    line.Parent           = wrap

    local bg = Instance.new("Frame")
    bg.Size                   = UDim2.new(0, 0, 1, 0)   -- auto-sized below
    bg.Position               = UDim2.new(0, 0, 0, 0)
    bg.BackgroundColor3       = BG
    bg.BackgroundTransparency = BG_TRANS
    bg.BorderSizePixel        = 0
    bg.AutomaticSize          = Enum.AutomaticSize.X
    bg.Parent                 = wrap

    local s = Instance.new("TextLabel")
    s.Size                   = UDim2.new(0, 0, 1, 0)
    s.AutomaticSize          = Enum.AutomaticSize.X
    s.BackgroundTransparency = 1
    s.Font                   = Enum.Font.GothamBold
    s.Text                   = "  " .. string.upper(text) .. "  "
    s.TextColor3             = LABEL_COL
    s.TextSize               = 9
    s.TextXAlignment         = Enum.TextXAlignment.Left
    s.Parent                 = bg
    return s
end

local function MakeNote(text)
    local s = Instance.new("TextLabel")
    s.Size                   = UDim2.new(1, 0, 0, 0)
    s.AutomaticSize          = Enum.AutomaticSize.Y
    s.BackgroundTransparency = 1
    s.Font                   = Enum.Font.Gotham
    s.Text                   = text
    s.TextColor3             = NOTE_COL
    s.TextSize               = 9
    s.TextWrapped            = true
    s.TextXAlignment         = Enum.TextXAlignment.Left
    s.Parent                 = content
    return s
end

local function MakeToggle(text, default, callback)
    local row = Instance.new("Frame")
    row.Size                   = UDim2.new(1, 0, 0, 30)
    row.BackgroundColor3       = ELEM
    row.BackgroundTransparency = ELEM_TRANS
    row.BorderSizePixel        = 0
    row.Parent                 = content
    corner(row, 6)
    mkstroke(row, STROKE_COL, 1, 0)

    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Position               = UDim2.new(0, 10, 0, 0)
    lbl.Size                   = UDim2.new(1, -58, 1, 0)
    lbl.Font                   = Enum.Font.GothamMedium
    lbl.Text                   = text
    lbl.TextColor3             = TEXT
    lbl.TextSize               = 10
    lbl.TextXAlignment         = Enum.TextXAlignment.Left
    lbl.TextTruncate           = Enum.TextTruncate.AtEnd
    lbl.Parent                 = row

    local state = default == true
    local pill  = Instance.new("Frame")
    pill.AnchorPoint            = Vector2.new(1, 0.5)
    pill.Position               = UDim2.new(1, -10, 0.5, 0)
    pill.Size                   = UDim2.new(0, 32, 0, 17)
    pill.BackgroundColor3       = state and ACCENT2 or TOGGLE_OFF
    pill.BackgroundTransparency = 0
    pill.BorderSizePixel        = 0
    pill.Parent                 = row
    corner(pill, 9)

    local knob = Instance.new("Frame")
    knob.AnchorPoint         = Vector2.new(0, 0.5)
    knob.Position            = state and UDim2.new(1, -15, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
    knob.Size                = UDim2.new(0, 13, 0, 13)
    knob.BackgroundColor3    = Color3.fromRGB(240, 240, 255)
    knob.BorderSizePixel     = 0
    knob.Parent              = pill
    corner(knob, 7)

    local hit = Instance.new("TextButton")
    hit.Size                 = UDim2.new(1, 0, 1, 0)
    hit.BackgroundTransparency = 1
    hit.Text                 = ""
    hit.Parent               = row

    local function render()
        tw(pill, 0.15, { BackgroundColor3 = state and ACCENT2 or TOGGLE_OFF })
        tw(knob, 0.15, {
            Position = state and UDim2.new(1, -15, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
        })
        tw(lbl,  0.15, { TextColor3 = state and TEXT or TEXT_DIM })
    end

    hit.MouseButton1Click:Connect(function()
        state = not state
        render()
        if callback then pcall(callback, state) end
    end)

    render()
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
    btn.Size                   = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3       = Color3.fromRGB(28, 35, 60)
    btn.BackgroundTransparency = 0
    btn.BorderSizePixel        = 0
    btn.Font                   = Enum.Font.GothamBold
    btn.Text                   = text
    btn.TextColor3             = ACCENT
    btn.TextSize               = 10
    btn.AutoButtonColor        = false
    btn.Parent                 = content
    corner(btn, 6)
    mkstroke(btn, STROKE_COL, 1, 0)
    btn.MouseEnter:Connect(function()
        tw(btn, 0.1, { BackgroundColor3 = Color3.fromRGB(40, 55, 100), TextColor3 = TEXT })
    end)
    btn.MouseLeave:Connect(function()
        tw(btn, 0.1, { BackgroundColor3 = Color3.fromRGB(28, 35, 60), TextColor3 = ACCENT })
    end)
    btn.MouseButton1Click:Connect(function() if callback then pcall(callback) end end)
    return btn
end

local function MakeSlider(text, minVal, maxVal, default, step, callback)
    local row = Instance.new("Frame")
    row.Size                   = UDim2.new(1, 0, 0, 44)
    row.BackgroundColor3       = ELEM
    row.BackgroundTransparency = ELEM_TRANS
    row.BorderSizePixel        = 0
    row.Parent                 = content
    corner(row, 6)
    mkstroke(row, STROKE_COL, 1, 0)

    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Position               = UDim2.new(0, 10, 0, 5)
    lbl.Size                   = UDim2.new(1, -100, 0, 15)
    lbl.Font                   = Enum.Font.GothamMedium
    lbl.Text                   = text
    lbl.TextColor3             = TEXT
    lbl.TextSize               = 10
    lbl.TextXAlignment         = Enum.TextXAlignment.Left
    lbl.TextTruncate           = Enum.TextTruncate.AtEnd
    lbl.Parent                 = row

    local inputBox = Instance.new("TextBox")
    inputBox.AnchorPoint         = Vector2.new(1, 0)
    inputBox.Position            = UDim2.new(1, -8, 0, 4)
    inputBox.Size                = UDim2.new(0, 76, 0, 17)
    inputBox.BackgroundColor3    = Color3.fromRGB(14, 16, 26)
    inputBox.BorderSizePixel     = 0
    inputBox.Font                = Enum.Font.GothamBold
    inputBox.Text                = tostring(default)
    inputBox.TextColor3          = ACCENT
    inputBox.TextSize            = 10
    inputBox.TextXAlignment      = Enum.TextXAlignment.Center
    inputBox.ClearTextOnFocus    = false
    inputBox.Parent              = row
    corner(inputBox, 4)
    local inputStroke = mkstroke(inputBox, STROKE_COL, 1, 0)

    local track = Instance.new("Frame")
    track.Position              = UDim2.new(0, 10, 1, -13)
    track.Size                  = UDim2.new(1, -20, 0, 4)
    track.BackgroundColor3      = Color3.fromRGB(35, 40, 65)
    track.BackgroundTransparency = 0
    track.BorderSizePixel       = 0
    track.Parent                = row
    corner(track, 2)

    local fill = Instance.new("Frame")
    fill.Size             = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = ACCENT
    fill.BorderSizePixel  = 0
    fill.Parent           = track
    corner(fill, 2)

    local value     = default
    local dragging2 = false
    local typing    = false

    local function fmt(v)
        if step and step < 0.01 then return string.format("%.3f", v) end
        if step and step < 1   then return string.format("%.2f", v) end
        return tostring(math.floor(v + 0.5))
    end

    local function setVal(v, skipInput)
        v = tonumber(v) or value
        if step and step > 0 then v = math.floor(v / step + 0.5) * step end
        value = v
        local clamped = math.clamp(v, minVal, maxVal)
        local pct = (clamped - minVal) / math.max(1e-6, maxVal - minVal)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        if not skipInput and not typing then inputBox.Text = fmt(v) end
        if callback then pcall(callback, value) end
    end

    local hit = Instance.new("TextButton")
    hit.Size                   = UDim2.new(1, 0, 0, 20)
    hit.Position               = UDim2.new(0, 0, 1, -22)
    hit.BackgroundTransparency = 1
    hit.Text                   = ""
    hit.Parent                 = row

    local function updateFromX(px)
        local rel = (px - track.AbsolutePosition.X) / math.max(1, track.AbsoluteSize.X)
        setVal(minVal + math.clamp(rel, 0, 1) * (maxVal - minVal))
    end

    hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging2 = true
            updateFromX(input.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging2 and (input.UserInputType == Enum.UserInputType.MouseMovement
           or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromX(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging2 = false
        end
    end)

    inputBox.Focused:Connect(function()
        typing = true
        tw(inputStroke, 0.1, { Color = ACCENT, Transparency = 0 })
    end)
    inputBox.FocusLost:Connect(function()
        typing = false
        tw(inputStroke, 0.15, { Color = STROKE_COL, Transparency = 0 })
        local num = tonumber(inputBox.Text)
        if num then setVal(num, true) end
        inputBox.Text = fmt(value)
    end)

    setVal(default, true)
    return { Set = function(v) setVal(v) end, Get = function() return value end }
end

local function MakeStatusLabel()
    local lbl = Instance.new("TextLabel")
    lbl.Size                   = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Font                   = Enum.Font.Gotham
    lbl.TextSize               = 9
    lbl.TextColor3             = NOTE_COL
    lbl.TextXAlignment         = Enum.TextXAlignment.Center
    lbl.Text                   = ""
    lbl.Parent                 = content
    return lbl
end

-- ============================================================
-- ⚙️ KONFIGURASI
-- ============================================================
local STONE_CFRAME   = CFrame.new(311.80, 60.66, -1048.49)
-- FIX #1: default speed = 16 (tidak mengubah speed saat execute)
local DEFAULT_SPEED  = 16
local TOOL_PRIORITY  = { "WheelBarrow", "Box" }

local PIANO_CFRAME_1 = CFrame.new(363.90, 81.70, -1218.41)
local PIANO_CFRAME_2 = CFrame.new(80.75,  69.53, -763.07)
local NOTE_START     = 1
local NOTE_END       = 61
local NUM_KEYS       = NOTE_END - NOTE_START + 1
local PER_KEY_RATE   = 610
local TOTAL_RATE     = NUM_KEYS * PER_KEY_RATE

local AF_PLAYER_RADIUS = 80
local AF_PART_RADIUS   = 30
local AF_PART_VEL      = 70
local AF_PART_ANG      = 40
local AF_VEL_EXTRA     = 120
local AF_UP_LIMIT      = 150
local AF_ANG_LIMIT     = 50

-- ============================================================
-- STATE
-- ============================================================
local isSpamming   = false
local spamConn     = nil
local isBusy       = false
local currentSpeed = DEFAULT_SPEED

local afEnabled    = false
local afConns      = {}
local charConns    = setmetatable({}, { __mode = "k" })
local charParts    = setmetatable({}, { __mode = "k" })
local isCharPart   = setmetatable({}, { __mode = "k" })
local flippedPP    = setmetatable({}, { __mode = "k" })
local softParts    = setmetatable({}, { __mode = "k" })
local afOverlap    = OverlapParams.new()
afOverlap.FilterType        = Enum.RaycastFilterType.Exclude
afOverlap.MaxParts          = 60
afOverlap.RespectCanCollide = false
local afOverlapChar               = nil
local afSafeChar, afLastSafe, afBadStreak = nil, nil, 0

local agpEnabled   = false
local agpConn      = nil

local pianoEnabled   = false
local pianoThread    = nil
local pianoFireCount = 0
local pianoRateCount = 0
local pianoRateTime  = os.clock()

-- ============================================================
-- INSTANT PROMPT CACHE
-- ============================================================
local promptSet = {}
local function fixPrompt(obj)
    if obj:IsA("ProximityPrompt") then
        obj.HoldDuration = 0
        obj.MaxActivationDistance = 50
        promptSet[obj] = true
        obj.Destroying:Connect(function() promptSet[obj] = nil end)
    end
end
for _, obj in ipairs(workspace:GetDescendants()) do fixPrompt(obj) end
workspace.DescendantAdded:Connect(fixPrompt)

local function promptPosition(p)
    local par = p.Parent
    if not par then return nil end
    if par:IsA("BasePart") then return par.Position end
    if par:IsA("Attachment") then return par.WorldPosition end
    if par:IsA("Model") then return par:GetPivot().Position end
    return nil
end

-- ============================================================
-- AMBIL BATU
-- ============================================================
local function takeStone()
    if isBusy then return false end
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    isBusy = true
    local orig = hrp.CFrame
    hrp.CFrame = STONE_CFRAME
    task.wait(0.5)
    local found = false
    pcall(function()
        local best, bestD = nil, math.huge
        for obj in pairs(promptSet) do
            if obj.Parent then
                local txt = (obj.ActionText .. " " .. obj.ObjectText):lower()
                if txt:find("batu") or txt:find("bawa") or txt:find("ambil") then
                    local pos = promptPosition(obj)
                    local d   = pos and (pos - hrp.Position).Magnitude or math.huge
                    if d < bestD then best, bestD = obj, d end
                end
            end
        end
        if best then fireproximityprompt(best); found = true end
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(true,  Enum.KeyCode.E, false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
        task.wait(0.3)
    end)
    pcall(function() hrp.CFrame = orig end)
    isBusy = false
    return found
end

-- ============================================================
-- SPAM TOOL
-- ============================================================
local function findTool(char, bp)
    for _, name in ipairs(TOOL_PRIORITY) do
        local t = char:FindFirstChild(name)
        if not (t and t:IsA("Tool")) then t = bp and bp:FindFirstChild(name) end
        if t and t:IsA("Tool") then return t end
    end
end
local function startSpam()
    if spamConn then spamConn:Disconnect() end
    isSpamming = true
    spamConn = RunService.Heartbeat:Connect(function()
        if isBusy then return end
        local char = LocalPlayer.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        local bp   = LocalPlayer:FindFirstChildOfClass("Backpack")
        if not hum or hum.Health <= 0 then return end
        local tool = findTool(char, bp)
        if not tool then return end
        if tool.Parent == char then pcall(hum.UnequipTools, hum)
        else pcall(hum.EquipTool, hum, tool) end
    end)
end
local function stopSpam()
    isSpamming = false
    if spamConn then spamConn:Disconnect(); spamConn = nil end
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then pcall(hum.UnequipTools, hum) end
end

-- ============================================================
-- ANTI FLING
-- ============================================================
local function afTrackChar(char)
    local list = {}
    for _, d in ipairs(char:GetDescendants()) do
        if d:IsA("BasePart") then list[#list+1] = d; isCharPart[d] = true end
    end
    charParts[char] = list
    charConns[char] = char.DescendantAdded:Connect(function(d)
        if d:IsA("BasePart") then list[#list+1] = d; isCharPart[d] = true end
    end)
end
local function afUntrackChar(char)
    charParts[char] = nil
    local c = charConns[char]; if c then c:Disconnect() end
    charConns[char] = nil
end
local function afTrackPlayer(plr)
    if plr == LocalPlayer then return end
    if plr.Character then afTrackChar(plr.Character) end
    table.insert(afConns, plr.CharacterAdded:Connect(afTrackChar))
    table.insert(afConns, plr.CharacterRemoving:Connect(afUntrackChar))
end
local function afApplyStates(on)
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then pcall(function()
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, not on)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,     not on)
    end) end
end
local function afStepped()
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local myPos = hrp.Position
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local c    = plr.Character
            local list = c and charParts[c]
            local root = c and c:FindFirstChild("HumanoidRootPart")
            if list and root and (root.Position - myPos).Magnitude < AF_PLAYER_RADIUS then
                for i = 1, #list do
                    local p = list[i]
                    if p.CanCollide then p.CanCollide = false; flippedPP[p] = true end
                end
            end
        end
    end
    if char ~= afOverlapChar then
        afOverlap.FilterDescendantsInstances = { char }; afOverlapChar = char
    end
    local myRoot = hrp.AssemblyRootPart
    local now    = os.clock()
    local parts  = workspace:GetPartBoundsInRadius(myPos, AF_PART_RADIUS, afOverlap)
    for i = 1, #parts do
        local p = parts[i]
        if not p.Anchored and not isCharPart[p] and p.AssemblyRootPart ~= myRoot then
            if p.AssemblyLinearVelocity.Magnitude > AF_PART_VEL
               or p.AssemblyAngularVelocity.Magnitude > AF_PART_ANG then
                if p.CanCollide then p.CanCollide = false; softParts[p] = now
                elseif softParts[p] then softParts[p] = now end
            end
        end
    end
    for p, t in pairs(softParts) do
        if now - t > 0.4 then
            if p.Parent then p.CanCollide = true end
            softParts[p] = nil
        end
    end
end
local function afHeartbeat()
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if not (hrp and hum) or hum.Health <= 0 then return end
    if char ~= afSafeChar then afSafeChar = char; afLastSafe = nil; afBadStreak = 0 end
    if hum.SeatPart then afLastSafe = nil; return end
    local lv    = hrp.AssemblyLinearVelocity
    local av    = hrp.AssemblyAngularVelocity
    local horiz = math.sqrt(lv.X*lv.X + lv.Z*lv.Z)
    local bad   = horiz > (hum.WalkSpeed + AF_VEL_EXTRA)
               or lv.Y > AF_UP_LIMIT
               or av.Magnitude > AF_ANG_LIMIT
    if bad and afBadStreak < 30 then
        afBadStreak += 1
        hrp.AssemblyLinearVelocity  = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        if afLastSafe then hrp.CFrame = afLastSafe end
    else
        if not bad then afBadStreak = 0 end
        afLastSafe = hrp.CFrame
    end
end
local function setAntiFling(on)
    if on == afEnabled then return end
    afEnabled = on
    if on then
        for _, plr in ipairs(Players:GetPlayers()) do afTrackPlayer(plr) end
        table.insert(afConns, Players.PlayerAdded:Connect(afTrackPlayer))
        table.insert(afConns, RunService.Stepped:Connect(afStepped))
        table.insert(afConns, RunService.Heartbeat:Connect(afHeartbeat))
        afApplyStates(true)
    else
        for _, c in ipairs(afConns) do c:Disconnect() end; afConns = {}
        for ch in pairs(charConns) do afUntrackChar(ch) end
        for p in pairs(softParts) do if p.Parent then p.CanCollide = true end end
        for p in pairs(flippedPP) do if p.Parent then p.CanCollide = true end end
        table.clear(softParts); table.clear(flippedPP); table.clear(isCharPart)
        afSafeChar, afLastSafe, afBadStreak, afOverlapChar = nil, nil, 0, nil
        afApplyStates(false)
    end
end

-- ============================================================
-- ANTI GAMEPLAY PAUSED
-- ============================================================
local function setAntiPaused(on)
    agpEnabled = on
    if agpConn then agpConn:Disconnect(); agpConn = nil end
    if not on then return end
    agpConn = RunService.Heartbeat:Connect(function()
        pcall(function()
            local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
            if not pg then return end
            for _, g in ipairs(pg:GetChildren()) do
                local n = g.Name:lower()
                if n:find("pause") then
                    if g:IsA("ScreenGui") then g.Enabled = false end
                end
            end
        end)
    end)
end

-- ============================================================
-- PIANO SPAMMER
-- ============================================================
local PianoEvent = workspace:FindFirstChild("GlobalPianoConnector")

local function startPiano()
    if not PianoEvent then return false end
    pianoEnabled   = true
    pianoFireCount = 0
    pianoRateCount = 0
    pianoRateTime  = os.clock()
    pianoThread = task.spawn(function()
        local clock     = os.clock
        local startT    = clock()
        local base      = 0
        local n         = NUM_KEYS
        local startNote = NOTE_START
        local totalRate = TOTAL_RATE
        local fire      = PianoEvent.FireServer
        local obj       = PianoEvent
        while pianoEnabled do
            local elapsed = clock() - startT
            local needed  = math.floor(elapsed * totalRate) - (pianoFireCount - base)
            if needed > 0 then
                local offset = pianoFireCount % n
                pcall(function()
                    for i = 1, needed do
                        fire(obj, "play", startNote + ((offset + i - 1) % n))
                    end
                end)
                pianoFireCount += needed
            end
            task.wait()
        end
    end)
    return true
end
local function stopPiano()
    pianoEnabled = false
    pianoThread  = nil
end

-- ============================================================
-- WALKSPEED (spring-based)
-- FIX #1: wsValue default = 16, hum.WalkSpeed tidak diubah kalau wsValue = 16
-- ============================================================
local wsValue    = DEFAULT_SPEED   -- = 16, jadi tidak ada efek saat execute
local _WS_K      = 80
local _WS_D      = 18
local _wsTarget  = Vector3.zero
local _wsCurr    = Vector3.zero
local _wsSpring  = Vector3.zero
local _wsLinVel  = nil
local _wsLinAtt  = nil

local function getHum()
    local c = LocalPlayer and LocalPlayer.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end
local function getRoot()
    local c = LocalPlayer and LocalPlayer.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function _ensureLinVel(root)
    if _wsLinVel and _wsLinVel.Parent == root then return end
    pcall(function()
        if _wsLinAtt then _wsLinAtt:Destroy() end
        if _wsLinVel then _wsLinVel:Destroy() end
    end)
    _wsLinAtt = Instance.new("Attachment")
    _wsLinAtt.Name   = "_wsA"
    _wsLinAtt.Parent = root
    _wsLinVel = Instance.new("LinearVelocity")
    _wsLinVel.Name                   = "_wsLV"
    _wsLinVel.Attachment0            = _wsLinAtt
    _wsLinVel.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
    _wsLinVel.PrimaryTangentAxis     = Vector3.new(1, 0, 0)
    _wsLinVel.SecondaryTangentAxis   = Vector3.new(0, 0, 1)
    _wsLinVel.PlaneVelocity          = Vector2.zero
    _wsLinVel.MaxForce               = math.huge
    _wsLinVel.RelativeTo             = Enum.ActuatorRelativeTo.World
    _wsLinVel.Parent                 = root
end
local function _destroyLinVel()
    pcall(function() if _wsLinAtt then _wsLinAtt:Destroy() end end)
    pcall(function() if _wsLinVel then _wsLinVel:Destroy() end end)
    _wsLinAtt = nil; _wsLinVel = nil
end

RunService.Heartbeat:Connect(function(dt)
    -- FIX #1: kalau wsValue == 16 artinya slider di default, skip semua override
    local anyActive = wsValue ~= 16
    if not anyActive then
        if _wsCurr.Magnitude > 0.05 or _wsSpring.Magnitude > 0.05 then
            local dtC = math.clamp(dt, 0.008, 0.05)
            local _f  = -_wsCurr * _WS_K - _wsSpring * _WS_D
            _wsSpring = _wsSpring + _f * dtC
            _wsCurr   = _wsCurr   + _wsSpring * dtC
            local root = getRoot()
            if root then pcall(function()
                if _wsLinVel and _wsLinVel.Parent then
                    _wsLinVel.PlaneVelocity = Vector2.new(_wsCurr.X, _wsCurr.Z)
                else
                    local v = root.AssemblyLinearVelocity
                    root.AssemblyLinearVelocity = Vector3.new(_wsCurr.X, v.Y, _wsCurr.Z)
                end
            end) end
        else
            _wsCurr = Vector3.zero; _wsSpring = Vector3.zero
            _wsTarget = Vector3.zero; _destroyLinVel()
        end
        return
    end
    pcall(function()
        local root = getRoot()
        local hum  = getHum()
        if not (hum and root) then return end
        hum.WalkSpeed = 16
        if wsValue ~= 16 and hum.MoveDirection.Magnitude > 0.1 then
            _wsTarget = Vector3.new(hum.MoveDirection.X, 0, hum.MoveDirection.Z).Unit * wsValue
        else
            _wsTarget = Vector3.zero
        end
        local dtC = math.clamp(dt, 0.008, 0.05)
        local _f  = (_wsTarget - _wsCurr) * _WS_K - _wsSpring * _WS_D
        _wsSpring = _wsSpring + _f * dtC
        _wsCurr   = _wsCurr   + _wsSpring * dtC
        if _wsTarget.Magnitude > 0.1 or _wsCurr.Magnitude > 0.3 then
            pcall(function()
                _ensureLinVel(root)
                _wsLinVel.PlaneVelocity = Vector2.new(_wsCurr.X, _wsCurr.Z)
            end)
        else
            _destroyLinVel()
        end
        local animator = hum:FindFirstChildOfClass("Animator")
        if animator then
            local targetAnimSpd = wsValue == 16 and 1.0 or math.clamp(wsValue / 16, 0.4, 2.5)
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                pcall(function()
                    if math.abs(track.Speed - targetAnimSpd) > 0.03 then
                        track:AdjustSpeed(targetAnimSpd)
                    end
                end)
            end
        end
    end)
end)

-- Respawn handler
LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 10)
    if hum then
        if afEnabled then afApplyStates(true) end
    end
end)

-- ============================================================
-- CLOSE HANDLER
-- ============================================================
closeBtn.MouseButton1Click:Connect(function()
    stopSpam(); stopPiano()
    setAntiFling(false); setAntiPaused(false)
    _destroyLinVel()
    tw(main, 0.15, { BackgroundTransparency = 1 })
    task.delay(0.16, function() screenGui:Destroy() end)
end)

-- ============================================================
-- BUILD SECTIONS
-- ============================================================

-- ---- BATU ----
MakeSection("Batu")
MakeNote("TP ke lokasi batu, ambil, lalu balik ke posisi awal.")

local stoneStatus = MakeStatusLabel()

MakeButton("📍  Ambil Batu  (TP + E)", function()
    if isBusy then stoneStatus.Text = "Masih sibuk..."; return end
    stoneStatus.Text = "Teleporting..."
    local found = takeStone()
    stoneStatus.Text = found and "✅ Batu diambil! Sudah balik." or "⚠️ E ditekan. Sudah balik."
    task.delay(3, function() stoneStatus.Text = "" end)
end)

-- ---- TOOL SPAM ----
MakeSection("Tool Spam")
MakeNote("Prioritas WheelBarrow → Box. Equip/unequip tiap frame.")
MakeToggle("Spam Tool", false, function(state)
    if state then startSpam() else stopSpam() end
end)

-- ---- PROTEKSI ----
MakeSection("Proteksi")
MakeToggle("Anti Fling Parts", false, function(state)
    setAntiFling(state)
end)
MakeToggle("Anti Gameplay Paused", false, function(state)
    setAntiPaused(state)
end)

-- ---- MOVEMENT ----
MakeSection("Movement")
MakeNote("Walk Speed (spring-based). Default 16 = normal.")
-- FIX #1: slider default = 16 agar tidak mengubah speed saat execute
MakeSlider("Walk Speed", 1, 300, 16, 1, function(v)
    wsValue = v
end)

-- ---- PIANO ----
MakeSection("Piano")

MakeButton("📌  TP ke Piano 1", function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = PIANO_CFRAME_1 end
end)

MakeButton("📌  TP ke Piano 2", function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = PIANO_CFRAME_2 end
end)

local pianoRateLbl = MakeNote(string.format("🎵 Fired: 0   |   📊 0 / s  (target %d)", TOTAL_RATE))

MakeToggle(string.format("Spam All %d Keys Piano", NUM_KEYS), false, function(state)
    if state then
        local ok = startPiano()
        if not ok then
            pianoRateLbl.Text = "⚠️ GlobalPianoConnector tidak ditemukan!"
        end
    else
        stopPiano()
        pianoRateLbl.Text = string.format("🎵 Fired: %d   |   📊 0 / s  (target %d)", pianoFireCount, TOTAL_RATE)
    end
end)

-- ---- DARI DWheelBarrow ORIGINAL ----
MakeSection("Forest Fling")
MakeNote("Run server script untuk WM_Req remote (density fling).")

local wBrut_HEAVY  = 150
local wBrut_LIGHT  = 0.001
local wBrut_NORMAL = 0.7
local wBrut_FORCE  = 999999999999999999
local wBrut_enabled = false
local wBrut_force   = nil
local wBrut_lastSit = false
local wBrut_lastPax = nil

local function wBrut_getRemote() return RS:FindFirstChild("WM_Req") end
local function wBrut_removeForce()
    if wBrut_force and wBrut_force.Parent then wBrut_force:Destroy() end
    wBrut_force = nil
end
local function wBrut_applyForce(char)
    wBrut_removeForce()
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local bf = Instance.new("BodyForce")
    bf.Force  = Vector3.new(0, wBrut_FORCE, 0)
    bf.Parent = root
    wBrut_force = bf
end
local function wBrut_fire(target, density)
    local rem = wBrut_getRemote()
    if rem then rem:FireServer(target, density) end
end
local function wBrut_resetAll()
    local char = LocalPlayer.Character
    if char then wBrut_fire(char, wBrut_NORMAL) end
    if wBrut_lastPax then wBrut_fire(wBrut_lastPax, wBrut_NORMAL) end
    wBrut_removeForce()
    wBrut_lastSit = false; wBrut_lastPax = nil
end
local function wBrut_isSitting(char)
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum:GetState() == Enum.HumanoidStateType.Seated then return true end
    if hum and hum.SeatPart ~= nil then return true end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        for _, w in ipairs(root:GetChildren()) do
            if w:IsA("Weld") or w:IsA("WeldConstraint") or w:IsA("Motor6D") then
                local op = (w.Part0 ~= root) and w.Part0 or w.Part1
                if op and op.Parent ~= char then return true end
            end
        end
    end
    return false
end
local function wBrut_getPax()
    local char = LocalPlayer.Character
    if not char then return nil end
    for _, part in ipairs(workspace:GetDescendants()) do
        if (part:IsA("Seat") or part:IsA("VehicleSeat")) and part.Occupant then
            local oc = part.Occupant.Parent
            if oc ~= char and Players:GetPlayerFromCharacter(oc) then return oc end
        end
    end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") or tool:IsA("Model") then
            for _, part in ipairs(tool:GetDescendants()) do
                if (part:IsA("Seat") or part:IsA("VehicleSeat")) and part.Occupant then
                    local oc = part.Occupant.Parent
                    if oc ~= char then return oc end
                end
            end
        end
    end
    return nil
end

RunService.Heartbeat:Connect(function()
    if not wBrut_enabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    local sitting   = wBrut_isSitting(char)
    local passenger = wBrut_getPax()
    if sitting then
        if not wBrut_lastSit then
            wBrut_fire(char, wBrut_LIGHT)
            wBrut_applyForce(char)
        end
    else
        if wBrut_lastSit then
            wBrut_fire(char, wBrut_NORMAL)
            wBrut_removeForce()
        end
        if passenger ~= wBrut_lastPax then
            if wBrut_lastPax then wBrut_fire(wBrut_lastPax, wBrut_NORMAL) end
            if passenger    then wBrut_fire(passenger, wBrut_HEAVY) end
        end
    end
    wBrut_lastSit = sitting
    wBrut_lastPax = passenger
end)

LocalPlayer.CharacterAdded:Connect(function()
    wBrut_lastSit = false; wBrut_lastPax = nil; wBrut_force = nil
end)

MakeButton("Run Server (WM_Req)", function()
    if RS:FindFirstChild("WM_Req") then return end
    task.spawn(function()
        pcall(function()
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
    end)
end)

MakeSection("Brutal")
MakeToggle("Brutal", false, function(state)
    wBrut_enabled = state
    if not state then
        wBrut_resetAll()
    else
        wBrut_lastSit = false; wBrut_lastPax = nil
    end
end)

MakeSection("WalkFling")
MakeNote("NoClip torso + velocity blast tiap frame.")

local _wfActive     = false
local _wfNoclipConn = nil
local _wfLoopThread = nil
local _wfNoclipNames = { HumanoidRootPart = true, Torso = true, UpperTorso = true, LowerTorso = true, Head = true }

local function _wfStartNoclip()
    if _wfNoclipConn then return end
    _wfNoclipConn = RunService.Stepped:Connect(function()
        if not _wfActive then return end
        local ch = LocalPlayer and LocalPlayer.Character
        if not ch then return end
        for _, v in pairs(ch:GetDescendants()) do
            if v:IsA("BasePart") and _wfNoclipNames[v.Name] then
                v.CanCollide = false
            end
        end
    end)
end
local function _wfStopNoclip()
    if _wfNoclipConn then _wfNoclipConn:Disconnect(); _wfNoclipConn = nil end
    local ch = LocalPlayer and LocalPlayer.Character
    if ch then
        for _, v in pairs(ch:GetDescendants()) do
            if v:IsA("BasePart") and _wfNoclipNames[v.Name] then
                v.CanCollide = true
            end
        end
    end
end
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
        root.AssemblyLinearVelocity = vel * 999999999999999999999 + Vector3.new(0, 999999999999999999999, 0)
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
        local ch  = LocalPlayer and LocalPlayer.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Died:Connect(function()
                _wfActive = false
                _wfStopNoclip()
            end)
        end
        _wfStartNoclip()
        _wfLoopThread = task.spawn(_wfLoop)
    else
        _wfStopNoclip()
    end
end)

-- ============================================================
-- AUTO SIT
-- FIX #2: detect realtime setiap Heartbeat, plus hook equip/unequip
-- ============================================================
MakeSection("Auto Sit")
MakeNote("Auto duduk di WheelBarrow/Carriage terdekat.")

local wAS_excludedPlayers = {}
local wAS_enabled      = false
local wAS_wbModel      = nil
local wAS_wbSeat       = nil
-- FIX #2: hapus wAS_wbTick, detect dilakukan setiap Heartbeat tanpa throttle
local wAS_maxDist      = 3000
local wAS_autoTurun    = false
local wAS_turunDelay   = 0.03
local wAS_sitStartTick = 0
local wAS_sitTracked   = false
local wAS_lastWB       = nil

-- FIX #2: cooldown ringan agar tidak terlalu berat (tiap 5 frame cek model baru)
local wAS_scanTick     = 0
local wAS_SCAN_INTERVAL = 5

local VEHICLE_PATTERNS_AS = {
    "wheel.*barrow", "^carriage$", "carriage", "gerobak", "^cart$", "vehicle",
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
    wAS_wbModel = nil; wAS_wbSeat = nil
    wAS_sitStartTick = 0; wAS_sitTracked = false
end
local function wAS_findPusher(wbModel)
    local handlesPart = nil
    pcall(function()
        for _, p in ipairs(wbModel:GetDescendants()) do
            if p:IsA("BasePart") and p.Name:lower() == "handles" then handlesPart = p; break end
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
                if ch and part:IsDescendantOf(ch) then return ch:FindFirstChildOfClass("Humanoid") end
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
                            if (w.Part0 and w.Part0:IsDescendantOf(wbModel))
                               or (w.Part1 and w.Part1:IsDescendantOf(wbModel)) then
                                pusherHum = ch:FindFirstChildOfClass("Humanoid"); return
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
                        if d < nearDist then nearDist = d; pusherHum = ch:FindFirstChildOfClass("Humanoid") end
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
            if ch and ch:FindFirstChildOfClass("Humanoid") == hum then return plr.Name end
        end
    end
    return nil
end
local function wAS_findNearestWB(root, maxDist)
    local char  = LocalPlayer.Character
    local myHum = char and char:FindFirstChildOfClass("Humanoid")
    if myHum and myHum.SeatPart and myHum.SeatPart:IsA("VehicleSeat") then
        local seatModel = myHum.SeatPart:FindFirstAncestorOfClass("Model")
        if seatModel then return seatModel end
    end
    local best, bestDist = nil, maxDist
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local lname = obj.Name:lower()
            local isVehicle = false
            for _, pat in ipairs(VEHICLE_PATTERNS_AS) do
                if lname:match(pat) then isVehicle = true; break end
            end
            if isVehicle and obj ~= wAS_lastWB and wAS_isSeatFree(obj, myHum) then
                local pusherBlocking = false
                pcall(function()
                    local ph = wAS_findPusher(obj)
                    if ph then
                        local pName = wAS_humToPlayerName(ph)
                        if pName and wAS_excludedPlayers[pName] then pusherBlocking = true; return end
                        local pusherSeated = ph.SeatPart ~= nil
                        if not pusherSeated then
                            local ok, st = pcall(function() return ph:GetState() end)
                            pusherSeated = ok and (st == Enum.HumanoidStateType.Seated)
                        end
                        pusherBlocking = pusherSeated
                    end
                end)
                if not pusherBlocking then
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
    end
    return best
end

RunService.Heartbeat:Connect(function()
    if not wAS_enabled then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if not (char and root and hum) then return end

    -- FIX #2: scan model setiap wAS_SCAN_INTERVAL frame (5 frame ~= ~83ms di 60fps)
    -- jauh lebih responsif dari 20 frame sebelumnya, tapi tidak tiap frame agar ringan
    wAS_scanTick = wAS_scanTick + 1
    if wAS_scanTick >= wAS_SCAN_INTERVAL then
        wAS_scanTick = 0
        -- Cek model saat ini masih valid
        if wAS_wbModel and not wAS_wbModel.Parent then wAS_cleanup() end
        -- FIX #2: deteksi langsung tanpa nunggu 20 frame
        local found = wAS_findNearestWB(root, wAS_maxDist)
        if found and found ~= wAS_wbModel then
            wAS_wbModel = found
            wAS_wbSeat  = wAS_getSeat(found)
        elseif not found and not (hum.SeatPart) then
            -- hanya cleanup kalau memang tidak duduk
            wAS_cleanup()
        end
    end

    -- FIX #2: sit logic tetap jalan setiap Heartbeat (realtime, tidak di-throttle)
    if wAS_wbSeat and wAS_wbSeat.Parent then
        pcall(function()
            if hum.SeatPart == wAS_wbSeat then
                if not hum.Sit then hum.Sit = true end
                if wAS_autoTurun then
                    if not wAS_sitTracked then
                        wAS_sitStartTick = tick(); wAS_sitTracked = true
                    elseif tick() - wAS_sitStartTick >= wAS_turunDelay then
                        if wAS_wbModel then wAS_lastWB = wAS_wbModel end
                        hum.Sit = false
                        pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
                        wAS_cleanup()
                    end
                end
            elseif not hum.SeatPart then
                wAS_sitTracked = false
                -- FIX #2: langsung Sit setiap frame, bukan nunggu giliran tick
                wAS_wbSeat:Sit(hum)
            end
        end)
    end
end)

-- FIX #2: hook ke ChildAdded workspace untuk deteksi gerobak baru lebih cepat
workspace.ChildAdded:Connect(function(child)
    if not wAS_enabled then return end
    if not child:IsA("Model") then return end
    local lname = child.Name:lower()
    for _, pat in ipairs(VEHICLE_PATTERNS_AS) do
        if lname:match(pat) then
            -- ada gerobak baru, paksa rescan di frame berikutnya
            wAS_scanTick = wAS_SCAN_INTERVAL
            break
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    wAS_wbModel = nil; wAS_wbSeat = nil; wAS_scanTick = 0
    wAS_sitStartTick = 0; wAS_sitTracked = false; wAS_lastWB = nil
end)

MakeToggle("Auto Sit", false, function(state)
    wAS_enabled = state
    if state then
        wAS_lastWB = nil; wAS_scanTick = wAS_SCAN_INTERVAL  -- langsung scan
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            local found = wAS_findNearestWB(root, wAS_maxDist)
            if found then wAS_wbModel = found; wAS_wbSeat = wAS_getSeat(found) end
        end
    else wAS_cleanup() end
end)

MakeToggle("Auto Turun", false, function(state)
    wAS_autoTurun = state; wAS_sitStartTick = 0; wAS_sitTracked = false; wAS_lastWB = nil
end)

-- Exclude player list
local exclLabel = Instance.new("TextLabel")
exclLabel.Size                   = UDim2.new(1, 0, 0, 14)
exclLabel.BackgroundTransparency = 1
exclLabel.Font                   = Enum.Font.GothamMedium
exclLabel.Text                   = "Exclude Player (klik nama):"
exclLabel.TextColor3             = TEXT_DIM
exclLabel.TextSize               = 9
exclLabel.TextXAlignment         = Enum.TextXAlignment.Left
exclLabel.Parent                 = content

local exclFrame = Instance.new("Frame")
exclFrame.Size                   = UDim2.new(1, 0, 0, 90)
exclFrame.BackgroundColor3       = ELEM
exclFrame.BackgroundTransparency = ELEM_TRANS
exclFrame.BorderSizePixel        = 0
exclFrame.Parent                 = content
corner(exclFrame, 6)
mkstroke(exclFrame, STROKE_COL, 1, 0)

local exclScroll = Instance.new("ScrollingFrame")
exclScroll.Size                   = UDim2.new(1, -6, 1, -6)
exclScroll.Position               = UDim2.new(0, 3, 0, 3)
exclScroll.BackgroundTransparency = 1
exclScroll.BorderSizePixel        = 0
exclScroll.ScrollBarThickness     = 3
exclScroll.ScrollBarImageColor3   = Color3.fromRGB(80, 100, 160)
exclScroll.CanvasSize             = UDim2.new(0, 0, 0, 0)
exclScroll.AutomaticCanvasSize    = Enum.AutomaticSize.Y
exclScroll.Parent                 = exclFrame
local exclList = Instance.new("UIListLayout")
exclList.SortOrder = Enum.SortOrder.LayoutOrder
exclList.Padding   = UDim.new(0, 3)
exclList.Parent    = exclScroll

local function buildExclRow(plr)
    local row = Instance.new("TextButton")
    row.Size                   = UDim2.new(1, 0, 0, 22)
    row.BackgroundColor3       = Color3.fromRGB(18, 20, 32)
    row.BackgroundTransparency = 0
    row.BorderSizePixel        = 0
    row.Font                   = Enum.Font.GothamMedium
    row.Text                   = "  " .. plr.DisplayName .. "  (@" .. plr.Name .. ")"
    row.TextColor3             = TEXT_DIM
    row.TextSize               = 9
    row.TextXAlignment         = Enum.TextXAlignment.Left
    row.TextTruncate           = Enum.TextTruncate.AtEnd
    row.AutoButtonColor        = false
    row.Parent                 = exclScroll
    corner(row, 4)
    local function applyState()
        if wAS_excludedPlayers[plr.Name] then
            row.TextColor3       = Color3.fromRGB(255, 100, 100)
            row.BackgroundColor3 = Color3.fromRGB(40, 18, 18)
        else
            row.TextColor3       = TEXT_DIM
            row.BackgroundColor3 = Color3.fromRGB(18, 20, 32)
        end
    end
    applyState()
    row.MouseButton1Click:Connect(function()
        wAS_excludedPlayers[plr.Name] = not wAS_excludedPlayers[plr.Name] or nil
        applyState()
    end)
end

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then buildExclRow(plr) end
end
Players.PlayerAdded:Connect(function(plr)
    if plr ~= LocalPlayer then buildExclRow(plr) end
end)
Players.PlayerRemoving:Connect(function(plr)
    wAS_excludedPlayers[plr.Name] = nil
end)

MakeSection("Wheelbarrow Fly")
MakeNote("Terbang dengan WheelBarrow terdekat. WASD + Space/Shift.")

local wFly_speed      = 60
local wFly_enabled    = false
local wFly_UIS        = UserInputService
local wFly_thumbX     = 0
local wFly_thumbY     = 0
local wFly_mobUp      = false
local wFly_mobDown    = false
local wFly_mobFwd     = false
local wFly_mobBwd     = false
local wFly_wbLV       = nil
local wFly_wbAtt      = nil
local wFly_wbBase     = nil
local wFly_wbWelds    = {}
local wFly_wbAnchSave = {}
local wFly_wbModel    = nil
local wFly_wbTick     = 0
local wFly_wbSeat     = nil
local wFly_savedWS    = 16
local wFly_savedJP    = 50

pcall(function()
    wFly_UIS.ThumbstickMoved:Connect(function(stick, pos)
        if stick == Enum.KeyCode.Thumbstick1 then
            wFly_thumbX = pos.X; wFly_thumbY = pos.Y
        end
    end)
end)

local function wFly_makeLV(part)
    local att = Instance.new("Attachment")
    att.Position = Vector3.zero; att.Parent = part
    local lv = Instance.new("LinearVelocity")
    lv.Attachment0 = att
    lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
    lv.RelativeTo     = Enum.ActuatorRelativeTo.World
    lv.VectorVelocity = Vector3.zero
    lv.MaxForce       = math.huge
    lv.Parent         = part
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
    wFly_wbLV, wFly_wbAtt, wFly_wbBase, wFly_wbModel, wFly_wbSeat = nil, nil, nil, nil, nil
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
    wFly_wbModel = wbModel; wFly_wbBase = base
    wFly_wbAnchSave[base] = base.Anchored
    pcall(function() base.Anchored = false end)
    for _, p in ipairs(wbModel:GetDescendants()) do
        if p:IsA("BasePart") and p ~= base then
            wFly_wbAnchSave[p] = p.Anchored
            pcall(function() p.Anchored = false end)
            local wc = Instance.new("WeldConstraint")
            wc.Part0 = base; wc.Part1 = p; wc.Parent = base
            table.insert(wFly_wbWelds, wc)
        end
    end
    for _, inst in ipairs(base:GetDescendants()) do
        if inst:IsA("BodyVelocity") then pcall(function() inst.maxForce = Vector3.zero end)
        elseif inst:IsA("BodyAngularVelocity") then pcall(function() inst.maxTorque = Vector3.zero end) end
    end
    for _, inst in ipairs(wbModel:GetDescendants()) do
        if inst:IsA("BodyVelocity") then pcall(function() inst.maxForce = Vector3.zero end)
        elseif inst:IsA("BodyAngularVelocity") then pcall(function() inst.maxTorque = Vector3.zero end) end
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
    if not (char and root) then return end
    local cam = workspace.CurrentCamera
    if not cam then return end
    wFly_wbTick = wFly_wbTick + 1
    if wFly_wbTick >= 20 then
        wFly_wbTick = 0
        if wFly_wbModel and not wFly_wbModel.Parent then wFly_cleanupWb() end
        local found = wFly_findNearestWB(root, 8)
        if found and found ~= wFly_wbModel then wFly_attachWb(found)
        elseif not found and wFly_wbModel then wFly_cleanupWb() end
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(function()
            if hum.WalkSpeed ~= 16 then hum.WalkSpeed = 16 end
            if hum.JumpPower  ~= 0  then hum.JumpPower  = 0  end
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
    local lv2  = cam.CFrame.LookVector
    local rv2  = cam.CFrame.RightVector
    local flatFwd = Vector3.new(lv2.X, 0, lv2.Z)
    local flatRgt = Vector3.new(rv2.X, 0, rv2.Z)
    if flatFwd.Magnitude > 0.01 then flatFwd = flatFwd.Unit end
    if flatRgt.Magnitude > 0.01 then flatRgt = flatRgt.Unit end
    if wFly_UIS:IsKeyDown(Enum.KeyCode.W) then hDir = hDir + flatFwd end
    if wFly_UIS:IsKeyDown(Enum.KeyCode.S) then hDir = hDir - flatFwd end
    if wFly_UIS:IsKeyDown(Enum.KeyCode.A) then hDir = hDir - flatRgt end
    if wFly_UIS:IsKeyDown(Enum.KeyCode.D) then hDir = hDir + flatRgt end
    if wFly_UIS:IsKeyDown(Enum.KeyCode.Space)      then vY =  1 end
    if wFly_UIS:IsKeyDown(Enum.KeyCode.LeftShift)  then vY = -1 end
    if hDir.Magnitude > 0.01 then hDir = hDir.Unit end
    local vel = Vector3.new(hDir.X, vY, hDir.Z) * wFly_speed
    pcall(function()
        root.AssemblyLinearVelocity  = vel
        root.AssemblyAngularVelocity = Vector3.zero
    end)
    if wFly_wbLV and wFly_wbLV.Parent then wFly_wbLV.VectorVelocity = vel end
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
    if state then
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then pcall(function() wFly_savedWS = hum.WalkSpeed; wFly_savedJP = hum.JumpPower end) end
            local found = wFly_findNearestWB(root, 8)
            if found then wFly_attachWb(found) end
        end
    else
        local char = LocalPlayer.Character
        if char then
            local hum  = char:FindFirstChildOfClass("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")
            if hum then pcall(function() hum.WalkSpeed = wFly_savedWS; hum.JumpPower = wFly_savedJP end) end
            if root then pcall(function() root.AssemblyAngularVelocity = Vector3.zero end) end
        end
        wFly_cleanupWb(); wFly_wbTick = 0
        wFly_thumbX, wFly_thumbY = 0, 0
        wFly_mobUp, wFly_mobDown, wFly_mobFwd, wFly_mobBwd = false, false, false, false
    end
end)

LocalPlayer.CharacterAdded:Connect(function(newChar)
    if not wFly_enabled then return end
    wFly_cleanupWb(); wFly_wbTick = 0
    task.wait(0.3)
    local hum = newChar:FindFirstChildOfClass("Humanoid")
    if hum then pcall(function() wFly_savedWS = hum.WalkSpeed; wFly_savedJP = hum.JumpPower end) end
end)

-- ============================================================
-- PIANO RATE UPDATE LOOP
-- ============================================================
task.spawn(function()
    while screenGui and screenGui.Parent do
        task.wait(1)
        if pianoEnabled then
            local now    = os.clock()
            local dCount = pianoFireCount - pianoRateCount
            local dTime  = now - pianoRateTime
            local rate   = dTime > 0 and (dCount / dTime) or 0
            pianoRateLbl.Text       = string.format("🎵 Fired: %d   |   📊 %.0f / s  (target %d)", pianoFireCount, rate, TOTAL_RATE)
            pianoRateLbl.TextColor3 = rate >= TOTAL_RATE * 0.9
                and Color3.fromRGB(100, 230, 140)
                or  Color3.fromRGB(255, 110, 110)
            pianoRateCount = pianoFireCount
            pianoRateTime  = now
        else
            pianoRateLbl.Text       = string.format("🎵 Fired: %d   |   📊 0 / s  (target %d)", pianoFireCount, TOTAL_RATE)
            pianoRateLbl.TextColor3 = NOTE_COL
        end
    end
end)

print("✅ CENN MEGA HUB Loaded!")