-- ================================================
--   🍌 Banana Peel - Hutan @cenntzy (V1)
--   UI: Rayfield + Key Gate Terpisah
--   Mode Manual + Mode Serang Semua (prioritas terdekat, gantian 1.5s)
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
    Card.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    Card.BorderSizePixel = 0
    Card.Parent = ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = Card

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 200, 60)
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
    InputHolder.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
    InputHolder.BorderSizePixel = 0
    InputHolder.Parent = Card

    local ihCorner = Instance.new("UICorner")
    ihCorner.CornerRadius = UDim.new(0, 8)
    ihCorner.Parent = InputHolder

    local ihStroke = Instance.new("UIStroke")
    ihStroke.Color = Color3.fromRGB(70, 70, 80)
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
        ihStroke.Color = Color3.fromRGB(255, 200, 60)
    end)
    KeyBox.FocusLost:Connect(function()
        ihStroke.Color = Color3.fromRGB(70, 70, 80)
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
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 60)
    SubmitBtn.Text = "MASUK"
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.TextSize = 15
    SubmitBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
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
            stroke.Color = Color3.fromRGB(255, 200, 60)
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

    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

    local Config = {
        Speed      = 800,
        BlastPower = 3000000,
        TargetPart = "HumanoidRootPart",
    }
    local targetPlayer  = nil  -- target manual (dipilih user)
    local active        = false
    local conn          = nil
    local myBananas     = {}
    local lastThrowTime = 0

    -- === Mode Serang Semua ===
    local attackAllMode        = false
    local autoTarget           = nil
    local autoTargetSetAt      = 0
    local AUTO_SWITCH_INTERVAL = 1      -- gantian tiap 1 detik
    local AUTO_COOLDOWN        = 30     -- baru bisa kepilih lagi setelah 30 detik
    local MIN_PICK_DISTANCE    = 15     -- jangan yang KETERLALU deket
    local MAX_PICK_DISTANCE    = 200    -- jangan yang KETERLALU jauh
    local recentlyAttacked     = {}

    -- Target yang SEDANG diserang saat ini (bisa targetPlayer atau autoTarget
    -- tergantung mode) -- ESP selalu ngikutin variabel ini
    local displayTarget = nil

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

    local function GetCenter(char)
        if not char then return nil end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        return root.Position
    end

    -- Cek apakah player sedang duduk di kursi (Seat/VehicleSeat), bukan
    -- cuma humanoid.Sit doang (biar akurat: kursi beneran, bukan trik lain)
    local function IsSeated(plr)
        local char = plr.Character
        if not char then return false end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return false end
        return hum.SeatPart ~= nil or hum.Sit == true
    end

    -- 🎲 Cari korban buat Mode Serang Semua: ACAK (bukan prioritas terdekat),
    -- tapi tetap dibatasi jarak -- jangan yang KETERLALU deket atau jauh,
    -- skip yang lagi cooldown, dan skip yang lagi duduk di kursi.
    local function FindRandomVictim(fromPos, excludeMap)
        local inRange, fallback = {}, {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local onCooldown = excludeMap and excludeMap[plr] and tick() < excludeMap[plr]
                if not onCooldown and not IsSeated(plr) then
                    local pos = GetCenter(plr.Character)
                    if pos then
                        local d = (pos - fromPos).Magnitude
                        table.insert(fallback, plr)
                        if d >= MIN_PICK_DISTANCE and d <= MAX_PICK_DISTANCE then
                            table.insert(inRange, plr)
                        end
                    end
                end
            end
        end

        local pool = #inRange > 0 and inRange or fallback
        if #pool == 0 then return nil end
        return pool[math.random(1, #pool)]
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
        victimBillboard.StudsOffset = Vector3.new(0, 3, 0)
        victimBillboard.AlwaysOnTop = true
        victimBillboard.Parent = char:FindFirstChild("Head") or root

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "NameLabel"
        nameLabel.Size = UDim2.new(1, 0, 0, 12)
        nameLabel.Position = UDim2.new(0, 0, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 10
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextStrokeTransparency = 0
        nameLabel.Text = plr.DisplayName.." (@"..plr.Name..")"
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
    -- 📡 AUTO RE-ATTACH ESP saat korban respawn (khusus mode Manual)
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
                if root and not attackAllMode and targetPlayer == plr and active then
                    SetupVictimVisuals(plr)
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

    local function StartChase()
        if conn then conn:Disconnect() end
        active = true
        ClearAllMovers()

        if attackAllMode then
            autoTarget = nil
            autoTargetSetAt = 0
            recentlyAttacked = {}
        else
            if targetPlayer == LocalPlayer then active = false return end
            displayTarget = targetPlayer
            SetupVictimVisuals(targetPlayer)
        end

        conn = RunService.Heartbeat:Connect(function(dt)
            if not active then return end

            -- Tentukan siapa yang SEDANG diserang frame ini, tergantung mode
            local currentTarget = nil

            if attackAllMode then
                local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local fromPos = myRoot and myRoot.Position

                if fromPos and (not autoTarget or not autoTarget.Character or tick() - autoTargetSetAt >= AUTO_SWITCH_INTERVAL) then
                    if autoTarget then
                        recentlyAttacked[autoTarget] = tick() + AUTO_COOLDOWN
                    end
                    local nextVictim = FindRandomVictim(fromPos, recentlyAttacked)
                    if nextVictim then
                        autoTarget = nextVictim
                        autoTargetSetAt = tick()
                    end
                end
                currentTarget = autoTarget
            else
                currentTarget = targetPlayer
            end

            displayTarget = currentTarget

            if not currentTarget or not currentTarget.Character or currentTarget == LocalPlayer then
                return
            end

            -- ESP di-update PALING DULUAN, gak digantung sama pengecekan
            -- targetRoot/banana di bawah -- ESP (ikut target yg lagi
            -- diserang, gantian di mode Serang Semua) selalu ke-refresh
            UpdateVictimVisuals(currentTarget)

            local character = currentTarget.Character
            local targetRoot = character:FindFirstChild("HumanoidRootPart")
            local humanoid   = character:FindFirstChildOfClass("Humanoid")
            if not targetRoot then return end

            local targetPart = character:FindFirstChild(Config.TargetPart)
            if not targetPart or not targetPart:IsA("BasePart") then
                targetPart = targetRoot
            end

            local EXTREME = Vector3.new(5000000, 5000000, 5000000)
            local upBlast = Vector3.new(0, Config.BlastPower, 0)

            local movers = GetOrCreateMovers(targetRoot)

            -- Kunci gerakan korban SELALU aktif selama masih diserang, TIDAK
            -- cuma pas ada pisang yang lagi ke-detect. Sebelumnya ini ada DI
            -- DALAM loop banana, jadi kalau pisang sempat "kosong" sebentar
            -- (misal abis hilang/belum ke-klaim ulang), korban lepas kunci dan
            -- bisa loncat lagi berkali-kali, ngereset dorongan yang udah
            -- numpuk -- makanya kalau korban spam loncat, dia kelihatan gak
            -- kedorong sama sekali.
            if humanoid then
                pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Physics) end)
                humanoid.PlatformStand = true
                humanoid.Sit = false
                humanoid.WalkSpeed = 0
                humanoid.JumpPower = 0
                pcall(function() humanoid:Move(Vector3.new(0, 0, 0), false) end)
            end

            local vel = targetPart.AssemblyLinearVelocity
            local horizVel = Vector3.new(vel.X, 0, vel.Z)
            local horizSpeed = horizVel.Magnitude
            local isJumping = vel.Y > 2

            local predictedPos = targetPart.Position

            if isJumping then
                -- Loncat: pisang di DEPAN korban 0.2 studs sesuai arah dia
                -- loncat (kalau ada gerak horizontal pas loncat), plus tetap
                -- naik +2 studs biar keliatan "ikut melompat"
                if horizSpeed > 0.5 then
                    predictedPos = predictedPos + horizVel.Unit * 0.2
                end
                predictedPos = predictedPos + Vector3.new(0, 1, 0)
            elseif horizSpeed > 0.5 then
                -- Lari/jalan biasa (gak loncat): 0.1 studs di depan arah gerak
                predictedPos = predictedPos + horizVel.Unit * 0.1
            end

            for _, banana in ipairs(FindBananas()) do
                if not banana or not banana.Parent then continue end

                pcall(function()
                    banana.CFrame = CFrame.new(predictedPos)
                end)
                banana.Anchored = false
                banana.CanCollide = false
                banana.AssemblyLinearVelocity  = EXTREME
                banana.AssemblyAngularVelocity = EXTREME

                if humanoid then
                    pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Physics) end)
                    humanoid.PlatformStand = true
                    humanoid.Sit = false
                    humanoid.WalkSpeed = 0
                    humanoid.JumpPower = 0
                    pcall(function() humanoid:Move(Vector3.new(0, 0, 0), false) end)
                end

                targetRoot.AssemblyLinearVelocity  = upBlast
                targetRoot.AssemblyAngularVelocity = EXTREME

                movers.bv.Velocity = upBlast
                movers.bav.AngularVelocity = EXTREME

                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part ~= targetRoot then
                        part.AssemblyLinearVelocity  = upBlast
                        part.AssemblyAngularVelocity = EXTREME
                    end
                end
            end
        end)

        pcall(function()
            Rayfield:Notify({
                Title    = "🍌 GLOBAL ATTACK!",
                Content  = attackAllMode and "Mode: Serang Semua (prioritas terdekat)" or "Mode: Manual",
                Duration = 3,
            })
        end)
    end

    local function StopChase()
        active = false
        if conn then conn:Disconnect() conn = nil end
        ClearVictimVisuals()
        ClearAllMovers()
        autoTarget = nil
        displayTarget = nil
        pcall(function()
            Rayfield:Notify({ Title="🍌 Dimatikan", Content="", Duration=2 })
        end)
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
    -- 🛡️ PERLINDUNGAN: Anti-Fling, Anti-Ragdoll, Anti-Sit
    -- ================================================

    local Protection = {
        AntiFling   = false,
        AntiRagdoll = false,
        AntiSit     = false,
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

    pcall(function()
        local lastSafePos = nil
        local lastCheckTime = tick()

        RunService.Heartbeat:Connect(function()
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

            local vel = root.AssemblyLinearVelocity
            if vel.Magnitude > 300 then
                root.AssemblyLinearVelocity = Vector3.new(0, math.clamp(vel.Y, -50, 50), 0)
            end

            local avel = root.AssemblyAngularVelocity
            if avel.Magnitude > 50 then
                root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end

            if lastSafePos then
                local delta = (root.Position - lastSafePos).Magnitude
                local maxPlausible = 250 * dt
                if delta > maxPlausible and delta > 15 then
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
    -- UI (Rayfield)
    -- ================================================

    local Window = Rayfield:CreateWindow({
        Name            = "Banana Peel - Hutan @cenntzy",
        LoadingTitle    = "Banana Peel",
        LoadingSubtitle = "Hutan @cenntzy",
        Theme           = "Default",
        ConfigurationSaving = { Enabled = false },
        KeySystem       = false,
    })

    local MainTab = Window:CreateTab("🍌 Main", 4483362458)
    local SetTab  = Window:CreateTab("⚙️ Settings", 4483362458)
    local ProtTab = Window:CreateTab("🛡️ Perlindungan", 4483362458)
    local DevTab  = Window:CreateTab("👨‍💻 Developer", 4483362458)

    -- ================================================
    -- 🍌 TAB MAIN
    -- ================================================

    local playerDropdown
    local searchBoxRef
    local lastNotifiedTarget = nil
    local selectionMode = nil -- "search" atau "dropdown" -- saling eksklusif

    local function RefreshDrop(kw)
        pcall(function()
            if playerDropdown then
                playerDropdown:Refresh(FilterPlayers(kw or ""), true)
            end
        end)
    end

    local function ResetTargetSelection()
        targetPlayer = nil
        lastNotifiedTarget = nil
        selectionMode = nil
        ClearVictimVisuals()
        HookTargetCharacterAdded(nil)
        pcall(function()
            Rayfield:Notify({ Title = "🔄 Target Direset", Content = "Silakan pilih target baru.", Duration = 2 })
        end)
    end

    MainTab:CreateSection("Mode")

    MainTab:CreateToggle({
        Name         = "🌐 Mode Serang Semua Orang (Prioritas Terdekat)",
        CurrentValue = false,
        Flag         = "AttackAllToggle",
        Callback     = function(val)
            attackAllMode = val
            if val then
                -- Nonaktifkan pemilihan manual selama mode ini aktif
                selectionMode = "attackall"
                ClearVictimVisuals()
                autoTarget = nil
                recentlyAttacked = {}
                pcall(function()
                    Rayfield:Notify({ Title = "🌐 Mode Serang Semua ON", Content = "Target gantian tiap 1.5 detik, prioritas terdekat.", Duration = 3 })
                end)
            else
                selectionMode = nil
                ClearVictimVisuals()
                autoTarget = nil
                -- Kembali ke target manual yang tersimpan (kalau ada)
                if active and targetPlayer then
                    SetupVictimVisuals(targetPlayer)
                end
                pcall(function()
                    Rayfield:Notify({ Title = "🌐 Mode Serang Semua OFF", Content = "Kembali ke target manual.", Duration = 3 })
                end)
            end
        end,
    })

    MainTab:CreateSection("Target (khusus Mode Manual)")

    searchBoxRef = MainTab:CreateInput({
        Name                     = "Cari Nama / Nickname",
        PlaceholderText          = "Ketik 2+ huruf → auto terpilih!",
        RemoveTextAfterFocusLost = false,
        Flag                     = "SearchBox",
        Callback                 = function(input)
            if attackAllMode then
                Rayfield:Notify({ Title = "🔒 Nonaktifkan Mode Serang Semua dulu", Duration = 2 })
                return
            end
            if selectionMode == "dropdown" then return end

            pcall(function() RefreshDrop(input) end)
            local found = AutoSelect(input)
            if found and found ~= targetPlayer then
                targetPlayer = found
                selectionMode = "search"
                pcall(function() playerDropdown:Set({"Pilih player..."}) end)
                HookTargetCharacterAdded(targetPlayer)
                if active then SetupVictimVisuals(targetPlayer) end
                if found ~= lastNotifiedTarget then
                    lastNotifiedTarget = found
                    pcall(function()
                        Rayfield:Notify({ Title = "✅ "..found.DisplayName, Content = "Username: "..found.Name, Duration = 2 })
                    end)
                end
            elseif #input == 0 then
                targetPlayer = nil
                selectionMode = nil
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
            if attackAllMode then
                Rayfield:Notify({ Title = "🔒 Nonaktifkan Mode Serang Semua dulu", Duration = 2 })
                return
            end
            if selectionMode == "search" then return end

            local str = type(sel) == "table" and sel[1] or sel
            local plr = ParsePlayer(str)
            if plr then
                targetPlayer = plr
                selectionMode = "dropdown"
                pcall(function() searchBoxRef:Set("") end)
                HookTargetCharacterAdded(targetPlayer)
                if active then SetupVictimVisuals(targetPlayer) end
                if plr ~= lastNotifiedTarget then
                    lastNotifiedTarget = plr
                    pcall(function()
                        Rayfield:Notify({ Title = "🎯 "..plr.DisplayName, Content = "Username: "..plr.Name, Duration = 2 })
                    end)
                end
            end
        end,
    })

    MainTab:CreateButton({
        Name     = "🔄 Refresh List",
        Callback = function() RefreshDrop("") end,
    })

    MainTab:CreateButton({
        Name     = "❌ Reset Target",
        Callback = ResetTargetSelection,
    })

    MainTab:CreateDivider()
    MainTab:CreateSection("Control")

    MainTab:CreateToggle({
        Name         = "🍌 Enable Banana Chaser",
        CurrentValue = false,
        Flag         = "EnableToggle",
        Callback     = function(val)
            if val then
                if not attackAllMode and not targetPlayer then
                    Rayfield:Notify({ Title = "Pilih target dulu (atau aktifkan Mode Serang Semua)!", Duration = 3 })
                    return
                end
                StartChase()
            else
                StopChase()
            end
        end,
    })

    MainTab:CreateButton({
        Name     = "🎯 Lempar Banana Peel",
        Callback = function()
            ThrowBanana()
            Rayfield:Notify({ Title = "🍌", Content = "Pisang dilempar!", Duration = 2 })
        end,
    })

    MainTab:CreateParagraph({
        Title   = "Cara Pakai",
        Content = "1. Pilih target manual ATAU aktifkan Mode Serang Semua\n2. Enable Banana Chaser (WAJIB, jadi saklar utama kedua mode)\n3. Lempar pisang!\n4. Serang Semua: target gantian tiap 1.5s, prioritas terdekat, ESP ikut pindah 🍌💀",
    })

    -- ================================================
    -- ⚙️ TAB SETTINGS
    -- ================================================

    SetTab:CreateSection("Target Bagian Tubuh")

    SetTab:CreateDropdown({
        Name            = "Pisang Mendarat di Bagian Tubuh",
        Options         = bodyPartsList,
        CurrentOption   = {"HumanoidRootPart"},
        MultipleOptions = false,
        Flag            = "BodyPartSelect",
        Callback        = function(sel)
            local str = type(sel) == "table" and sel[1] or sel
            Config.TargetPart = str
        end,
    })

    SetTab:CreateSection("Kecepatan & Kekuatan")

    SetTab:CreateSlider({
        Name         = "Speed Pisang",
        Range        = {100, 3000},
        Increment    = 100,
        Suffix       = " speed",
        CurrentValue = 800,
        Flag         = "BananaSpeed",
        Callback     = function(v) Config.Speed = v end,
    })

    SetTab:CreateSlider({
        Name         = "Blast Power (Ke Atas)",
        Range        = {500000, 10000000},
        Increment    = 250000,
        Suffix       = " power",
        CurrentValue = 3000000,
        Flag         = "BlastPower",
        Callback     = function(v)
            Config.BlastPower = v
            Rayfield:Notify({ Title = "💥 Blast Power: "..v, Duration = 1 })
        end,
    })

    SetTab:CreateParagraph({
        Title   = "Panduan",
        Content = "Blast Power makin tinggi = korban makin tinggi & jauh terpental.",
    })

    -- ================================================
    -- 🛡️ TAB PERLINDUNGAN
    -- ================================================

    ProtTab:CreateSection("Perlindungan Diri")
    ProtTab:CreateParagraph({
        Title   = "Info",
        Content = "Kebal dari gangguan pemain lain -- fling, ragdoll paksa, dan duduk paksa.",
    })

    ProtTab:CreateToggle({
        Name         = "🛡️ Anti-Fling",
        CurrentValue = false,
        Flag         = "AntiFlingToggle",
        Callback     = function(val)
            Protection.AntiFling = val
            Rayfield:Notify({ Title = val and "🛡️ Anti-Fling ON" or "Anti-Fling OFF", Duration = 2 })
        end,
    })

    ProtTab:CreateToggle({
        Name         = "🛡️ Anti-Ragdoll",
        CurrentValue = false,
        Flag         = "AntiRagdollToggle",
        Callback     = function(val)
            Protection.AntiRagdoll = val
            Rayfield:Notify({ Title = val and "🛡️ Anti-Ragdoll ON" or "Anti-Ragdoll OFF", Duration = 2 })
        end,
    })

    ProtTab:CreateToggle({
        Name         = "🛡️ Anti-Sit",
        CurrentValue = false,
        Flag         = "AntiSitToggle",
        Callback     = function(val)
            Protection.AntiSit = val
            Rayfield:Notify({ Title = val and "🛡️ Anti-Sit ON" or "Anti-Sit OFF", Duration = 2 })
        end,
    })

    -- ================================================
    -- 👨‍💻 TAB DEVELOPER
    -- ================================================

    DevTab:CreateSection("Tentang Script")

    DevTab:CreateParagraph({
        Title   = "Banana Peel - Hutan",
        Content = "Dibuat oleh: @cenntzy\nDiscord: @cenntzy\n\nUntuk request key, bug report, atau saran fitur, hubungi langsung lewat Discord.",
    })

    DevTab:CreateButton({
        Name     = "📋 Copy Discord: @cenntzy",
        Callback = function()
            local copied = false
            pcall(function()
                if setclipboard then
                    setclipboard("@cenntzy")
                    copied = true
                end
            end)
            if copied then
                Rayfield:Notify({ Title = "📋 Disalin!", Content = "Discord @cenntzy sudah disalin ke clipboard.", Duration = 3 })
            else
                Rayfield:Notify({ Title = "Discord", Content = "@cenntzy (clipboard tidak didukung executor ini)", Duration = 5 })
            end
        end,
    })

    Players.PlayerAdded:Connect(function() task.wait(0.5) RefreshDrop("") end)
    Players.PlayerRemoving:Connect(function(plr)
        if targetPlayer == plr then
            targetPlayer = nil
            selectionMode = nil
            if not attackAllMode then StopChase() end
        end
        if autoTarget == plr then autoTarget = nil end
        recentlyAttacked[plr] = nil
        if lastNotifiedTarget == plr then lastNotifiedTarget = nil end
        task.wait(0.5) RefreshDrop("")
    end)

    Rayfield:Notify({
        Title    = "Banana Peel - Hutan",
        Content  = "By @cenntzy | Siap digunakan!",
        Duration = 3,
    })
end

-- ================================================
-- MULAI: tampilkan Key Gate dulu, baru load script utama
-- ================================================
ShowKeyGate(MainScript)
