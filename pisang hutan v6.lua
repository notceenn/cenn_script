-- ================================================
--   🍌 Hutan Pisang - By Notceenn
--   Pisang menyerang (terbang) tanpa batas jarak
--   🔑 Dengan Key System (remote controlled)
-- ================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Config       = { Speed = 800 }
local targetPlayer  = nil
local active        = false
local conn          = nil
local myBananas     = setmetatable({}, {__mode = "k"})

-- ================================================
-- UTILITY
-- ================================================

local function FilterPlayers(input)
    local result, kw = {}, input:lower()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if kw == ""
                or plr.Name:lower():find(kw, 1, true)
                or plr.DisplayName:lower():find(kw, 1, true)
            then
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
            if plr.Name:lower():find(kw, 1, true)
                or plr.DisplayName:lower():find(kw, 1, true)
            then return plr end
        end
    end
    return nil
end

local function FindBananas()
    local list = {}
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj.Name == "Handle" and obj:IsA("BasePart") and myBananas[obj] then
            if obj:FindFirstChild("BananaScript") or obj:FindFirstChild("UpdatedBanana") then
                table.insert(list, obj)
            end
        end
    end
    return list
end

-- ================================================
-- OWNERSHIP: hanya pisang milik LocalPlayer yang dihoming
-- ================================================

local function ClaimIfMine(obj)
    if not obj or obj.Name ~= "Handle" or not obj:IsA("BasePart") then return end
    if not (obj:FindFirstChild("BananaScript") or obj:FindFirstChild("UpdatedBanana")) then return end

    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- Pisang yang baru muncul dekat posisi kita = pisang yang kita lempar
    if (obj.Position - root.Position).Magnitude <= 15 then
        myBananas[obj] = true
    end
end

workspace.ChildAdded:Connect(function(obj)
    task.defer(function()
        pcall(ClaimIfMine, obj)
    end)
end)

for _, obj in ipairs(workspace:GetChildren()) do
    pcall(ClaimIfMine, obj)
end

-- ================================================
-- VISUAL: Highlight + Garis Jarak Terpental di korban
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

    -- Self-healing kalau karakter korban respawn
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

local function GetCenter(char)
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local pos
    pcall(function()
        local cf = char:GetBoundingBox()
        pos = cf.Position
    end)
    return pos or root.Position
end

-- ================================================
-- CHASE (menyerang terbang ke target, tanpa batas jarak)
-- ================================================

local function StartChase()
    if conn then conn:Disconnect() end
    if targetPlayer == LocalPlayer then return end
    active = true
    SetupVictimVisuals(targetPlayer)

    conn = RunService.Heartbeat:Connect(function()
        if not active then return end
        if not targetPlayer or not targetPlayer.Character then return end
        if targetPlayer == LocalPlayer then return end

        local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local targetPos  = GetCenter(targetPlayer.Character)
        if not targetPos or not targetRoot then return end

        local targetVel = targetRoot.AssemblyLinearVelocity

        for _, banana in ipairs(FindBananas()) do
            if not banana or not banana.Parent then continue end

            local dist = (targetPos - banana.Position).Magnitude

            -- Prediksi posisi target lebih jauh ke depan (2x travel time) supaya
            -- lebih akurat mengejar korban yang loncat-loncat / gerak cepat
            local travelTime    = dist / Config.Speed
            local predictedPos  = targetPos + targetVel * (travelTime * 2)
            local toPredicted   = predictedPos - banana.Position
            local dir = toPredicted.Magnitude > 0.01 and toPredicted.Unit or (targetPos - banana.Position).Unit

            banana.Anchored   = false
            banana.CanCollide = false
            banana.AssemblyLinearVelocity  = dir * (Config.Speed * 1.5)
            banana.AssemblyAngularVelocity = Vector3.zero

            -- Saat pisang sudah sangat dekat, langsung dorong korban instant & sekencang-kencangnya
            if dist <= 6 then
                targetRoot.AssemblyLinearVelocity = dir * (Config.Speed * 3) + Vector3.new(0, 80, 0)
            end
        end

        UpdateVictimVisuals()
    end)

    Rayfield:Notify({
        Title   = "🍌 Aktif!",
        Content = "Menyerang "..targetPlayer.DisplayName.."!",
        Duration = 3,
    })
end

local function StopChase()
    active = false
    if conn then conn:Disconnect() conn = nil end
    ClearVictimVisuals()
    Rayfield:Notify({ Title="🍌 Dimatikan", Duration=2 })
end

-- ================================================
-- UI (dengan Key System)
-- ================================================

local Window = Rayfield:CreateWindow({
    Name            = "Hutan Pisang - By Notceenn",
    LoadingTitle    = "Hutan Pisang",
    LoadingSubtitle = "By Notceenn",
    Theme           = "Default",
    ConfigurationSaving = { Enabled = false },

    KeySystem = true, -- Aktifkan key system
    KeySettings = {
        Title           = "Hutan Pisang - Key System",
        Subtitle        = "Masukkan key untuk lanjut",
        Note            = "Minta key ke pemilik script (Notceenn)",
        FileName        = "CennKey_HutanPisang", -- nama file simpan key lokal user
        SaveKey         = true, -- key tersimpan, gak perlu input ulang tiap join
        GrabKeyFromSite = true, -- ambil key dari link GitHub (bisa kamu ubah kapan saja)
        Key = {
            "https://raw.githubusercontent.com/notceenn/cenn_script/refs/heads/main/key.txt"
        }
    },
})

local MainTab = Window:CreateTab("🍌 Main", 4483362458)
local SetTab  = Window:CreateTab("⚙️ Settings", 4483362458)

local playerDropdown
local function RefreshDrop(kw)
    pcall(function()
        if playerDropdown then
            playerDropdown:Refresh(FilterPlayers(kw or ""), true)
        end
    end)
end

-- MAIN TAB
MainTab:CreateSection("Target")

MainTab:CreateInput({
    Name                     = "Cari Nama / Nickname",
    PlaceholderText          = "Ketik 3+ huruf → auto terpilih!",
    RemoveTextAfterFocusLost = false,
    Flag                     = "SearchBox",
    Callback                 = function(input)
        pcall(function() RefreshDrop(input) end)
        local found = AutoSelect(input)
        if found and found ~= targetPlayer then
            targetPlayer = found
            if active then SetupVictimVisuals(targetPlayer) end
            Rayfield:Notify({
                Title   = "✅ "..found.DisplayName,
                Content = "Username: "..found.Name,
                Duration = 2,
            })
        elseif #input == 0 then
            targetPlayer = nil
        end
    end,
})

playerDropdown = MainTab:CreateDropdown({
    Name            = "Atau Pilih dari List",
    Options         = FilterPlayers(""),
    CurrentOption   = {"Pilih player..."},
    MultipleOptions = false,
    Flag            = "PlayerSelect",
    Callback        = function(sel)
        local str = type(sel) == "table" and sel[1] or sel
        local plr = ParsePlayer(str)
        if plr then
            targetPlayer = plr
            if active then SetupVictimVisuals(targetPlayer) end
            Rayfield:Notify({
                Title   = "🎯 "..plr.DisplayName,
                Content = "Username: "..plr.Name,
                Duration = 2,
            })
        end
    end,
})

MainTab:CreateButton({
    Name     = "🔄 Refresh List",
    Callback = function() RefreshDrop("") end,
})

MainTab:CreateDivider()
MainTab:CreateSection("Control")

MainTab:CreateToggle({
    Name         = "🍌 Enable Banana Chaser",
    CurrentValue = false,
    Flag         = "EnableToggle",
    Callback     = function(val)
        if val then
            if not targetPlayer then
                Rayfield:Notify({
                    Title   = "Pilih target dulu!",
                    Duration = 2,
                })
                return
            end
            StartChase()
        else
            StopChase()
        end
    end,
})

MainTab:CreateParagraph({
    Title   = "Cara Pakai",
    Content = "1. Ketik 3+ huruf → auto terpilih\n2. Enable Banana Chaser\n3. Equip & lempar Banana Peel!\n4. Pisang otomatis terbang menyerang target berapapun jauhnya 🍌💀",
})

-- SETTINGS TAB
SetTab:CreateSection("Kecepatan")

SetTab:CreateSlider({
    Name         = "Speed Pisang",
    Range        = {100, 3000 },
    Increment    = 100,
    Suffix       = " speed",
    CurrentValue = 900,
    Flag         = "BananaSpeed",
    Callback     = function(v)
        Config.Speed = v
        Rayfield:Notify({ Title="Speed: "..v, Duration=1 })
    end,
})

SetTab:CreateParagraph({
    Title   = "Panduan Speed",
    Content = "300   = pelan\n500   = sedang\n800   = default\n1200 = kencang\n3000 = MAXIMUM 💀",
})

-- Auto refresh
Players.PlayerAdded:Connect(function() task.wait(0.5) RefreshDrop("") end)
Players.PlayerRemoving:Connect(function(plr)
    if targetPlayer == plr then
        targetPlayer = nil
        StopChase()
        Rayfield:Notify({ Title="Target Keluar", Content=plr.Name.." keluar.", Duration=3 })
    end
    task.wait(0.5) RefreshDrop("")
end)

Rayfield:Notify({
    Title   = "Hutan Pisang",
    Content = "By Notceenn | Siap! (Brutal Attack Mode)",
    Duration = 3,
})
