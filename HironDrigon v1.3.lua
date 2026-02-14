local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "HironDrigon Team",
    Icon = "home",
    Author = "by medr0so_0",
    Folder = "MySuperHub",
    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            print("User clicked!")
        end,
    },
})

local MainTab = Window:Tab({ 
    Title = "Principal", 
    Icon = "home" 
})

-- BOTÃO 1 - HironDrigon Natural Disaster
MainTab:Button({
    Title = "HironDrigon Natural Disaster",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/losaztecas859-commits/HironDrigonHub-Medr0so_0Owner-NaturalDisaster-Arthurfelipe_blox2Moderator/main/HironDrigonHub.OwnerMedroso_0.ModeratorAndTesterArthurfelipe_blox2"))()
    end
})

-- BOTÃO 2 - HironDrigon Brookhaven
MainTab:Button({
    Title = "HironDrigon Brookhaven",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/nombrehumilde-cyber/HironDrigon/refs/heads/main/HironDrigon%20v1.2%20Desofuscado"))()
    end
})

-- BOTÃO 3 - Rejoin
MainTab:Button({
    Title = "Rejoin",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})

WindUI:Notify({
    Title = "WindUI carregado!",
    Content = "Escolha uma versão do HironDrigon",
    Duration = 6,
    Image = "success"
})