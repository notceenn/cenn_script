-- ================================================
-- 🍌 Banana Peel + BLACKHOLE @cenntzy (Fix v2)
-- Blackhole hanya untuk Banana Peel | ESP 360° utuh
-- ================================================

local Players      = game:GetService("Players")
local Workspace    = game:GetService("Workspace")
local RunService   = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer  = Players.LocalPlayer
local Camera       = Workspace.CurrentCamera
local PlayerGui    = LocalPlayer:WaitForChild("PlayerGui")

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
-- 🔑 KEY GATE
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
    Sub.Text = "Masukkan key untuk membuka script."
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
            Status.Text = "⚠️ Gagal mengambil data key."
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
            Status.Text = "❌ Key salah! Coba lagi."
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
-- 🍌 SCRIPT UTAMA
-- ================================================

local function MainScript()

    local Config = {
        BlastPower = 15000000,
        TargetPart = "HumanoidRootPart",
    }
    local targetPlayer  = nil
    local active        = false
    local wantsActive   = false
    local conn          = nil
    local myBananas     = {}
    local lastThrowTime = 0

    -- ================================================
    -- SAFE GUI HELPER
    -- ================================================
    local function safeGui(name, displayOrder)
        local parent = PlayerGui
        pcall(function() local h=gethui(); if h then parent=h end end)
        local old=parent:FindFirstChild(name); if old then old:Destroy() end
        if parent~=PlayerGui then local o2=PlayerGui:FindFirstChild(name); if o2 then o2:Destroy() end end
        local sg=Instance.new("ScreenGui")
        sg.Name=name; sg.ResetOnSpawn=false; sg.DisplayOrder=displayOrder or 100; sg.IgnoreGuiInset=true
        sg.Parent=parent; return sg
    end

    -- ================================================
    -- NOTIFIKASI LENGKAP (ESP 360° STYLE)
    -- ================================================
    local NotifSG=safeGui("BH_Notif",1000)
    local NC=Instance.new("Frame",NotifSG)
    NC.Size=UDim2.new(0,300,0,56); NC.AnchorPoint=Vector2.new(0.5,0)
    NC.Position=UDim2.new(0.5,0,0,10); NC.BackgroundTransparency=1; NC.ClipsDescendants=false

    local NotifCard=Instance.new("Frame",NC)
    NotifCard.Size=UDim2.new(1,0,1,0); NotifCard.Position=UDim2.new(0,0,0,-70)
    NotifCard.BackgroundColor3=Color3.fromRGB(16,16,16); NotifCard.BorderSizePixel=0
    Instance.new("UICorner",NotifCard).CornerRadius=UDim.new(0,10)
    Instance.new("UIGradient",NotifCard).Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(40,40,40)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(12,12,12)),
    })

    local NotifAccent=Instance.new("Frame",NotifCard)
    NotifAccent.Size=UDim2.new(0,3,0.6,0); NotifAccent.Position=UDim2.new(0,10,0.2,0)
    NotifAccent.BackgroundColor3=Color3.fromRGB(255,80,80); NotifAccent.BorderSizePixel=0
    Instance.new("UICorner",NotifAccent).CornerRadius=UDim.new(1,0)

    local NotifIcon=Instance.new("TextLabel",NotifCard)
    NotifIcon.Size=UDim2.new(0,28,1,0); NotifIcon.Position=UDim2.new(0,18,0,0)
    NotifIcon.BackgroundTransparency=1; NotifIcon.TextScaled=true
    NotifIcon.Font=Enum.Font.GothamBold; NotifIcon.Text="●"; NotifIcon.TextColor3=Color3.new(1,1,1)

    local NotifText=Instance.new("TextLabel",NotifCard)
    NotifText.Size=UDim2.new(1,-58,1,0); NotifText.Position=UDim2.new(0,50,0,0)
    NotifText.BackgroundTransparency=1; NotifText.TextXAlignment=Enum.TextXAlignment.Left
    NotifText.TextScaled=true; NotifText.Font=Enum.Font.GothamBold
    NotifText.Text=""; NotifText.TextColor3=Color3.new(1,1,1); NotifText.TextStrokeTransparency=0.6

    local NotifBar=Instance.new("Frame",NotifCard)
    NotifBar.Size=UDim2.new(1,-16,0,3); NotifBar.Position=UDim2.new(0,8,1,-5)
    NotifBar.BackgroundColor3=Color3.fromRGB(255,80,80); NotifBar.BorderSizePixel=0
    Instance.new("UICorner",NotifBar).CornerRadius=UDim.new(1,0)

    local NOTIF_CFG={
        target={icon="🎯",color=Color3.fromRGB(255,80,80)},   on={icon="🌀",color=Color3.fromRGB(100,180,255)},
        off={icon="⛔",color=Color3.fromRGB(120,120,120)},     warn={icon="⚠️",color=Color3.fromRGB(255,180,50)},
        err={icon="❌",color=Color3.fromRGB(200,60,60)},       alive={icon="✅",color=Color3.fromRGB(80,220,80)},
        sitting={icon="💺",color=Color3.fromRGB(255,210,50)},  died={icon="💀",color=Color3.fromRGB(255,60,60)},
        respawn={icon="🔄",color=Color3.fromRGB(140,140,255)}, left={icon="🚪",color=Color3.fromRGB(160,160,160)},
    }
    local HIDDEN=UDim2.new(0,0,0,-70); local SHOWN=UDim2.new(0,0,0,0)
    local nTweenIn,nTweenBar,nTweenOut,nThread=nil,nil,nil,nil

    local function showNotif(msg,ntype)
        local cfg=NOTIF_CFG[ntype] or {icon="●",color=Color3.fromRGB(200,200,200)}
        if nTweenIn  then nTweenIn:Cancel();    nTweenIn=nil  end
        if nTweenBar then nTweenBar:Cancel();   nTweenBar=nil end
        if nTweenOut then nTweenOut:Cancel();   nTweenOut=nil end
        if nThread   then task.cancel(nThread); nThread=nil   end
        NotifCard.Position=HIDDEN
        NotifText.Text=msg; NotifIcon.Text=cfg.icon
        NotifAccent.BackgroundColor3=cfg.color; NotifBar.BackgroundColor3=cfg.color
        NotifBar.Size=UDim2.new(1,-16,0,3)
        nTweenIn=TweenService:Create(NotifCard,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Position=SHOWN})
        nTweenIn:Play()
        nTweenBar=TweenService:Create(NotifBar,TweenInfo.new(2.7,Enum.EasingStyle.Linear),{Size=UDim2.new(0,0,0,3)})
        task.delay(0.3,function() if nTweenBar then nTweenBar:Play() end end)
        nThread=task.delay(3,function()
            nTweenOut=TweenService:Create(NotifCard,TweenInfo.new(0.25,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{Position=HIDDEN})
            nTweenOut:Play()
            nTweenOut.Completed:Connect(function() nTweenOut=nil; nThread=nil end)
        end)
    end

    -- ================================================
    -- ESP 360° BLACKHOLE (TARGET ONLY) - UTUH
    -- ================================================
    local DrawingLib=Drawing or {}

    local tName=DrawingLib.new and DrawingLib.new("Text") or nil
    if tName then tName.Size=14; tName.Center=true; tName.Outline=true; tName.Visible=false end
    local tDist=DrawingLib.new and DrawingLib.new("Text") or nil
    if tDist then tDist.Size=12; tDist.Center=true; tDist.Outline=true; tDist.Visible=false end
    local tStatus=DrawingLib.new and DrawingLib.new("Text") or nil
    if tStatus then tStatus.Size=12; tStatus.Center=true; tStatus.Outline=true; tStatus.Visible=false end

    local Highlight
    pcall(function()
        Highlight=Instance.new("Highlight",game:GetService("CoreGui"))
        Highlight.FillColor=Color3.new(1,0,0)
        Highlight.OutlineColor=Color3.fromRGB(255,80,80)
        Highlight.Enabled=false
    end)

    local ArrowSG=safeGui("BH_Arrow",100)
    local ArrowFrame=Instance.new("Frame",ArrowSG)
    ArrowFrame.Size=UDim2.new(0,40,0,40); ArrowFrame.BackgroundTransparency=1
    ArrowFrame.Visible=false; ArrowFrame.AnchorPoint=Vector2.new(0.5,0.5)

    local ArrowImg=Instance.new("ImageLabel",ArrowFrame)
    ArrowImg.Size=UDim2.new(1,0,1,0); ArrowImg.BackgroundTransparency=1
    ArrowImg.Image="rbxassetid://6034818379"; ArrowImg.ImageColor3=Color3.fromRGB(255,60,60)
    ArrowImg.AnchorPoint=Vector2.new(0.5,0.5); ArrowImg.Position=UDim2.new(0.5,0,0.5,0)

    local ArrowDist=Instance.new("TextLabel",ArrowFrame)
    ArrowDist.Size=UDim2.new(1,0,0.4,0); ArrowDist.Position=UDim2.new(0,0,1.1,0)
    ArrowDist.BackgroundTransparency=1; ArrowDist.TextColor3=Color3.fromRGB(255,255,255)
    ArrowDist.TextScaled=true; ArrowDist.Font=Enum.Font.GothamBold
    ArrowDist.Text=""; ArrowDist.TextStrokeTransparency=0

    local ArrowStatus=Instance.new("TextLabel",ArrowFrame)
    ArrowStatus.Size=UDim2.new(2,0,0.4,0); ArrowStatus.Position=UDim2.new(-0.5,0,1.55,0)
    ArrowStatus.BackgroundTransparency=1; ArrowStatus.TextColor3=Color3.fromRGB(255,255,100)
    ArrowStatus.TextScaled=true; ArrowStatus.Font=Enum.Font.GothamBold
    ArrowStatus.Text=""; ArrowStatus.TextStrokeTransparency=0

    local EDGE_PADDING=60
    local function getScreenEdgePosition(worldPos)
        local vp=Camera.ViewportSize; local cx,cy=vp.X/2,vp.Y/2
        local sp,inFront=Camera:WorldToViewportPoint(worldPos)
        local dx,dy=sp.X-cx,sp.Y-cy
        if not inFront then dx=-dx; dy=-dy end
        local len=math.sqrt(dx*dx+dy*dy)
        if len==0 then return Vector2.new(cx,cy),0 end
        local ndx,ndy=dx/len,dy/len
        local scaleX=ndx~=0 and ((ndx>0 and vp.X-EDGE_PADDING-cx or cx-EDGE_PADDING)/math.abs(ndx)) or math.huge
        local scaleY=ndy~=0 and ((ndy>0 and vp.Y-EDGE_PADDING-cy or cy-EDGE_PADDING)/math.abs(ndy)) or math.huge
        local sc=math.min(scaleX,scaleY)
        return Vector2.new(cx+ndx*sc,cy+ndy*sc),math.deg(math.atan2(ndy,ndx))+90
    end

    local STATUS_COLORS={
        Alive=Color3.fromRGB(100,255,100), Sitting=Color3.fromRGB(255,200,50),
        Died=Color3.fromRGB(255,80,80),    Respawn=Color3.fromRGB(180,180,255),
        Left=Color3.fromRGB(180,180,180),
    }
    local STATUS_NOTIFTYPE={Alive="alive",Sitting="sitting",Died="died",Respawn="respawn",Left="left"}
    local STATUS_MSG={Alive="Target is Alive",Sitting="Target is Sitting",Died="Target Died",Respawn="Target Respawning",Left="Target Left"}
    local currentStatus="Alive"; local previousStatus="Alive"

    local function getTargetStatus(player)
        if not player then return "Left" end
        local found=false
        for _,p in pairs(Players:GetPlayers()) do if p==player then found=true; break end end
        if not found then return "Left" end
        local char=player.Character; if not char then return "Respawn" end
        local hum=char:FindFirstChildOfClass("Humanoid"); if not hum then return "Respawn" end
        if hum.Health<=0 then return "Died" end
        if hum.Sit then return "Sitting" end
        return "Alive"
    end

    local function handleStatusTransition(newStatus)
        if newStatus~=previousStatus then
            previousStatus=newStatus; currentStatus=newStatus
            if targetPlayer then
                showNotif(STATUS_MSG[newStatus] or newStatus,STATUS_NOTIFTYPE[newStatus] or "warn")
            end
        end
    end

    Players.PlayerRemoving:Connect(function(p)
        if p==targetPlayer then handleStatusTransition("Left") end
    end)

    -- ================================================
    -- NAME ESP (NON-TARGET ONLY)
    -- ================================================
    local nameEspEnabled = false
    local nameEspBillboards = {}

    local function ClearNameESP()
        for plr, bb in pairs(nameEspBillboards) do
            pcall(function() if bb and bb.Parent then bb:Destroy() end end)
            nameEspBillboards[plr] = nil
        end
    end

    local function AddNameESPFor(plr)
        if plr == LocalPlayer then return end
        if plr == targetPlayer then return end
        if not nameEspEnabled then return end
        if not plr.Character then return end
        local head = plr.Character:FindFirstChild("Head")
        if not head then return end

        if nameEspBillboards[plr] then
            pcall(function() nameEspBillboards[plr]:Destroy() end)
            nameEspBillboards[plr] = nil
        end

        local bb = Instance.new("BillboardGui", head)
        bb.Name = "NameESP"
        bb.Size = UDim2.new(0, 140, 0, 28)
        bb.StudsOffset = Vector3.new(0, 2.5, 0)
        bb.AlwaysOnTop = true

        local lbl = Instance.new("TextLabel", bb)
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 10
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.TextStrokeTransparency = 0
        lbl.Text = plr.DisplayName .. "\n(@" .. plr.Name .. ")"

        nameEspBillboards[plr] = bb
    end

    local function RemoveNameESPFor(plr)
        if nameEspBillboards[plr] then
            pcall(function() nameEspBillboards[plr]:Destroy() end)
            nameEspBillboards[plr] = nil
        end
    end

    local function BuildAllNameESP()
        ClearNameESP()
        for _, plr in ipairs(Players:GetPlayers()) do
            AddNameESPFor(plr)
        end
    end

    local function RefreshNameESP()
        if not nameEspEnabled then return end
        if targetPlayer then RemoveNameESPFor(targetPlayer) end
        for _, plr in ipairs(Players:GetPlayers()) do
            AddNameESPFor(plr)
        end
    end

    -- ================================================
    -- BLACKHOLE SYSTEM (HANYA UNTUK BANANA PEEL)
    -- ================================================
    local blackHoleActive = false
    local AnchorFolder = Instance.new("Folder", Workspace)
    AnchorFolder.Name = "BH_Folder"
    local AnchorPart = Instance.new("Part", AnchorFolder)
    AnchorPart.Name = "BH_Anchor"
    AnchorPart.Anchored = true
    AnchorPart.CanCollide = false
    AnchorPart.Transparency = 1
    AnchorPart.Size = Vector3.new(1, 1, 1)
    AnchorPart.CFrame = CFrame.new(0, -9999, 0)
    local AnchorAttachment = Instance.new("Attachment", AnchorPart)

    if not getgenv().BH_Net then
        getgenv().BH_Net = true
        RunService.Heartbeat:Connect(function()
            pcall(function()
                sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
            end)
        end)
    end

    -- Data AlignPosition untuk Banana di Blackhole
    local bhBananaData = {}

    local function RegisterBananaToBH(banana)
        if not banana or not banana.Parent then return end
        if bhBananaData[banana] then return end

        pcall(function()
            banana:SetNetworkOwner(LocalPlayer)
            banana.Anchored = false
            banana.CanCollide = false
            banana.Massless = true

            -- Hancurkan constraint lama
            for _, x in ipairs(banana:GetChildren()) do
                if x.Name == "BH_Att" or x.Name == "BH_Align" or x.Name == "BH_Torque" then
                    x:Destroy()
                end
            end

            local att = Instance.new("Attachment", banana)
            att.Name = "BH_Att"

            local ap = Instance.new("AlignPosition", banana)
            ap.Name = "BH_Align"
            ap.MaxForce = math.huge
            ap.MaxVelocity = math.huge
            ap.Responsiveness = 200
            ap.Attachment0 = att
            ap.Attachment1 = AnchorAttachment

            local tq = Instance.new("Torque", banana)
            tq.Name = "BH_Torque"
            tq.Torque = Vector3.new(100000, 100000, 100000)
            tq.Attachment0 = att

            bhBananaData[banana] = { ap = ap, tq = tq, att = att }
        end)
    end

    local function UnregisterBananaFromBH(banana)
        local data = bhBananaData[banana]
        if data then
            pcall(function() data.ap:Destroy() end)
            pcall(function() data.tq:Destroy() end)
            pcall(function() data.att:Destroy() end)
            bhBananaData[banana] = nil
        end
        if banana and banana.Parent then
            pcall(function()
                banana.Massless = false
                banana.CanCollide = true
            end)
        end
    end

    local function SyncBlackholeBananas()
        -- Daftarkan banana yang ada di myBananas, hapus yang sudah tidak ada
        for banana, _ in pairs(myBananas) do
            if banana and banana.Parent and not bhBananaData[banana] then
                RegisterBananaToBH(banana)
            end
        end
        -- Hapus data banana yang sudah tidak valid
        for banana, _ in pairs(bhBananaData) do
            if not banana or not banana.Parent or not myBananas[banana] then
                UnregisterBananaFromBH(banana)
            end
        end
    end

    local FLING_POWER = 6000
    local targetPos = Vector3.new(0, -9999, 0)
    local lastFlingTime = 0

    RunService.Heartbeat:Connect(function()
        if not blackHoleActive then return end
        AnchorPart.CFrame = CFrame.new(targetPos)
        local now = tick()
        if now - lastFlingTime < 0.2 then return end

        -- Sync banana list
        SyncBlackholeBananas()

        -- Cari banana terdekat dengan target
        local closestBanana = nil
        local closestDist = math.huge
        for banana, _ in pairs(bhBananaData) do
            if banana and banana.Parent then
                local d = (banana.Position - targetPos).Magnitude
                if d < closestDist then
                    closestDist = d
                    closestBanana = banana
                end
            end
        end

        if closestBanana and targetPlayer and targetPlayer.Character then
            local root2 = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root2 then
                lastFlingTime = now
                pcall(function() closestBanana.CFrame = CFrame.new(root2.Position) end)
                local rx = (math.random() - 0.5) * 2
                local rz = (math.random() - 0.5) * 2
                local flingDir = Vector3.new(rx, 1.5, rz).Unit
                pcall(function()
                    for _, bp in ipairs(targetPlayer.Character:GetDescendants()) do
                        if bp:IsA("BasePart") then
                            bp.AssemblyLinearVelocity = flingDir * FLING_POWER
                        end
                    end
                end)
            end
        end
    end)

    -- ================================================
    -- ESP RENDER LOOP (360° Arrow + Drawing + Highlight)
    -- ================================================
    RunService.RenderStepped:Connect(function()
        local char = targetPlayer and targetPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local status = getTargetStatus(targetPlayer)
        handleStatusTransition(status); currentStatus = status

        if not targetPlayer or status == "Left" then
            if Highlight then Highlight.Enabled = false end
            if tName then tName.Visible = false; tDist.Visible = false; tStatus.Visible = false end
            ArrowFrame.Visible = false
            return
        end
        if not (root and hum) then
            if Highlight then Highlight.Enabled = false end
            if tName then tName.Visible = false; tDist.Visible = false; tStatus.Visible = false end
            ArrowFrame.Visible = false
            return
        end

        local alive = hum.Health > 0
        local sp, onScreen = Camera:WorldToViewportPoint(root.Position)

        if onScreen and alive then
            if Highlight then Highlight.Adornee = char; Highlight.Enabled = true end
            if tName then
                tName.Visible = true; tName.Text = targetPlayer.Name
                tName.Position = Vector2.new(sp.X, sp.Y - 50); tName.Color = Color3.new(1, 1, 1)
            end
            if tDist then
                tDist.Visible = true; tDist.Text = math.floor((root.Position - Camera.CFrame.Position).Magnitude) .. "m"
                tDist.Position = Vector2.new(sp.X, sp.Y - 35); tDist.Color = Color3.new(1, 1, 1)
            end
            if tStatus then
                tStatus.Visible = true; tStatus.Text = "[ " .. status .. " ]"
                tStatus.Position = Vector2.new(sp.X, sp.Y - 20)
                tStatus.Color = STATUS_COLORS[status] or Color3.new(1, 1, 1)
            end
            ArrowFrame.Visible = false
        else
            if Highlight then Highlight.Enabled = false end
            if tName then tName.Visible = false; tDist.Visible = false; tStatus.Visible = false end
            local ep, ang = getScreenEdgePosition(root.Position)
            ArrowFrame.Visible = true
            ArrowFrame.Position = UDim2.new(0, ep.X, 0, ep.Y); ArrowImg.Rotation = ang
            ArrowDist.Text = math.floor((root.Position - Camera.CFrame.Position).Magnitude) .. "m"
            ArrowStatus.Text = status; ArrowStatus.TextColor3 = STATUS_COLORS[status] or Color3.new(1, 1, 1)
        end

        if alive then
            targetPos = root.Position + Vector3.new(0, 1, 0)
        end
    end)

    -- ================================================
    -- UTILITY (BANANA PEEL)
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
        Workspace.ChildAdded:Connect(function(obj)
            pcall(ClaimIfMine, obj)
            task.delay(0.1, function() pcall(ClaimIfMine, obj) end)
            task.delay(0.2, function() pcall(ClaimIfMine, obj) end)
        end)
    end)

    for _, obj in ipairs(Workspace:GetChildren()) do
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
    -- 📡 AUTO RE-ATTACH SPECTATE
    -- ================================================

    local isSpectating = false
    local targetCharConn = nil

    local function EnforceSpectate()
        if not isSpectating or not targetPlayer or not targetPlayer.Character then return end
        local hum = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
        local cam = Workspace.CurrentCamera
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
        local cam = Workspace.CurrentCamera
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

    local function HookTargetCharacterAdded(plr)
        if targetCharConn then
            pcall(function() targetCharConn:Disconnect() end)
            targetCharConn = nil
        end
        if not plr then return end
        targetCharConn = plr.CharacterAdded:Connect(function(newChar)
            task.spawn(function()
                if targetPlayer == plr and isSpectating then
                    local hum = newChar:WaitForChild("Humanoid", 5)
                    local cam = Workspace.CurrentCamera
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
    -- 🔥 GLOBAL ATTACK (BANANA) - DIPERKUAT
    -- ================================================

    local victimMovers = {}
    local bananaAttachData = {} -- [banana] = {att0, att1, ap} untuk AlignPosition ke targetRoot

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

    local function ClearBananaAttachments()
        for banana, data in pairs(bananaAttachData) do
            pcall(function() if data.att0 then data.att0:Destroy() end end)
            pcall(function() if data.att1 then data.att1:Destroy() end end)
            pcall(function() if data.ap then data.ap:Destroy() end end)
        end
        bananaAttachData = {}
    end

    local StartChase, StopChase

    StartChase = function()
        if conn then conn:Disconnect() end
        if not targetPlayer or targetPlayer == LocalPlayer then return end

        active = true
        ClearAllMovers()
        ClearBananaAttachments()

        conn = RunService.Heartbeat:Connect(function(dt)
            if not active then return end
            if not targetPlayer or not targetPlayer.Character or targetPlayer == LocalPlayer then return end

            local character = targetPlayer.Character
            local targetRoot = character:FindFirstChild("HumanoidRootPart")
            local humanoid   = character:FindFirstChildOfClass("Humanoid")
            if not targetRoot then return end

            local targetPart = character:FindFirstChild(Config.TargetPart)
            if not targetPart or not targetPart:IsA("BasePart") then
                targetPart = targetRoot
            end

            pcall(function()
                if targetRoot.Anchored then targetRoot.Anchored = false end
                targetRoot:SetNetworkOwner(LocalPlayer)
            end)

            local isInSeat = humanoid and humanoid.SeatPart ~= nil

            local vel = targetPart.AssemblyLinearVelocity
            local horizVel = Vector3.new(vel.X, 0, vel.Z)
            local horizSpeed = horizVel.Magnitude
            local isJumping = vel.Y > 2
            local isSitting = humanoid and (humanoid.Sit or humanoid.SeatPart ~= nil)

            local predictedPos = targetPart.Position

            if isSitting then
                predictedPos = predictedPos + Vector3.new(0, -1.5, 0)
            elseif isJumping then
                if horizSpeed > 0.5 then
                    predictedPos = predictedPos + horizVel.Unit * 0.2
                end
                predictedPos = predictedPos + Vector3.new(0, 0.2, 0)
                predictedPos = predictedPos + vel * 0.08
            elseif horizSpeed > 0.5 then
                predictedPos = predictedPos + horizVel.Unit * 0.2
            end

            local EXTREME = Vector3.new(500000, 500000, 500000)
            local upBlast = Vector3.new(0, Config.BlastPower, 0)

            local movers = GetOrCreateMovers(targetRoot)

            if humanoid and not isInSeat then
                pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Physics) end)
                humanoid.PlatformStand = true
                humanoid.Sit = false
                humanoid.WalkSpeed = 0
                humanoid.JumpPower = 0
                pcall(function() humanoid:Move(Vector3.new(0, 0, 0), false) end)
            end

            if not isInSeat then
                local rigVelocity = targetRoot.AssemblyLinearVelocity

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

            local uprightCFrame = CFrame.new(predictedPos) * CFrame.Angles(0, 0, 0)

            for _, banana in ipairs(FindBananas()) do
                if not banana or not banana.Parent then continue end

                -- CFrame teleport
                pcall(function()
                    banana.CFrame = uprightCFrame
                end)

                -- AlignPosition ke targetRoot agar nempel mutlak
                if not bananaAttachData[banana] then
                    local att0 = Instance.new("Attachment", banana)
                    att0.Name = "BanAtt0"
                    local att1 = Instance.new("Attachment", targetRoot)
                    att1.Name = "BanAtt1"
                    local ap = Instance.new("AlignPosition", banana)
                    ap.Name = "BanAP"
                    ap.Mode = Enum.PositionAlignmentMode.TwoAttachment
                    ap.MaxForce = math.huge
                    ap.MaxVelocity = math.huge
                    ap.Responsiveness = 200
                    ap.RigidityEnabled = true
                    ap.Attachment0 = att0
                    ap.Attachment1 = att1
                    bananaAttachData[banana] = { att0 = att0, att1 = att1, ap = ap }
                else
                    -- Pastikan attachment1 masih ke targetRoot yang sama
                    local data = bananaAttachData[banana]
                    if data.att1.Parent ~= targetRoot then
                        data.att1.Parent = targetRoot
                    end
                end

                banana.Anchored = false
                banana.CanCollide = false
                -- Velocity diperkuat (3x lipat sumbu Y)
                banana.AssemblyLinearVelocity  = Vector3.new(EXTREME.X, EXTREME.Y + 1500000, EXTREME.Z)
                banana.AssemblyAngularVelocity = EXTREME
            end

            -- Bersihkan data banana yang hilang
            for banana, data in pairs(bananaAttachData) do
                if not banana or not banana.Parent then
                    pcall(function() data.att0:Destroy() end)
                    pcall(function() data.att1:Destroy() end)
                    pcall(function() data.ap:Destroy() end)
                    bananaAttachData[banana] = nil
                end
            end
        end)
    end

    StopChase = function()
        active = false
        if conn then conn:Disconnect() conn = nil end
        ClearAllMovers()
        ClearBananaAttachments()
    end

    -- ================================================
    -- LEMPAR & CHAT COMMAND
    -- ================================================

    local function ThrowBanana()
        local char = LocalPlayer.Character
        if not char then return end
        local tool = nil
        for _, src in ipairs({ LocalPlayer:FindFirstChild("Backpack"), LocalPlayer.Character }) do
            if src then
                for _, obj in ipairs(src:GetChildren()) do
                    if obj:IsA("Tool") and (obj.Name:lower():find("banana") or obj.Name:lower():find("peel")) then
                        tool = obj; break
                    end
                end
            end
            if tool then break end
        end
        if not tool then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid and tool.Parent ~= char then
            pcall(function() humanoid:EquipTool(tool) end)
            task.wait(0.1)
        end
        lastThrowTime = tick()
        pcall(function() tool:Activate() end)
    end

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
    -- 🛡️ PERLINDUNGAN
    -- ================================================

    local Protection = {
        AntiFlingParts = false,
        AntiRagdoll    = false,
        AntiSit        = false,
        Noclip         = false,
    }

    local DANGEROUS_CLASSES = {
        BodyVelocity = true, BodyAngularVelocity = true, BodyForce = true,
        BodyThrust = true, BodyPosition = true, BodyGyro = true,
        LinearVelocity = true, AngularVelocity = true, VectorForce = true,
        AlignPosition = true, AlignOrientation = true, Torque = true,
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
                    end)
                end
            end)
        end)

        local function DestroyIfDangerous(child)
            if not Protection.AntiFlingParts then return end
            local ok, className = pcall(function() return child.ClassName end)
            if ok and DANGEROUS_CLASSES[className] then
                task.defer(function()
                    pcall(function() child:Destroy() end)
                end)
            end
        end

        pcall(function() root.ChildAdded:Connect(DestroyIfDangerous) end)
        pcall(function() char.DescendantAdded:Connect(DestroyIfDangerous) end)
        for _, child in ipairs(char:GetDescendants()) do
            DestroyIfDangerous(child)
        end
    end

    pcall(function()
        if LocalPlayer.Character then HookProtection(LocalPlayer.Character) end
        LocalPlayer.CharacterAdded:Connect(function(char)
            task.wait(0.2)
            HookProtection(char)
        end)
    end)

    pcall(function()
        RunService.Stepped:Connect(function()
            if Protection.Noclip and LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        pcall(function() part.CanCollide = false end)
                    end
                end
            end
        end)
    end)

    pcall(function()
        local lastSafePos = nil
        local lastCheckTime = tick()

        RunService.Heartbeat:Connect(function()
            pcall(EnforceSpectate)

            if not Protection.AntiFlingParts then
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
    -- CUSTOM GUI (CENN HUB! + BLACKHOLE BUTTON)
    -- ================================================

    local CLR_BG      = Color3.fromRGB(6, 22, 26)
    local CLR_PANEL   = Color3.fromRGB(10, 34, 40)
    local CLR_BORDER  = Color3.fromRGB(40, 220, 235)
    local CLR_ON      = Color3.fromRGB(20, 160, 180)
    local CLR_OFF     = Color3.fromRGB(12, 40, 46)
    local CLR_RED     = Color3.fromRGB(170, 25, 25)
    local CLR_BH      = Color3.fromRGB(180, 20, 20)
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
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local d=i.Position-ds
            panel.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
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

    local Y1 = PY_START                    -- search box
    local Y2 = Y1 + BH + GAP               -- !RE | BANANA | BLACKHOLE
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

    -- ROW 2: 3 tombol (!RE | BANANA | BLACKHOLE)
    local THIRD = math.floor(FULL/3) - 2
    local ireBtn     = Btn("!RE",       PX,                 Y2, THIRD, BH2, CLR_OFF)
    local bananaBtn  = Btn("BANANA: OFF", PX+THIRD+3,       Y2, THIRD, BH2, CLR_OFF)
    local bhBtn      = Btn("BH: OFF",     PX+(THIRD+3)*2,   Y2, THIRD, BH2, CLR_OFF)

    -- GRID TOGGLE
    local gridDef = {
        {"ANTI-FLING: OFF","ANTI-FLING: ON", function(v) Protection.AntiFlingParts=v end},
        {"ANTI-SIT: OFF",  "ANTI-SIT: ON",   function(v) Protection.AntiSit=v end},
        {"ANTI-RAGDOLL: OFF","ANTI-RAGDOLL: ON", function(v) Protection.AntiRagdoll=v end},
        {"NOCLIP: OFF",    "NOCLIP: ON",     function(v) Protection.Noclip=v end},
        {"NAME ESP: OFF",  "NAME ESP: ON",   function(v)
            nameEspEnabled = v
            if v then BuildAllNameESP() else ClearNameESP() end
        end},
        {"VIEW TRGT: OFF", "VIEW TRGT: ON",  function(v, setter)
            if v then
                if targetPlayer and targetPlayer.Character then
                    local hum=targetPlayer.Character:FindFirstChildOfClass("Humanoid")
                    local cam=Workspace.CurrentCamera
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
    }

    for i,def in ipairs(gridDef) do
        local col=(i-1)%2; local row=math.floor((i-1)/2)
        local x=PX+col*(HALF+4); local y=Y3+row*(BH2+GAP)
        ToggleBtn(def[1],def[2],x,y,HALF,BH2,def[3])
    end

    local rows=math.ceil(#gridDef/2)
    local finalH=Y3+rows*(BH2+GAP)+GAP
    panel.Size=UDim2.new(0,PW,0,finalH)

    -- ================================================
    -- SEARCH LOGIC
    -- ================================================
    local lastNotifiedTarget = nil

    local function ProcessSearch(input)
        if #input == 0 then
            targetPlayer=nil
            return
        end
        if #input < 2 then return end

        local found=AutoSelect(input)
        if found and found~=targetPlayer then
            targetPlayer=found
            HookTargetCharacterAdded(targetPlayer)
            currentStatus="Alive"; previousStatus="Alive"
            showNotif("Target: "..found.DisplayName,"target")
            lastNotifiedTarget=found
            RefreshNameESP()
            if active then
                StopChase()
                task.wait(0.05)
                StartChase()
            end
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

    -- !RE
    ireBtn.MouseButton1Click:Connect(SendReChat)

    -- BANANA TOGGLE
    local bananaState=false
    bananaBtn.MouseButton1Click:Connect(function()
        if not bananaState and not targetPlayer then
            showNotif("No target selected!","warn")
            return
        end
        bananaState=not bananaState
        bananaBtn.BackgroundColor3=bananaState and CLR_ON or CLR_OFF
        bananaBtn.Text=bananaState and "BANANA: ON" or "BANANA: OFF"
        wantsActive=bananaState
        if bananaState then StartChase() else StopChase() end
    end)

    -- BLACKHOLE TOGGLE
    local bhState=false
    bhBtn.MouseButton1Click:Connect(function()
        if not bhState and not targetPlayer then
            showNotif("No target selected!","warn")
            return
        end
        bhState=not bhState
        blackHoleActive=bhState
        bhBtn.BackgroundColor3=bhState and CLR_BH or CLR_OFF
        bhBtn.Text=bhState and "BH: ON" or "BH: OFF"
        if bhState then
            showNotif("Blackhole ON","on")
            SyncBlackholeBananas()
        else
            AnchorPart.CFrame=CFrame.new(0,-9999,0)
            targetPos=Vector3.new(0,-9999,0)
            for banana, _ in pairs(bhBananaData) do
                UnregisterBananaFromBH(banana)
            end
            bhBananaData = {}
            showNotif("Blackhole OFF","off")
        end
    end)

    -- Player hooks untuk Name ESP
    Players.PlayerAdded:Connect(function(plr)
        plr.CharacterAdded:Connect(function()
            task.wait(0.5)
            AddNameESPFor(plr)
        end)
    end)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            plr.CharacterAdded:Connect(function()
                task.wait(0.5)
                AddNameESPFor(plr)
            end)
        end
    end

    Players.PlayerRemoving:Connect(function(plr)
        if targetPlayer==plr then
            targetPlayer=nil
            StopChase()
            if blackHoleActive then
                blackHoleActive=false; bhState=false
                bhBtn.BackgroundColor3=CLR_OFF; bhBtn.Text="BH: OFF"
                AnchorPart.CFrame=CFrame.new(0,-9999,0)
                targetPos=Vector3.new(0,-9999,0)
                for banana, _ in pairs(bhBananaData) do
                    UnregisterBananaFromBH(banana)
                end
                bhBananaData = {}
            end
        end
        if lastNotifiedTarget==plr then lastNotifiedTarget=nil end
        RemoveNameESPFor(plr)
        if isSpectating and targetPlayer==nil then StopViewTarget() end
    end)

end

ShowKeyGate(MainScript)