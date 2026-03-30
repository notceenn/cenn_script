-- Copy Avatar Script - Rayfield UI + Live Search
-- By Only Gataa

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local BloxbizRemotes = RS:WaitForChild("BloxbizRemotes")
local ApplyOutfit = BloxbizRemotes:WaitForChild("CatalogOnApplyOutfit")

-- Load Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Copy Avatar  |  By Only Gataa",
    LoadingTitle = "Copy Avatar",
    LoadingSubtitle = "By Only Gataa",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false,
})

local Tab = Window:CreateTab("👤 Copy Avatar", 4483362458)

-- State
local selectedPlayer = nil
local searchResults = {}

-- =====================
-- Helper
-- =====================
local function getPlayerNames()
    local list = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(list, p.Name)
        end
    end
    return list
end

local function searchPlayers(query)
    local results = {}
    query = query:lower()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Name:lower():find(query, 1, true) then
            table.insert(results, p.Name)
        end
    end
    return results
end

local function copyAvatar(target)
    if not target then
        Rayfield:Notify({ Title = "❌ Error", Content = "Pemain tidak ditemukan!", Duration = 3, Image = 4483362458 })
        return
    end

    local char = target.Character
    if not char then
        Rayfield:Notify({ Title = "❌ Error", Content = "Karakter " .. target.Name .. " tidak ditemukan!", Duration = 3, Image = 4483362458 })
        return
    end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local ok, d = pcall(function() return hum:GetAppliedDescription() end)
    if not ok or not d then
        Rayfield:Notify({ Title = "❌ Error", Content = "Gagal ambil data avatar!", Duration = 3, Image = 4483362458 })
        return
    end

    local accsData = {}
    local ok2, accs = pcall(function() return d:GetAccessories(true) end)
    if ok2 and accs then
        for _, acc in pairs(accs) do
            if acc.Order == nil then
                table.insert(accsData, {
                    AssetId = acc.AssetId,
                    AccessoryType = acc.AccessoryType,
                    IsLayered = false,
                    Position = vector.zero,
                    Rotation = vector.zero,
                    Scale = vector.one,
                    Puffiness = 0,
                })
            else
                table.insert(accsData, {
                    AssetId = acc.AssetId,
                    AccessoryType = acc.AccessoryType,
                    IsLayered = true,
                    Position = vector.zero,
                    Rotation = vector.zero,
                    Scale = vector.one,
                    Order = acc.Order,
                    Puffiness = acc.Puffiness or 0,
                })
            end
        end
    end

    local fireOk, fireErr = pcall(function()
        ApplyOutfit:FireServer({
            Head = d.Head, Torso = d.Torso,
            LeftArm = d.LeftArm, RightArm = d.RightArm,
            LeftLeg = d.LeftLeg, RightLeg = d.RightLeg,
            Shirt = d.Shirt, Pants = d.Pants,
            GraphicTShirt = d.GraphicTShirt, Face = d.Face,
            HeadColor = d.HeadColor, TorsoColor = d.TorsoColor,
            LeftArmColor = d.LeftArmColor, RightArmColor = d.RightArmColor,
            LeftLegColor = d.LeftLegColor, RightLegColor = d.RightLegColor,
            HeadScale = d.HeadScale, HeightScale = d.HeightScale,
            WidthScale = d.WidthScale, BodyTypeScale = d.BodyTypeScale,
            DepthScale = d.DepthScale, ProportionScale = d.ProportionScale,
            IdleAnimation = d.IdleAnimation, RunAnimation = d.RunAnimation,
            WalkAnimation = d.WalkAnimation, JumpAnimation = d.JumpAnimation,
            ClimbAnimation = d.ClimbAnimation, SwimAnimation = d.SwimAnimation,
            FallAnimation = d.FallAnimation, MoodAnimation = d.MoodAnimation,
            Accessories = accsData,
        })
    end)

    if fireOk then
        Rayfield:Notify({
            Title = "✅ Berhasil!",
            Content = "Avatar " .. target.Name .. " dicopy! (" .. #accsData .. " accessories)",
            Duration = 4,
            Image = 4483362458,
        })
    else
        Rayfield:Notify({
            Title = "❌ Gagal",
            Content = tostring(fireErr),
            Duration = 4,
            Image = 4483362458,
        })
    end
end

-- =====================
-- UI Sections
-- =====================

Tab:CreateSection("🔍 Cari Pemain")

-- Search input — live update dropdown hasil
local resultDropdown
local lastSearch = ""

Tab:CreateInput({
    Name = "Search Username",
    PlaceholderText = "Ketik nama pemain...",
    RemoveTextAfterFocusLost = false,
    Callback = function(value)
        lastSearch = value
        local results = searchPlayers(value)
        searchResults = results

        if #results == 0 then
            resultDropdown:Set("Tidak ada hasil")
            resultDropdown:Refresh({"Tidak ada hasil"}, true)
        else
            resultDropdown:Refresh(results, true)
            resultDropdown:Set(results[1])
            selectedPlayer = Players:FindFirstChild(results[1])
        end
    end,
})

-- Dropdown hasil search
resultDropdown = Tab:CreateDropdown({
    Name = "📋 Hasil Pencarian",
    Options = getPlayerNames(),
    CurrentOption = {getPlayerNames()[1] or ""},
    MultipleOptions = false,
    Flag = "SearchResult",
    Callback = function(value)
        local name = type(value) == "table" and value[1] or value
        selectedPlayer = Players:FindFirstChild(name)
        if selectedPlayer then
            Rayfield:Notify({
                Title = "Dipilih",
                Content = "✔ " .. name,
                Duration = 2,
                Image = 4483362458,
            })
        end
    end,
})

Tab:CreateSection("⚙️ Actions")

-- Refresh semua pemain
Tab:CreateButton({
    Name = "🔄 Refresh Daftar Pemain",
    Callback = function()
        local list = getPlayerNames()
        resultDropdown:Refresh(list, true)
        if #list > 0 then
            resultDropdown:Set(list[1])
            selectedPlayer = Players:FindFirstChild(list[1])
        end
        Rayfield:Notify({
            Title = "🔄 Refresh",
            Content = #list .. " pemain ditemukan di server",
            Duration = 2,
            Image = 4483362458,
        })
    end,
})

-- Tombol copy
Tab:CreateButton({
    Name = "✅ Copy Avatar",
    Callback = function()
        if not selectedPlayer then
            Rayfield:Notify({
                Title = "❌ Belum Pilih",
                Content = "Cari dan pilih pemain dulu!",
                Duration = 3,
                Image = 4483362458,
            })
            return
        end
        copyAvatar(selectedPlayer)
    end,
})

-- Auto update saat pemain join/keluar
Players.PlayerAdded:Connect(function()
    task.wait(1)
    local list = getPlayerNames()
    if lastSearch == "" then
        resultDropdown:Refresh(list, true)
    end
end)

Players.PlayerRemoving:Connect(function(p)
    task.wait(0.5)
    if selectedPlayer and selectedPlayer == p then
        selectedPlayer = nil
    end
    local list = getPlayerNames()
    if lastSearch == "" then
        resultDropdown:Refresh(list, true)
    end
end)

-- Init dropdown dengan semua pemain
local initList = getPlayerNames()
if #initList > 0 then
    selectedPlayer = Players:FindFirstChild(initList[1])
end

print("✅ Copy Avatar By Only Gataa loaded!")
