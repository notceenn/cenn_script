-- ================================================
--   🍌 Banana Peel - Hutan @cenntzy (V1)
--   Custom GUI "CENN HUB!" style
-- ================================================

local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local LocalPlayer  = Players.LocalPlayer

-- ================================================
-- 🔑 Ambil Key dari key.txt di GitHub
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

-- ================================================
-- 🔑 KEY GATE (layar terpisah, muncul PALING AWAL)
-- ================================================

local function ShowKeyGate(onSuccess)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BananaPeelKeyGate"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 999

    local parented = pcall(function()
        ScreenGui.Parent = game:GetService("CoreGui")
    end)
    if not parented or not ScreenGui.Parent then
        pcall(function()
            ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        end)
    end

    local Overlay = Instance.new("Frame")
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    Overlay.BackgroundTransparency = 0.4
    Overlay.BorderSizePixel = 0
    Overlay.Parent = ScreenGui

    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(0, 380, 0, 250)
    Card.Position = UDim2.new(0.5, -190, 0.5, -125)
    Card.BackgroundColor3 = Color3.fromRGB(10, 28, 32)
    Card.BorderSizePixel = 0
    Card.Parent = ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = Card

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(40, 220, 235)
    stroke.Thickness = 1.5
    stroke.Parent = Card

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -40, 0, 24)
    Title.Position = UDim2.new(0, 20, 0, 18)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Text = "Banana Peel - Hutan @cenntzy"
    Title.Parent = Card

    local Sub = Instance.new("TextLabel")
    Sub.Size = UDim2.new(1, -40, 0, 42)
    Sub.Position = UDim2.new(0, 20, 0, 44)
    Sub.BackgroundTransparency = 1
    Sub.Font = Enum.Font.Gotham
    Sub.TextSize = 13
    Sub.TextColor3 = Color3.fromRGB(180, 180, 190)
    Sub.TextXAlignment = Enum.TextXAlignment.Left
    Sub.TextWrapped = true
    Sub.Text = "Masukkan key untuk membuka script. Key WAJIB dimasukkan setiap kali script dijalankan. Minta key ke @cenntzy."
    Sub.Parent = Card

    local InputHolder = Instance.new("Frame")
    InputHolder.Size = UDim2.new(1, -40, 0, 42)
    InputHolder.Position = UDim2.new(0, 20, 0, 96)
    InputHolder.BackgroundColor3 = Color3.fromRGB(14, 40, 46)
    InputHolder.BorderSizePixel = 0
    InputHolder.Parent = Card

    local ihCorner = Instance.new("UICorner")
    ihCorner.CornerRadius = UDim.new(0, 8)
    ihCorner.Parent = InputHolder

    local ihStroke = Instance.new("UIStroke")
    ihStroke.Color = Color3.fromRGB(30, 90, 100)
    ihStroke.Thickness = 1.5
    ihStroke.Parent = InputHolder

    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(1, -24, 1, 0)
    KeyBox.Position = UDim2.new(0, 12, 0, 0)
    KeyBox.BackgroundTransparency = 1
    KeyBox.PlaceholderText = "Ketik key di sini lalu Enter..."
    KeyBox.Text = ""
    KeyBox.Font = Enum.Font.Gotham
    KeyBox.TextSize = 14
    KeyBox.TextColor3 = Color3.new(1, 1, 1)
    KeyBox.TextXAlignment = Enum.TextXAlignment.Left
    KeyBox.ClearTextOnFocus = false
    KeyBox.Parent = InputHolder

    KeyBox.Focused:Connect(function()
        ihStroke.Color = Color3.fromRGB(60, 220, 235)
    end)
    KeyBox.FocusLost:Connect(function()
        ihStroke.Color = Color3.fromRGB(30, 90, 100)
    end)

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1, -40, 0, 20)
    Status.Position = UDim2.new(0, 20, 0, 144)
    Status.BackgroundTransparency = 1
    Status.Font = Enum.Font.GothamBold
    Status.TextSize = 13
    Status.TextXAlignment = Enum.TextXAlignment.Left
    Status.TextColor3 = Color3.fromRGB(255, 90, 90)
    Status.Text = ""
    Status.Parent = Card

    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Size = UDim2.new(1, -40, 0, 40)
    SubmitBtn.Position = UDim2.new(0, 20, 0, 172)
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(30, 190, 210)
    SubmitBtn.Text = "MASUK"
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.TextSize = 15
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.AutoButtonColor = false
    SubmitBtn.Parent = Card

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = SubmitBtn

    local processing = false

    local function ShakeCard()
        local seq = {6, -6, 4, -4, 2, 0}
        for _, off in ipairs(seq) do
            Card.Position = UDim2.new(0.5, -190 + off, 0.5, -125)
            task.wait(0.04)
        end
    end

    local function TryVerify()
        if processing then return end
        local input = KeyBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
        if input == "" then
            Status.Text = "⚠️ Key tidak boleh kosong!"
            Status.TextColor3 = Color3.fromRGB(255, 180, 60)
            return
        end

        processing = true
        Status.Text = "⏳ Memverifikasi..."
        Status.TextColor3 = Color3.fromRGB(180, 180, 190)

        local validKey = GetRemoteKey()

        if not validKey then
            Status.Text = "⚠️ Gagal mengambil data key. Cek koneksi!"
            Status.TextColor3 = Color3.fromRGB(255, 150, 60)
            processing = false
            return
        end

        if input == validKey then
            Status.Text = "✅ Key Benar! Masuk..."
            Status.TextColor3 = Color3.fromRGB(90, 255, 130)
            stroke.Color = Color3.fromRGB(90, 255, 130)
            task.wait(0.6)
            pcall(function() ScreenGui:Destroy() end)
            onSuccess()
        else
            Status.Text = "❌ Key salah tolol! Coba lagi."
            Status.TextColor3 = Color3.fromRGB(255, 90, 90)
            stroke.Color = Color3.fromRGB(255, 70, 70)
            ShakeCard()
            task.wait(0.4)
            stroke.Color = Color3.fromRGB(40, 220, 235)
            processing = false
        end
    end

    SubmitBtn.MouseButton1Click:Connect(TryVerify)
    KeyBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then TryVerify() end
    end)
end

-- ================================================
-- 🍌 SCRIPT UTAMA (baru jalan setelah key benar)
-- ================================================

local function MainScript()

    local Config = {
        BlastPower = 2000000, -- dikuatin jadi 2 juta
        TargetPart = "HumanoidRootPart",
    }
    local targetPlayer  = nil
    local active        = false
    local wantsActive   = false
    local conn          = nil
    local myBananas     = {}
    local lastThrowTime = 0

    -- ================================================
    -- UTILITY
    -- ================================================

    local function AutoSelect(input)
        if #input < 2 then return nil end
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

    pcall(function()
        workspace.ChildAdded:Connect(function(obj)
            pcall(ClaimIfMine, obj)
            task.delay(0.1, function() pcall(ClaimIfMine, obj) end)
            task.delay(0.2, function() pcall(ClaimIfMine, obj) end)
        end)
    end)

    pcall(function()
        workspace.DescendantAdded:Connect(function(obj)
            pcall(ClaimIfMine, obj)
        end)
    end)

    for _, obj in ipairs(workspace:GetChildren()) do
        pcall(ClaimIfMine, obj)
    end

    local function FindBananas()
        local list = {}
        for obj, _ in pairs(myBananas) do
            if obj and obj.Parent and obj:IsA("BasePart") then
                if not (LocalPlayer.Character and obj:IsDescendantOf(LocalPlayer.Character)) then
                    table.insert(list, obj)
                end
            else
                myBananas[obj] = nil
            end
        end
        return list
    end

    -- ================================================
    -- VISUAL: Highlight + Nickname + Jarak
    -- ================================================

    local victimHighlight   = nil
    local victimBillboard   = nil
    local currentVisualFor  = nil

    local function ClearVictimVisuals()
        pcall(function() if victimHighlight then victimHighlight:Destroy() end end)
        pcall(function() if victimBillboard then victimBillboard:Destroy() end end)
        victimHighlight, victimBillboard, currentVisualFor = nil, nil, nil
    end

    local function SetupVictimVisuals(plr)
        ClearVictimVisuals()
        if not plr or not plr.Character then return end
        local char = plr.Character
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        currentVisualFor = plr

        victimHighlight = Instance.new("Highlight")
        victimHighlight.FillColor = Color3.fromRGB(40, 120, 255)
        victimHighlight.OutlineColor = Color3.fromRGB(60, 140, 255)
        victimHighlight.FillTransparency = 0.75
        victimHighlight.OutlineTransparency = 0.15
        victimHighlight.Parent = char

        victimBillboard = Instance.new("BillboardGui")
        victimBillboard.Name = "BananaDistanceGui"
        victimBillboard.Size = UDim2.new(0, 130, 0, 34)
        -- Digeser lebih tinggi dari Name ESP (StudsOffset 2.5) supaya gak
        -- numpuk/nutupin -- "TARGET LOCKED" nongol DI ATAS Name ESP
        victimBillboard.StudsOffset = Vector3.new(0, 4.6, 0)
        victimBillboard.AlwaysOnTop = true
        victimBillboard.Parent = char:FindFirstChild("Head") or root

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "NameLabel"
        nameLabel.Size = UDim2.new(1, 0, 0, 12)
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 13
        nameLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
        nameLabel.TextStrokeTransparency = 0
        nameLabel.Text = "🎯 TARGET LOCKED"
        nameLabel.Parent = victimBillboard

        local label = Instance.new("TextLabel")
        label.Name = "DistanceLabel"
        label.Size = UDim2.new(1, 0, 0, 12)
        label.Position = UDim2.new(0, 0, 0, 14)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.TextSize = 10
        label.TextColor3 = Color3.fromRGB(255, 255, 0)
        label.TextStrokeTransparency = 0
        label.Text = "Jarak Korban: 0 studs"
        label.Parent = victimBillboard
    end

    local function UpdateVictimVisuals(forTarget)
        if not forTarget or not forTarget.Character then return end

        if currentVisualFor ~= forTarget then
            SetupVictimVisuals(forTarget)
            return
        end

        local root = forTarget.Character:FindFirstChild("HumanoidRootPart")
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root or not myRoot then return end

        if not victimBillboard or not victimBillboard.Parent then
            SetupVictimVisuals(forTarget)
            return
        end

        local dist = (root.Position - myRoot.Position).Magnitude
        local label = victimBillboard:FindFirstChild("DistanceLabel")
        if label then
            label.Text = string.format("Jarak Korban: %.1f studs", dist)
        end
    end

    -- ================================================
    -- 👁️ SPECTATE (persisten sampai user OFF-in manual)
    -- ================================================

    local isSpectating = false

    local function EnforceSpectate()
        if not isSpectating or not targetPlayer or not targetPlayer.Character then return end
        local hum = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
        local cam = workspace.CurrentCamera
        if hum and cam then
            pcall(function()
                if cam.CameraSubject ~= hum then
                    cam.CameraSubject = hum
                end
                cam.CameraType = Enum.CameraType.Custom
            end)
        end
    end

    local function StopViewTarget()
        local cam = workspace.CurrentCamera
        local myChar = LocalPlayer.Character
        local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
        pcall(function()
            if cam then
                cam.CameraType = Enum.CameraType.Custom
                if myHum then cam.CameraSubject = myHum end
            end
        end)
        isSpectating = false
    end

    -- Heartbeat kecil: SELALU jaga kamera tetap ke target selama isSpectating
    -- true, jadi walau target respawn/!re/pindah karakter, kamera GAK bakal
    -- balik ke kamu sendiri sampai kamu OFF-in manual dari tombol
    -- (digabung sama loop Anti-Fling di bawah jadi 1 Heartbeat aja, biar
    -- gak ada koneksi event yang numpuk-numpuk -- lebih ringan/smooth)

    -- ================================================
    -- 📡 AUTO RE-ATTACH ESP + SPECTATE saat korban respawn
    -- ================================================

    local targetCharConn = nil

    local function HookTargetCharacterAdded(plr)
        if targetCharConn then
            pcall(function() targetCharConn:Disconnect() end)
            targetCharConn = nil
        end
        if not plr then return end
        targetCharConn = plr.CharacterAdded:Connect(function(newChar)
            task.spawn(function()
                local root = newChar:WaitForChild("HumanoidRootPart", 5)
                if root and targetPlayer == plr and active then
                    SetupVictimVisuals(plr)
                end
                if root and targetPlayer == plr and isSpectating then
                    local hum = newChar:WaitForChild("Humanoid", 5)
                    local cam = workspace.CurrentCamera
                    if hum and cam then
                        pcall(function()
                            cam.CameraSubject = hum
                            cam.CameraType = Enum.CameraType.Custom
                        end)
                    end
                end
            end)
        end)
    end

    -- ================================================
    -- 🔥 GLOBAL ATTACK
    -- ================================================

    local victimMovers = {}

    local function GetOrCreateMovers(targetRoot)
        local movers = victimMovers[targetRoot]
        if movers and movers.bv and movers.bv.Parent and movers.bav and movers.bav.Parent then
            return movers
        end

        for _, child in ipairs(targetRoot:GetChildren()) do
            if child:IsA("BodyMover") then
                pcall(function() child:Destroy() end)
            end
        end

        pcall(function()
            targetRoot:SetNetworkOwner(LocalPlayer)
        end)

        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = targetRoot

        local bav = Instance.new("BodyAngularVelocity")
        bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bav.AngularVelocity = Vector3.new(0, 0, 0)
        bav.Parent = targetRoot

        movers = { bv = bv, bav = bav }
        victimMovers[targetRoot] = movers
        return movers
    end

    local function ClearAllMovers()
        for _, movers in pairs(victimMovers) do
            pcall(function() if movers.bv then movers.bv:Destroy() end end)
            pcall(function() if movers.bav then movers.bav:Destroy() end end)
        end
        victimMovers = {}
    end

    local StartChase, StopChase

    local function TryAutoStart()
        if wantsActive and not active and targetPlayer then
            StartChase()
        end
    end

    StartChase = function()
        if conn then conn:Disconnect() end
        if not targetPlayer or targetPlayer == LocalPlayer then return end

        active = true
        ClearAllMovers()
        SetupVictimVisuals(targetPlayer)

        conn = RunService.Heartbeat:Connect(function(dt)
            if not active then return end
            if not targetPlayer or not targetPlayer.Character or targetPlayer == LocalPlayer then return end

            UpdateVictimVisuals(targetPlayer)

            local character = targetPlayer.Character
            local targetRoot = character:FindFirstChild("HumanoidRootPart")
            local humanoid   = character:FindFirstChildOfClass("Humanoid")
            if not targetRoot then return end

            local targetPart = character:FindFirstChild(Config.TargetPart)
            if not targetPart or not targetPart:IsA("BasePart") then
                targetPart = targetRoot
            end

            -- Pastikan HumanoidRootPart gak ke-anchor & network owner tetap
            -- di kita tiap frame -- beberapa avatar kadang "diam gak mental"
            -- karena ownership fisikanya kerebut balik atau part-nya sempat
            -- ke-anchor oleh sistem lain
            pcall(function()
                if targetRoot.Anchored then targetRoot.Anchored = false end
                targetRoot:SetNetworkOwner(LocalPlayer)
            end)

            local isInSeat = humanoid and humanoid.SeatPart ~= nil

            -- Selama korban lagi duduk, push memang di-skip (biar gak
            -- melayang) -- tapi biar gak nunggu lama sampai dia gerak
            -- sendiri buat keluar dari kursi, kita pancing keluar pakai
            -- humanoid.Jump = true. Ini cara RESMI bawaan Roblox buat
            -- keluar dari seat (sama kayak pencet Space pas duduk), jadi
            -- mulus & gak glitch/ngambang seperti cara paksa (destroy weld
            -- dll) yang sempat dicoba sebelumnya.
            if isInSeat and humanoid then
                pcall(function() humanoid.Jump = true end)
            end

            -- 📸 Baca kecepatan ASLI korban DULU, SEBELUM kita nimpa
            -- velocity-nya sendiri buat dorongan. Kalau dibaca SETELAH
            -- dorongan diterapkan, yang kebaca itu velocity dorongan KITA
            -- sendiri (bukan gerakan asli korban) -- itu yang bikin sistem
            -- selalu ngira korban "lagi loncat" terus, gak bisa bedain
            -- diam/jalan/loncat yang sebenarnya.
            local vel = targetPart.AssemblyLinearVelocity
            local horizVel = Vector3.new(vel.X, 0, vel.Z)
            local horizSpeed = horizVel.Magnitude
            local isJumping = vel.Y > 2
            local isSitting = humanoid and (humanoid.Sit or humanoid.SeatPart ~= nil)

            local predictedPos = targetPart.Position

            if isSitting then
                -- Pas duduk, HumanoidRootPart posisinya suka "ketarik" ke
                -- atas relatif ke visual badan yang lagi nekuk -- turunin
                -- dikit biar pisang tetap di perut, bukan nongol di kepala
                predictedPos = predictedPos + Vector3.new(0, -1.5, 0)
            elseif horizSpeed > 0.5 then
                -- Horizontal (jalan/lari): offset TETAP 0.2 studs di depan
                -- arah gerak -- BUKAN dikali kecepatan/waktu, jadi jaraknya
                -- konsisten buat SEMUA jenis avatar & rig (R6, R15, custom)
                -- walau WalkSpeed-nya beda-beda.
                predictedPos = predictedPos + horizVel.Unit * 0.2
            end

            -- Loncat (termasuk spam loncat cepat): SENGAJA gak ditebak lagi.
            -- targetPart.Position di atas itu udah posisi ASLI real-time
            -- korban SAAT INI (bukan delay), dan loop ini jalan 60x/detik --
            -- jadi gak perlu nebak "0.15 detik ke depan" segala. Nebak
            -- malah bikin meleset pas korban spam loncat cepat (kadang
            -- ketinggian/kerendahan dari badan aslinya), itu makanya dia
            -- kadang bisa lolos. Sekarang tinggal ikutin badan asli tiap
            -- frame -- gak mungkin ke-dodge lagi semenceng apapun dia loncat.

            local EXTREME = Vector3.new(500000, 500000, 500000)
            local upBlast = Vector3.new(0, Config.BlastPower, 0)

            local movers = GetOrCreateMovers(targetRoot)

            -- Kalau lagi duduk di Seat/VehicleSeat BENERAN (gerobak, ayunan,
            -- dll), JANGAN paksa PlatformStand/lock -- itu bentrok sama weld
            -- bawaan seat-nya dan bikin badan keliatan "melayang"/glitch.
            -- Cukup dilewatin, gak diapa-apain fisiknya.
            if humanoid and not isInSeat then
                pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Physics) end)
                humanoid.PlatformStand = true
                humanoid.Sit = false
                humanoid.WalkSpeed = 0
                humanoid.JumpPower = 0
                pcall(function() humanoid:Move(Vector3.new(0, 0, 0), false) end)
            end

            -- 💪 DORONGAN SELALU DITERAPKAN tiap frame selama masih nge-chase,
            -- TIDAK digantung sama ada/gaknya banana yang lagi ke-track lagi.
            -- Sebelumnya kode dorongan ada DI DALAM loop "for banana in
            -- FindBananas()" -- jadi kalau tracking banana-nya sempat kosong
            -- (misal abis hilang/belum ke-klaim ulang), padahal pisangnya
            -- masih keliatan nempel (posisi terakhir), dorongannya BERHENTI
            -- total meski pisang masih nongol. Sekarang dorongan dipisah,
            -- selalu jalan extreme kuat gak peduli status tracking banana.
            -- (Kecuali kalau lagi di Seat beneran -- lihat komentar di atas)
            if not isInSeat then
                local rigVelocity = targetRoot.AssemblyLinearVelocity
                local rigAngular  = targetRoot.AssemblyAngularVelocity

                targetRoot.AssemblyLinearVelocity  = Vector3.new(0, rigVelocity.Y + upBlast.Y, 0)
                targetRoot.AssemblyAngularVelocity = EXTREME

                movers.bv.Velocity = Vector3.new(0, upBlast.Y, 0)
                movers.bav.AngularVelocity = EXTREME

                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part ~= targetRoot then
                        part.AssemblyLinearVelocity  = Vector3.new(0, upBlast.Y, 0)
                        part.AssemblyAngularVelocity = EXTREME
                    end
                end
            end

            -- (predictedPos sudah dihitung DI ATAS, SEBELUM dorongan
            -- diterapkan -- jangan hitung ulang di sini, karena kalau
            -- dihitung ulang sekarang, targetPart.AssemblyLinearVelocity
            -- yang kebaca itu velocity DORONGAN KITA sendiri yang udah
            -- jutaan, bukan gerakan asli korban -- itu yang bikin pisang
            -- terbang entah ke mana tadi)

            for _, banana in ipairs(FindBananas()) do
                if not banana or not banana.Parent then continue end

                pcall(function()
                    banana.CFrame = CFrame.new(predictedPos)
                end)
                banana.Anchored = false
                banana.CanCollide = false
                banana.AssemblyLinearVelocity  = EXTREME
                banana.AssemblyAngularVelocity = EXTREME
            end
        end)
    end

    StopChase = function()
        active = false
        if conn then conn:Disconnect() conn = nil end
        ClearVictimVisuals()
        ClearAllMovers()
    end

    -- ================================================
    -- LEMPAR & CHAT COMMAND
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

    -- !RE = kirim "!re" ke chat all (buat respawn/reset cooldown)
    local function SendReChat()
        pcall(function()
            local char = LocalPlayer.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            game:GetService("Chat"):Chat(humanoid, "!re", Enum.ChatColor.Green)
        end)
        pcall(function()
            game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("!re")
        end)
    end

    -- ================================================
    -- 🛡️ PERLINDUNGAN: Anti-Fling, Anti-Ragdoll, Anti-Sit
    -- Mesin proteksi LENGKAP (sebelumnya cuma nge-set flag doang tanpa
    -- ada yang beneran nge-enforce -- makanya Anti-Sit & Anti-Ragdoll
    -- gak jalan sama sekali)
    -- ================================================

    local Protection = {
        AntiFling   = false,
        AntiRagdoll = false,
        AntiSit     = false,
    }

    local DANGEROUS_CLASSES = {
        BodyVelocity = true,
        BodyAngularVelocity = true,
        BodyForce = true,
        BodyThrust = true,
        BodyPosition = true,
        BodyGyro = true,
        LinearVelocity = true,
        AngularVelocity = true,
        VectorForce = true,
        AlignPosition = true,
        AlignOrientation = true,
        Torque = true,
    }

    local function HookProtection(char)
        local humanoid = char:WaitForChild("Humanoid", 5)
        local root = char:WaitForChild("HumanoidRootPart", 5)
        if not humanoid or not root then return end

        pcall(function()
            humanoid.StateChanged:Connect(function(_, new)
                if Protection.AntiRagdoll and new == Enum.HumanoidStateType.Ragdoll then
                    pcall(function()
                        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end)
                end
            end)
        end)

        -- Anti-Ragdoll lapis 2: banyak sistem ragdoll gak cuma ganti State,
        -- tapi juga maksa PlatformStand=true. Kita pantau terus & langsung
        -- balikin false kalau itu kejadian tanpa kita minta sendiri.
        pcall(function()
            humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(function()
                if Protection.AntiRagdoll and humanoid.PlatformStand then
                    pcall(function() humanoid.PlatformStand = false end)
                end
            end)
        end)

        pcall(function()
            humanoid:GetPropertyChangedSignal("Sit"):Connect(function()
                if Protection.AntiSit and humanoid.Sit then
                    pcall(function()
                        humanoid.Sit = false
                        humanoid.Jump = true
                    end)
                end
            end)
        end)

        local function DestroyIfDangerous(child)
            if not Protection.AntiFling then return end
            local ok, className = pcall(function() return child.ClassName end)
            if ok and DANGEROUS_CLASSES[className] then
                task.defer(function()
                    pcall(function() child:Destroy() end)
                end)
            end
        end

        pcall(function()
            root.ChildAdded:Connect(DestroyIfDangerous)
        end)
        pcall(function()
            char.DescendantAdded:Connect(DestroyIfDangerous)
        end)
        for _, child in ipairs(char:GetDescendants()) do
            DestroyIfDangerous(child)
        end
    end

    pcall(function()
        if LocalPlayer.Character then
            HookProtection(LocalPlayer.Character)
        end
        LocalPlayer.CharacterAdded:Connect(function(char)
            task.wait(0.2)
            HookProtection(char)
        end)
    end)

    -- Lapis tambahan Anti-Fling: clamp velocity abnormal + revert teleport
    -- (loop ini juga sekalian nge-handle EnforceSpectate, digabung jadi 1
    -- Heartbeat connection biar lebih ringan/smooth)
    -- Ambang batas DITURUNIN biar responsnya jauh lebih cepat/sensitif
    -- nangkep fling, gak nunggu sampe kelewat jauh dulu baru react.
    pcall(function()
        local lastSafePos = nil
        local lastCheckTime = tick()

        RunService.Heartbeat:Connect(function()
            pcall(EnforceSpectate)

            if not Protection.AntiFling then
                lastSafePos = nil
                return
            end
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return end

            local now = tick()
            local dt = math.max(now - lastCheckTime, 1/240)
            lastCheckTime = now

            -- Sweep berkala ke SEMUA part karakter (bukan cuma root),
            -- jaga-jaga ada Constraint asing yang nempel di tangan/kaki/dll
            -- yang gak ke-detect lewat event ChildAdded
            pcall(function()
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        for _, mover in ipairs(part:GetChildren()) do
                            local ok, className = pcall(function() return mover.ClassName end)
                            if ok and DANGEROUS_CLASSES[className] then
                                pcall(function() mover:Destroy() end)
                            end
                        end
                    end
                end
            end)

            local vel = root.AssemblyLinearVelocity
            if vel.Magnitude > 120 then
                root.AssemblyLinearVelocity = Vector3.new(0, math.clamp(vel.Y, -50, 50), 0)
            end

            local avel = root.AssemblyAngularVelocity
            if avel.Magnitude > 15 then
                root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end

            if lastSafePos then
                local delta = (root.Position - lastSafePos).Magnitude
                local maxPlausible = 150 * dt
                if delta > maxPlausible and delta > 6 then
                    pcall(function()
                        root.CFrame = CFrame.new(lastSafePos)
                        root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    end)
                else
                    lastSafePos = root.Position
                end
            else
                lastSafePos = root.Position
            end
        end)
    end)

    -- ================================================
    -- 🕊️ FLY (gaya Infinite Yield: BodyVelocity + BodyGyro,
    -- update pakai RenderStepped biar mulus, speed 100)
    -- ================================================

    local UIS_Fly = game:GetService("UserInputService")
    local FLY_SPEED = 100
    local flyBV, flyGyro, flyConn = nil, nil, nil

    local function StopFly()
        if flyConn then pcall(function() flyConn:Disconnect() end) flyConn = nil end
        if flyBV then pcall(function() flyBV:Destroy() end) flyBV = nil end
        if flyGyro then pcall(function() flyGyro:Destroy() end) flyGyro = nil end
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum.PlatformStand = false end) end
    end

    local function StartFly()
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end

        StopFly()

        pcall(function() hum.PlatformStand = true end)

        flyBV = Instance.new("BodyVelocity")
        flyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        flyBV.Velocity = Vector3.new(0, 0, 0)
        flyBV.Parent = root

        -- BodyGyro: badan otomatis ngarah ke arah kamera, ini yang bikin
        -- fly-nya kerasa "smooth" kayak IY (bukan cuma geser doang, tapi
        -- orientasinya juga ikut ngikutin arah liat kita)
        flyGyro = Instance.new("BodyGyro")
        flyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        flyGyro.P = 3000
        flyGyro.CFrame = root.CFrame
        flyGyro.Parent = root

        flyConn = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            if not cam or not flyBV or not flyBV.Parent then return end

            local moveDir = Vector3.new(0, 0, 0)
            local camCF = cam.CFrame

            if UIS_Fly:IsKeyDown(Enum.KeyCode.W) then moveDir += camCF.LookVector end
            if UIS_Fly:IsKeyDown(Enum.KeyCode.S) then moveDir -= camCF.LookVector end
            if UIS_Fly:IsKeyDown(Enum.KeyCode.A) then moveDir -= camCF.RightVector end
            if UIS_Fly:IsKeyDown(Enum.KeyCode.D) then moveDir += camCF.RightVector end
            if UIS_Fly:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
            if UIS_Fly:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir -= Vector3.new(0, 1, 0) end

            if moveDir.Magnitude > 0 then
                flyBV.Velocity = moveDir.Unit * FLY_SPEED
            else
                flyBV.Velocity = Vector3.new(0, 0, 0)
            end

            if flyGyro then
                flyGyro.CFrame = camCF
            end
        end)
    end

    pcall(function()
        LocalPlayer.CharacterAdded:Connect(function()
            flyBV, flyGyro, flyConn = nil, nil, nil
        end)
    end)

    -- ================================================
    -- CUSTOM GUI (CENN HUB! style)
    -- ================================================

    local UIS = game:GetService("UserInputService")

    local CLR_BG      = Color3.fromRGB(6, 22, 26)
    local CLR_PANEL   = Color3.fromRGB(10, 34, 40)
    local CLR_BORDER  = Color3.fromRGB(40, 220, 235)
    local CLR_ON      = Color3.fromRGB(20, 160, 180)
    local CLR_OFF     = Color3.fromRGB(12, 40, 46)
    local CLR_RED     = Color3.fromRGB(170, 25, 25)
    local CLR_TXT     = Color3.fromRGB(255, 255, 255)
    local CLR_TITLE   = Color3.fromRGB(160, 245, 250)
    local CLR_INPBG   = Color3.fromRGB(6, 18, 22)

    local gui = Instance.new("ScreenGui")
    gui.Name            = "S3GSHub"
    gui.ResetOnSpawn    = false
    gui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder    = 10
    pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not gui.Parent then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local PW, PH = 236, 260
    local PX, PY_START = 6, 32
    local BH, BH2, GAP = 22, 20, 4
    local FULL = PW - PX*2
    local HALF = math.floor(FULL/2) - 2

    local minBtn = Instance.new("TextButton")
    minBtn.Size               = UDim2.new(0, 58, 0, 44)
    minBtn.Position           = UDim2.new(0, 8, 0.55, 0)
    minBtn.BackgroundColor3   = CLR_PANEL
    minBtn.BorderSizePixel    = 0
    minBtn.Text               = "CENN\nHUB!"
    minBtn.Font               = Enum.Font.GothamBold
    minBtn.TextSize           = 11
    minBtn.TextColor3         = Color3.fromRGB(255,255,255)
    minBtn.AutoButtonColor    = false
    minBtn.Visible            = false
    minBtn.Parent             = gui
    Instance.new("UICorner",  minBtn).CornerRadius = UDim.new(0,7)
    local ms = Instance.new("UIStroke", minBtn); ms.Color = Color3.fromRGB(140, 60, 255); ms.Thickness = 1.5
    minBtn.TextStrokeColor3       = Color3.fromRGB(140, 60, 255)
    minBtn.TextStrokeTransparency = 0.4

    local panel = Instance.new("Frame")
    panel.Size              = UDim2.new(0, PW, 0, PH)
    panel.Position          = UDim2.new(0, 8, 0.5, -130)
    panel.BackgroundColor3  = CLR_PANEL
    panel.BorderSizePixel   = 0
    panel.Parent            = gui
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 8)
    local ps = Instance.new("UIStroke", panel); ps.Color = CLR_BORDER; ps.Thickness = 1.5

    local tbar = Instance.new("Frame")
    tbar.Size             = UDim2.new(1,0,0,28)
    tbar.BackgroundColor3 = CLR_BG
    tbar.BorderSizePixel  = 0
    tbar.Parent           = panel
    Instance.new("UICorner", tbar).CornerRadius = UDim.new(0,8)
    local tbfix = Instance.new("Frame", tbar)
    tbfix.Size = UDim2.new(1,0,0,8); tbfix.Position = UDim2.new(0,0,1,-8)
    tbfix.BackgroundColor3 = CLR_BG; tbfix.BorderSizePixel = 0

    local titl = Instance.new("TextLabel", tbar)
    titl.Size = UDim2.new(1,-36,1,0); titl.Position = UDim2.new(0,8,0,0)
    titl.BackgroundTransparency = 1; titl.Font = Enum.Font.GothamBold
    titl.TextSize = 12; titl.TextColor3 = CLR_TITLE
    titl.TextXAlignment = Enum.TextXAlignment.Left
    titl.Text = "CENN HUB! - Banana Peel"

    local xBtn = Instance.new("TextButton", tbar)
    xBtn.Size = UDim2.new(0,24,0,20); xBtn.Position = UDim2.new(1,-28,0,4)
    xBtn.BackgroundColor3 = CLR_RED; xBtn.BorderSizePixel = 0
    xBtn.Text = "×"; xBtn.Font = Enum.Font.GothamBold
    xBtn.TextSize = 14; xBtn.TextColor3 = CLR_TXT; xBtn.AutoButtonColor = false
    Instance.new("UICorner", xBtn).CornerRadius = UDim.new(0,4)

    local drag, ds, sp = false, nil, nil
    tbar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            drag=true; ds=i.Position; sp=panel.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local d=i.Position-ds
            panel.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end
    end)

    xBtn.MouseButton1Click:Connect(function() panel.Visible=false; minBtn.Visible=true end)
    minBtn.MouseButton1Click:Connect(function() panel.Visible=true; minBtn.Visible=false end)

    local function Btn(txt,x,y,w,h,clr)
        local b=Instance.new("TextButton",panel)
        b.Size=UDim2.new(0,w,0,h); b.Position=UDim2.new(0,x,0,y)
        b.BackgroundColor3=clr or CLR_OFF; b.BorderSizePixel=0
        b.Text=txt; b.Font=Enum.Font.GothamBold; b.TextSize=10
        b.TextColor3=CLR_TXT; b.AutoButtonColor=false
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,5)
        return b
    end

    local function ToggleBtn(offLbl,onLbl,x,y,w,h,cb)
        local s=false
        local b=Btn(offLbl,x,y,w,h,CLR_OFF)
        local setter
        setter = function(v)
            s=v
            b.BackgroundColor3=v and CLR_ON or CLR_OFF
            b.Text=v and onLbl or offLbl
        end
        b.MouseButton1Click:Connect(function()
            s=not s
            b.BackgroundColor3=s and CLR_ON or CLR_OFF
            b.Text=s and onLbl or offLbl
            if cb then cb(s, setter) end
        end)
        return b, setter
    end

    -- Layout baru: RESET & BYPASS REFRESH dihapus -> tinggal !RE | BANANA
    -- di baris ke-2, langsung disusul grid toggle (lebih rapi & ringkas)
    local Y1 = PY_START                    -- search box
    local Y2 = Y1 + BH + GAP               -- !RE | BANANA
    local Y3 = Y2 + BH2 + GAP              -- grid start

    local inputBox = Instance.new("TextBox", panel)
    inputBox.Size=UDim2.new(0,FULL,0,BH); inputBox.Position=UDim2.new(0,PX,0,Y1)
    inputBox.BackgroundColor3=CLR_INPBG; inputBox.BorderSizePixel=0
    inputBox.PlaceholderText="Username/Nickname"; inputBox.PlaceholderColor3=Color3.fromRGB(255,255,255)
    inputBox.Text=""; inputBox.Font=Enum.Font.Gotham; inputBox.TextSize=11
    inputBox.TextColor3=CLR_TXT; inputBox.TextXAlignment=Enum.TextXAlignment.Center
    inputBox.ClearTextOnFocus=false
    Instance.new("UICorner",inputBox).CornerRadius=UDim.new(0,5)
    local ibs=Instance.new("UIStroke",inputBox); ibs.Color=CLR_BORDER; ibs.Thickness=1

    -- ROW 2: !RE | BANANA (2 tombol rapi, HALF width masing2)
    local ireBtn     = Btn("!RE",    PX,          Y2, HALF, BH2, CLR_OFF)
    local bananaBtn  = Btn("BANANA: OFF", PX+HALF+4, Y2, HALF, BH2, CLR_OFF)

    -- Grid 2 kolom
    local nameEspBillboards = {}
    local nameEspEnabled    = false

    local function ClearNameESP()
        for _,b in pairs(nameEspBillboards) do pcall(function() b:Destroy() end) end
        nameEspBillboards={}
    end

    local function AddNameESPFor(plr)
        if not nameEspEnabled or not plr.Character then return end
        local head=plr.Character:FindFirstChild("Head"); if not head then return end
        if nameEspBillboards[plr] and nameEspBillboards[plr].Parent then return end
        local bb=Instance.new("BillboardGui",head)
        bb.Name="NameESP_S3GS"; bb.Size=UDim2.new(0,140,0,32)
        bb.StudsOffset=Vector3.new(0,2.5,0); bb.AlwaysOnTop=true
        local lbl=Instance.new("TextLabel",bb)
        lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1
        lbl.Font=Enum.Font.GothamBold; lbl.TextSize=10
        lbl.TextColor3=Color3.fromRGB(255,255,255); lbl.TextStrokeTransparency=0
        lbl.Text=plr.DisplayName.."\n(@"..plr.Name..")"
        nameEspBillboards[plr]=bb
    end

    local function BuildNameESP()
        ClearNameESP()
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr~=LocalPlayer then AddNameESPFor(plr) end
        end
    end

    -- ================================================
    -- 🐟 COIN HACK (Hutan Fishing) - sub-menu toggle
    -- ================================================

    local coinHackSetterRef = nil
    local fishingGui = nil

    local function DestroyFishingMenu()
        if fishingGui then
            pcall(function() fishingGui:Destroy() end)
            fishingGui = nil
        end
    end

    local function BuildFishingMenu()
        DestroyFishingMenu()

        local SellerCFrame = CFrame.new(-83.2018051, 33.3287544, -1031.65247, -0.0907148197, 3.74077835e-08, 0.995876908, 2.16429674e-09, 1, -3.73655098e-08, -0.995876908, -1.23423238e-09, -0.0907148197)

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "CennHubFishingGUI"
        screenGui.ResetOnSpawn = false
        pcall(function() screenGui.Parent = game:GetService("CoreGui") end)
        if not screenGui.Parent then screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
        fishingGui = screenGui

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

        local content = Instance.new("Frame")
        content.Name = "Content"
        content.Size = UDim2.new(1, -20, 1, -50)
        content.Position = UDim2.new(0, 10, 0, 44)
        content.BackgroundTransparency = 1
        content.Parent = mainFrame

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

        local function updateStatus(text)
            statusLabel.Text = "Status: " .. text
        end

        local function teleportToSeller()
            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hrp = character:FindFirstChild("HumanoidRootPart")

            if hrp then
                hrp.CFrame = SellerCFrame
                updateStatus("Teleported to seller!")
            else
                updateStatus("Character not found")
            end
        end

        local function getFishExploit()
            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hum = character:WaitForChild("Humanoid")

            local backpack = LocalPlayer:FindFirstChild("Backpack")
            local rod = nil

            if backpack then
                rod = backpack:FindFirstChild("Broken Rod")
            end

            if not rod then
                rod = character:FindFirstChild("Broken Rod")
            end

            if not rod then
                updateStatus("Beli Rod Dulu TOLOL!")
                return
            end

            if backpack and rod.Parent == backpack then
                hum:EquipTool(rod)
                updateStatus("Equipping Broken Rod...")
                task.wait(0.3)
            end

            rod = character:FindFirstChild("Broken Rod")
            if not rod then
                updateStatus("Gagal equip Broken Rod!")
                return
            end

            local args = {
                rod,
                {
                    Sell_Price_KG = 999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999,
                    Fish_Name = "HUTAN KONTOL MEMEK",
                    FishImage = "90405868254318",
                    Weight = 999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
                }
            }

            local remote = game:GetService("ReplicatedStorage"):WaitForChild("Fishing_System"):WaitForChild("Remotes"):WaitForChild("FinalTask")
            remote:FireServer(unpack(args))
            updateStatus("Fish exploit fired!")
        end

        getFishBtn.MouseButton1Click:Connect(function()
            updateStatus("Executing fish exploit...")
            getFishExploit()
        end)

        teleportBtn.MouseButton1Click:Connect(function()
            updateStatus("Teleporting...")
            teleportToSeller()
        end)

        closeBtn.MouseButton1Click:Connect(function()
            DestroyFishingMenu()
            -- Sinkronkan toggle "COIN HACK" di menu utama balik ke OFF
            if coinHackSetterRef then coinHackSetterRef(false) end
        end)

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

        UIS.InputChanged:Connect(function(input)
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

        updateStatus("Ready")
    end

    local gridDef = {
        {"ANTI-FLING: OFF","ANTI-FLING: ON", function(v) Protection.AntiFling=v end},
        {"ANTI-SIT: OFF",  "ANTI-SIT: ON",   function(v) Protection.AntiSit=v end},
        {"ANTI-RAGDOLL: OFF","ANTI-RAGDOLL: ON", function(v) Protection.AntiRagdoll=v end},
        {"NAME ESP: OFF",  "NAME ESP: ON",   function(v)
            nameEspEnabled=v
            if v then BuildNameESP() else ClearNameESP() end
        end},
        {"VIEW TRGT: OFF", "VIEW TRGT: ON",  function(v, setter)
            if v then
                if targetPlayer and targetPlayer.Character then
                    local hum=targetPlayer.Character:FindFirstChildOfClass("Humanoid")
                    local cam=workspace.CurrentCamera
                    if hum and cam then
                        pcall(function() cam.CameraSubject=hum; cam.CameraType=Enum.CameraType.Custom end)
                        isSpectating=true
                    else
                        setter(false)
                    end
                else
                    setter(false)
                end
            else
                StopViewTarget()
            end
        end},
        {"FLY: OFF", "FLY: ON", function(v)
            if v then StartFly() else StopFly() end
        end},
        {"COIN HACK: OFF", "COIN HACK: ON", function(v, setter)
            coinHackSetterRef = setter
            if v then
                BuildFishingMenu()
            else
                DestroyFishingMenu()
            end
        end},
    }

    for i,def in ipairs(gridDef) do
        local col=(i-1)%2; local row=math.floor((i-1)/2)
        local x=PX+col*(HALF+4); local y=Y3+row*(BH2+GAP)
        ToggleBtn(def[1],def[2],x,y,HALF,BH2,def[3])
    end

    local rows=math.ceil(#gridDef/2)
    local finalH=Y3+rows*(BH2+GAP)+GAP
    panel.Size=UDim2.new(0,PW,0,finalH)

    -- ── Logika Textbox search: 2 huruf + langsung ketemu, TANPA debounce
    -- yang bisa nge-block, + Enter juga langsung finalize ──
    local selectionMode    = nil
    local lastNotifiedTarget = nil

    local function ProcessSearch(input)
        if #input == 0 then
            targetPlayer=nil; selectionMode=nil
            return
        end
        if #input < 2 then return end

        local found=AutoSelect(input)
        if found and found~=targetPlayer then
            targetPlayer=found; selectionMode="search"
            HookTargetCharacterAdded(targetPlayer)
            if active then
                SetupVictimVisuals(targetPlayer)
            else
                TryAutoStart()
            end
            lastNotifiedTarget=found
        end
    end

    inputBox:GetPropertyChangedSignal("Text"):Connect(function()
        ProcessSearch(inputBox.Text)
    end)

    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            ProcessSearch(inputBox.Text)
        end
    end)

    -- !RE = kirim "!re" ke chat all
    ireBtn.MouseButton1Click:Connect(SendReChat)

    -- BANANA toggle
    local bananaState=false
    bananaBtn.MouseButton1Click:Connect(function()
        if not bananaState and not targetPlayer then
            return -- gak ada target, jangan nyalain apa2
        end
        bananaState=not bananaState
        bananaBtn.BackgroundColor3=bananaState and CLR_ON or CLR_OFF
        bananaBtn.Text=bananaState and "BANANA: ON" or "BANANA: OFF"
        wantsActive=bananaState
        if bananaState then
            StartChase()
        else
            StopChase()
        end
    end)

    -- PlayerAdded: pasang name ESP + hook respawn kalau ON
    Players.PlayerAdded:Connect(function(plr)
        task.wait(0.5)
        plr.CharacterAdded:Connect(function()
            task.wait(0.5)
            if nameEspEnabled then AddNameESPFor(plr) end
        end)
    end)

    -- Hook respawn buat player yang SUDAH ada di server (fix Name ESP
    -- hilang kalau mereka respawn, bukan cuma yang baru join)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            plr.CharacterAdded:Connect(function()
                task.wait(0.5)
                if nameEspEnabled then AddNameESPFor(plr) end
            end)
        end
    end

    Players.PlayerRemoving:Connect(function(plr)
        if targetPlayer==plr then targetPlayer=nil; selectionMode=nil; StopChase() end
        if lastNotifiedTarget==plr then lastNotifiedTarget=nil end
        if nameEspBillboards[plr] then
            pcall(function() nameEspBillboards[plr]:Destroy() end)
            nameEspBillboards[plr]=nil
        end
        if isSpectating and targetPlayer == nil then StopViewTarget() end
    end)

end

ShowKeyGate(MainScript)
