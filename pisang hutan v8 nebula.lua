-- ================================================
--   🍌 Banana Peel - Hutan @cenntzy
--   UI: Nebula UI (SugaBlaz) + Key System Manual (wajib tiap execute)
-- ================================================

local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ================================================
-- Load Nebula UI Library
-- ================================================

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SugaBlaz/UI-Library/refs/heads/main/Nebula%20UI.lua"))()

-- ================================================
-- 🔑 KEY SYSTEM MANUAL
-- Wajib dimasukkan SETIAP kali script di-execute (tidak disimpan/save),
-- key diambil langsung dari key.txt di GitHub setiap kali user submit.
-- ================================================

local KEY_URL = "https://raw.githubusercontent.com/notceenn/cenn_script/refs/heads/main/key.txt"

local function GetRemoteKey()
    local success, result = pcall(function()
        return game:HttpGet(KEY_URL)
    end)
    if success and result then
        return (result:gsub("^%s+", ""):gsub("%s+$", ""))
    end
    return nil
end

local keyAccepted = false

local function RequireKey()
    if not keyAccepted then
        Library:Notify({ Title = "🔒 Terkunci", Text = "Masukkan key dulu di tab 🔑 Key!", Duration = 3 })
        return true -- true = terkunci (blokir)
    end
    return false
end

local Config = {
    Speed        = 800,
    TargetPart   = "HumanoidRootPart",
    Tracer       = false
}
local targetPlayer  = nil
local active        = false
local conn          = nil
local myBananas     = {}
local lastThrowTime = 0

local tracerBeam = nil
local attach0    = nil
local attach1    = nil

local bodyPartsList = {
    "Head","UpperTorso","LowerTorso","Torso",
    "LeftUpperArm","LeftLowerArm","LeftHand",
    "RightUpperArm","RightLowerArm","RightHand",
    "LeftUpperLeg","LeftLowerLeg","LeftFoot",
    "RightUpperLeg","RightLowerLeg","RightFoot",
    "HumanoidRootPart"
}

-- ================================================
-- UTILITY
-- ================================================

local function FilterPlayers(input)
    local result, kw = {}, input:lower()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if kw == "" or plr.Name:lower():find(kw, 1, true) or plr.DisplayName:lower():find(kw, 1, true) then
                table.insert(result, plr.DisplayName.." ("..plr.Name..")")
            end
        end
    end
    if #result == 0 then table.insert(result, "Tidak ditemukan") end
    return result
end

local function ParsePlayer(str)
    local u = str:match("%((.-)%)")
    return u and Players:FindFirstChild(u) or nil
end

local function AutoSelect(input)
    if #input < 3 then return nil end
    local kw = input:lower()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if plr.Name:lower():find(kw, 1, true) or plr.DisplayName:lower():find(kw, 1, true) then
                return plr
            end
        end
    end
    return nil
end

local function ClaimIfMine(obj)
    if not obj or obj.Name ~= "Handle" or not obj:IsA("BasePart") then return end
    if LocalPlayer.Character and obj:IsDescendantOf(LocalPlayer.Character) then return end

    if tick() - lastThrowTime <= 2 then
        myBananas[obj] = true
        pcall(function() obj.Anchored = false; obj.CanCollide = false end)
        return
    end
    if obj:FindFirstChild("BananaScript") or obj:FindFirstChild("UpdatedBanana") then
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root and (obj.Position - root.Position).Magnitude <= 20 then
            myBananas[obj] = true
        end
    end
end

workspace.ChildAdded:Connect(function(obj)
    pcall(ClaimIfMine, obj)
    task.delay(0.1, function() pcall(ClaimIfMine, obj) end)
    task.delay(0.2, function() pcall(ClaimIfMine, obj) end)
end)

workspace.DescendantAdded:Connect(function(obj)
    pcall(ClaimIfMine, obj)
end)

for _, obj in ipairs(workspace:GetChildren()) do
    pcall(ClaimIfMine, obj)
end

local function FindBananas()
    local list = {}
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj.Name == "Handle" and obj:IsA("BasePart") and myBananas[obj] then
            if not (LocalPlayer.Character and obj:IsDescendantOf(LocalPlayer.Character)) then
                table.insert(list, obj)
            end
        end
    end
    return list
end

-- ================================================
-- VISUAL: Highlight + Jarak
-- ================================================

local victimHighlight   = nil
local victimBillboard   = nil

local function ClearVictimVisuals()
    if victimHighlight then victimHighlight:Destroy() end
    if victimBillboard then victimBillboard:Destroy() end
    victimHighlight, victimBillboard = nil, nil
end

local function SetupVictimVisuals(plr)
    ClearVictimVisuals()
    if not plr or not plr.Character then return end
    local char = plr.Character
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    victimHighlight = Instance.new("Highlight")
    victimHighlight.FillColor = Color3.fromRGB(180, 40, 40)
    victimHighlight.OutlineColor = Color3.fromRGB(180, 40, 40)
    victimHighlight.FillTransparency = 0.85
    victimHighlight.OutlineTransparency = 0.6
    victimHighlight.Parent = char

    victimBillboard = Instance.new("BillboardGui")
    victimBillboard.Name = "BananaDistanceGui"
    victimBillboard.Size = UDim2.new(0, 110, 0, 20)
    victimBillboard.StudsOffset = Vector3.new(0, 3, 0)
    victimBillboard.AlwaysOnTop = true
    victimBillboard.Parent = char:FindFirstChild("Head") or root

    local label = Instance.new("TextLabel")
    label.Name = "DistanceLabel"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 10
    label.TextColor3 = Color3.fromRGB(255, 255, 0)
    label.TextStrokeTransparency = 0
    label.Text = "Jarak Korban: 0 studs"
    label.Parent = victimBillboard
end

local function UpdateVictimVisuals()
    if not targetPlayer or not targetPlayer.Character then return end
    local root = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root or not myRoot then return end

    if not victimBillboard or not victimBillboard.Parent then
        SetupVictimVisuals(targetPlayer)
        return
    end

    local dist = (root.Position - myRoot.Position).Magnitude
    local label = victimBillboard:FindFirstChild("DistanceLabel")
    if label then
        label.Text = string.format("Jarak Korban: %.1f studs", dist)
    end
end

-- ================================================
-- TRACER LINE
-- ================================================

local function CreateTracer()
    if tracerBeam then return end
    local beam = Instance.new("Beam")
    beam.Name = "BananaTracer"
    beam.Color = ColorSequence.new(Color3.fromRGB(255,255,0))
    beam.Width0 = 0.15
    beam.Width1 = 0.15
    beam.FaceCamera = true
    beam.Parent = workspace

    attach0 = Instance.new("Attachment")
    attach0.Parent = workspace.Terrain
    attach1 = Instance.new("Attachment")
    attach1.Parent = workspace.Terrain

    beam.Attachment0 = attach0
    beam.Attachment1 = attach1
    tracerBeam = beam
end

local function DestroyTracer()
    if tracerBeam then tracerBeam:Destroy() end
    if attach0 then attach0:Destroy() end
    if attach1 then attach1:Destroy() end
    tracerBeam, attach0, attach1 = nil, nil, nil
end

-- ================================================
-- 🔥 GLOBAL ATTACK (Prediksi Lari/Loncat + Serangan Ke Atas)
-- ================================================

local function StartChase()
    if conn then conn:Disconnect() end
    if targetPlayer == LocalPlayer then return end
    active = true
    SetupVictimVisuals(targetPlayer)

    if Config.Tracer then CreateTracer() end

    conn = RunService.Heartbeat:Connect(function(dt)
        if not active then return end
        if not targetPlayer or not targetPlayer.Character then return end
        if targetPlayer == LocalPlayer then return end

        local character = targetPlayer.Character
        local targetRoot = character:FindFirstChild("HumanoidRootPart")
        local humanoid   = character:FindFirstChildOfClass("Humanoid")
        if not targetRoot then return end

        local targetPart = character:FindFirstChild(Config.TargetPart)
        if not targetPart or not targetPart:IsA("BasePart") then
            targetPart = targetRoot
        end

        -- Bersihkan myBananas yang sudah hilang
        for obj, _ in pairs(myBananas) do
            if not obj or not obj.Parent then myBananas[obj] = nil end
        end

        -- nilai ekstrem glitch
        local EXTREME = Vector3.new(999999, 999999, 999999)

        -- Prediksi posisi target: velocity + gravity untuk loncat/lari
        local vel = targetPart.AssemblyLinearVelocity
        local gravity = workspace.Gravity
        local predictTime = 0.15
        local predictedPos = targetPart.Position + vel * predictTime + Vector3.new(0, -0.5 * gravity * predictTime^2, 0)

        for _, banana in ipairs(FindBananas()) do
            if not banana or not banana.Parent then continue end

            -- Update tracer
            if tracerBeam and attach0 and attach1 then
                attach0.Parent = banana
                attach1.Parent = targetPart
            end

            -- Pisang di posisi prediksi (mengikuti lari/loncat)
            pcall(function()
                banana.CFrame = CFrame.new(predictedPos)
            end)
            banana.Anchored = false
            banana.CanCollide = false
            -- nilai ekstrem glitch
            banana.AssemblyLinearVelocity = EXTREME
            banana.AssemblyAngularVelocity = EXTREME

            -- Matikan humanoid
            if humanoid then
                pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Physics) end)
                humanoid.PlatformStand = true
                humanoid.Sit = false
                humanoid.WalkSpeed = 0
                humanoid.JumpPower = 0
            end

            -- Hancurkan semua BodyMover lama
            for _, child in ipairs(targetRoot:GetChildren()) do
                if child:IsA("BodyMover") then child:Destroy() end
            end

            -- Serangan SELALU KE ATAS full power
            local rigVelocity = targetRoot.AssemblyLinearVelocity
            local rigAngular = targetRoot.AssemblyAngularVelocity
            local upBlast = Vector3.new(0, 999999, 0)

            targetRoot.AssemblyLinearVelocity = rigVelocity + upBlast
            targetRoot.AssemblyAngularVelocity = rigAngular + EXTREME

            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.new(0, 999999, 0)
            bv.Parent = targetRoot

            local bav = Instance.new("BodyAngularVelocity")
            bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bav.AngularVelocity = EXTREME
            bav.Parent = targetRoot

            -- Dorong semua bagian tubuh ke atas
            for _, part in ipairs(character:GetChildren()) do
                if part:IsA("BasePart") and part ~= targetRoot then
                    part.AssemblyLinearVelocity = EXTREME
                    part.AssemblyAngularVelocity = EXTREME
                end
            end
        end

        UpdateVictimVisuals()
    end)

    Library:Notify({
        Title    = "🍌 GLOBAL ATTACK!",
        Text     = "PREDIKSI LARI/LONCAT + Serangan SELALU KE ATAS!",
        Duration = 3,
    })
end

local function StopChase()
    active = false
    if conn then conn:Disconnect() conn = nil end
    ClearVictimVisuals()
    DestroyTracer()
    Library:Notify({ Title="🍌 Dimatikan", Text="", Duration=2 })
end

-- ================================================
-- LEMPAR
-- ================================================

local function FindBananaTool()
    local sources = { LocalPlayer:FindFirstChild("Backpack"), LocalPlayer.Character }
    for _, src in ipairs(sources) do
        if src then
            for _, obj in ipairs(src:GetChildren()) do
                if obj:IsA("Tool") and (obj.Name:lower():find("banana") or obj.Name:lower():find("peel")) then
                    return obj
                end
            end
        end
    end
    return nil
end

local function ThrowBanana()
    local char = LocalPlayer.Character
    if not char then return end
    local tool = FindBananaTool()
    if not tool then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid and tool.Parent ~= char then
        pcall(function() humanoid:EquipTool(tool) end)
        task.wait(0.1)
    end
    lastThrowTime = tick()
    pcall(function() tool:Activate() end)
end

-- ================================================
-- UI (Nebula) - TANPA custom theme, pakai default
-- ================================================

local Window = Library:CreateWindow({
    Name     = "Banana Peel - Hutan @cenntzy",
    SaveName = "BananaPeel_Hutan",
    Size     = UDim2.new(0.42, 0, 0.55, 0),
    Position = UDim2.new(0.5, 0, 0.5, 0),
})

local KeyTab  = Window:CreateTab("🔑 Key")
local MainTab = Window:CreateTab("🍌 Main")
local SetTab  = Window:CreateTab("⚙️ Settings")
local DevTab  = Window:CreateTab("👨‍💻 Developer")

-- ================================================
-- 🔑 TAB KEY
-- ================================================

KeyTab:CreateLabel("Key System\nMasukkan key untuk membuka Banana Peel - Hutan.\nKey WAJIB dimasukkan setiap kali script dijalankan.\nMinta key ke pemilik script (@cenntzy).")

KeyTab:CreateTextbox({
    Name            = "Masukkan Key",
    CurrentValue    = "",
    PlaceholderText = "Ketik key di sini lalu Enter...",
    Flag            = "KeyInputBox",
    Callback        = function(input)
        if keyAccepted then return end

        local cleanInput = input:gsub("^%s+", ""):gsub("%s+$", "")
        if cleanInput == "" then return end

        local validKey = GetRemoteKey()

        if not validKey then
            Library:Notify({ Title = "⚠️ Error", Text = "Gagal mengambil data key. Cek koneksi internet kamu!", Duration = 4 })
            return
        end

        if cleanInput == validKey then
            keyAccepted = true
            Library:Notify({ Title = "✅ Key Benar!", Text = "Selamat datang di Banana Peel - Hutan!", Duration = 4 })
        else
            Library:Notify({ Title = "❌ KEY SALAH!", Text = "Key salah tolol! Coba lagi.", Duration = 4 })
        end
    end,
})

-- ================================================
-- 🍌 TAB MAIN (dikunci sampai key benar)
-- ================================================

local playerDropdown
local function RefreshDrop(kw)
    pcall(function()
        if playerDropdown then
            playerDropdown:Update(FilterPlayers(kw or ""), true)
        end
    end)
end

MainTab:CreateSection("Target")

MainTab:CreateTextbox({
    Name            = "Cari Nama / Nickname",
    CurrentValue    = "",
    PlaceholderText = "Ketik 3+ huruf → auto terpilih!",
    Flag            = "SearchBox",
    Callback        = function(input)
        if RequireKey() then return end
        pcall(function() RefreshDrop(input) end)
        local found = AutoSelect(input)
        if found and found ~= targetPlayer then
            targetPlayer = found
            if active then SetupVictimVisuals(targetPlayer) end
            Library:Notify({ Title = "✅ "..found.DisplayName, Text = "Username: "..found.Name, Duration = 2 })
        elseif #input == 0 then targetPlayer = nil end
    end,
})

playerDropdown = MainTab:CreateDropdown({
    Name          = "Atau Pilih dari List",
    Options       = FilterPlayers(""),
    CurrentOption = "Pilih player...",
    Flag          = "PlayerSelect",
    Callback      = function(sel)
        if RequireKey() then return end
        local str = type(sel) == "table" and sel[1] or sel
        local plr = ParsePlayer(str)
        if plr then
            targetPlayer = plr
            if active then SetupVictimVisuals(targetPlayer) end
            Library:Notify({ Title = "🎯 "..plr.DisplayName, Text = "Username: "..plr.Name, Duration = 2 })
        end
    end,
})

MainTab:CreateButton({
    Name     = "🔄 Refresh List",
    Callback = function()
        if RequireKey() then return end
        RefreshDrop("")
    end
})

MainTab:CreateSection("Control")

MainTab:CreateToggle({
    Name         = "🍌 Enable Banana Chaser",
    CurrentValue = false,
    Flag         = "EnableToggle",
    Callback     = function(val)
        if RequireKey() then return end
        if val then
            if not targetPlayer then Library:Notify({ Title = "Pilih target dulu!", Text = "", Duration = 2 }) return end
            StartChase()
        else StopChase() end
    end,
})

MainTab:CreateButton({
    Name     = "🎯 Lempar Banana Peel",
    Callback = function()
        if RequireKey() then return end
        ThrowBanana()
        Library:Notify({ Title = "🍌", Text = "Pisang dilempar!", Duration = 2 })
    end
})

MainTab:CreateLabel("Cara Pakai\n1. Masukkan Key di tab 🔑 Key\n2. Pilih target\n3. Atur bagian tubuh di Settings\n4. Enable & lempar pisang!\n5. Pisang prediksi lari/loncat & serangan SELALU KE ATAS 999999! 🍌💀")

-- ================================================
-- ⚙️ TAB SETTINGS (dikunci sampai key benar)
-- ================================================

SetTab:CreateSection("Target Bagian Tubuh")
SetTab:CreateDropdown({
    Name          = "Bagian Tubuh",
    Options       = bodyPartsList,
    CurrentOption = "HumanoidRootPart",
    Flag          = "BodyPartSelect",
    Callback      = function(sel)
        if RequireKey() then return end
        local str = type(sel) == "table" and sel[1] or sel
        Config.TargetPart = str
    end
})

SetTab:CreateSection("Visual")
SetTab:CreateToggle({
    Name         = "Tracer Line",
    CurrentValue = false,
    Flag         = "TracerToggle",
    Callback     = function(val)
        if RequireKey() then return end
        Config.Tracer = val
        if val then if active then CreateTracer() end else DestroyTracer() end
    end
})

SetTab:CreateSection("Kecepatan")
SetTab:CreateSlider({
    Name         = "Speed Pisang",
    Range        = {100, 3000},
    CurrentValue = 900,
    Flag         = "BananaSpeed",
    Callback     = function(v)
        if RequireKey() then return end
        Config.Speed = v
    end
})

SetTab:CreateLabel("Panduan Speed\n300   = pelan\n500   = sedang\n800   = default\n1200 = kencang\n3000 = MAXIMUM 💀")

-- ================================================
-- 👨‍💻 TAB DEVELOPER
-- ================================================

DevTab:CreateSection("Tentang Script")

DevTab:CreateLabel("Banana Peel - Hutan\nDibuat oleh: @cenntzy\nDiscord: @cenntzy\n\nUntuk request key, bug report, atau saran fitur, hubungi langsung lewat Discord di atas.")

DevTab:CreateButton({
    Name     = "📋 Copy Discord: @cenntzy",
    Callback = function()
        pcall(function()
            if setclipboard then
                setclipboard("@cenntzy")
                Library:Notify({ Title = "📋 Disalin!", Text = "Discord @cenntzy sudah disalin ke clipboard.", Duration = 3 })
            else
                Library:Notify({ Title = "Discord", Text = "@cenntzy", Duration = 5 })
            end
        end)
    end
})

Players.PlayerAdded:Connect(function() task.wait(0.5) RefreshDrop("") end)
Players.PlayerRemoving:Connect(function(plr)
    if targetPlayer == plr then targetPlayer = nil StopChase() end
    task.wait(0.5) RefreshDrop("")
end)
