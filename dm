-- NIGHTMARE HUB | ADMIN LOCAL COM SYNC POR PLACA

repeat task.wait() until game:IsLoaded()

-- WindUI
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/download/1.6.61/main.lua"
))()

-- Serviços
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TextChatService = game:GetService("TextChatService")
local UIS = game:GetService("UserInputService")

--------------------------------------------------
-- BOARD REMOTE
--------------------------------------------------

local function SendBoardCommand(cmd)
    pcall(function()
        game.ReplicatedStorage.RE["1Schoo1lDr1yBoard1s"]:FireServer(
            "ReturningBoardName",
            workspace.WorkspaceCom["001_OfficeBuildings"].OfficeSigns.OfficeSign3.Count,
            cmd
        )
    end)
end

--------------------------------------------------
-- UTILS
--------------------------------------------------

local function GetChar(plr)
    return plr and (plr.Character or plr.CharacterAdded:Wait())
end

local function GetHRP(plr)
    local char = GetChar(plr)
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function GetHum(plr)
    local char = GetChar(plr)
    return char and char:FindFirstChildOfClass("Humanoid")
end

--------------------------------------------------
-- COMMANDS
--------------------------------------------------

local function Kill(plr)
    local hum = GetHum(plr)
    if hum then hum.Health = 0 end
end

local function Freeze(plr, state)
    local char = GetChar(plr)
    if not char then return end
    for _,v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Anchored = state
        end
    end
end

local function Jail(plr, mat, color, transparency)
    if not plr or workspace:FindFirstChild("NightmareJail_"..plr.Name) then return end
    local hrp = GetHRP(plr)
    if not hrp then return end

    local folder = Instance.new("Folder", workspace)
    folder.Name = "NightmareJail_"..plr.Name

    local function part(size, pos)
        local p = Instance.new("Part")
        p.Size = size
        p.Position = pos
        p.Anchored = true
        p.CanCollide = true
        p.Material = mat
        p.Color = color
        p.Transparency = transparency or 0
        p.Parent = folder
    end

    local basePos = hrp.Position - Vector3.new(0,3,0)

    part(Vector3.new(12,1,12), basePos)
    part(Vector3.new(1,6,12), basePos + Vector3.new(6,3,0))
    part(Vector3.new(1,6,12), basePos + Vector3.new(-6,3,0))
    part(Vector3.new(12,6,1), basePos + Vector3.new(0,3,6))
    part(Vector3.new(12,6,1), basePos + Vector3.new(0,3,-6))
    part(Vector3.new(12,1,12), basePos + Vector3.new(0,6,0))

    hrp.CFrame = CFrame.new(basePos + Vector3.new(0,3,0))
end

local function UnJail(plr)
    local j = workspace:FindFirstChild("NightmareJail_"..plr.Name)
    if j then j:Destroy() end
end

local function Ice(plr)
    Jail(plr, Enum.Material.Ice, Color3.fromRGB(170,220,255), 0.35)
    Freeze(plr, true)
end

local function UnIce(plr)
    UnJail(plr)
    Freeze(plr, false)
end

local function RocketMan(plr)
    local hrp = GetHRP(plr)
    if not hrp then return end
    for i=1,30 do
        hrp.AssemblyLinearVelocity = Vector3.new(0,120,0)
        task.wait(0.04)
    end
end

local function Fling(plr)
    local hrp = GetHRP(plr)
    local char = GetChar(plr)
    if not hrp or not char then return end

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e9,1e9,1e9)
    bv.Velocity = Vector3.new(0,500000,0)
    bv.Parent = hrp

    local ba = Instance.new("BodyAngularVelocity")
    ba.MaxTorque = Vector3.new(1e9,1e9,1e9)
    ba.AngularVelocity = Vector3.new(50,50,50)
    ba.Parent = hrp

    task.delay(1,function()
        bv:Destroy()
        ba:Destroy()
    end)
end

local function Bring(plr)
    local myHRP = GetHRP(LocalPlayer)
    local hrp = GetHRP(plr)
    if myHRP and hrp then
        hrp.CFrame = myHRP.CFrame * CFrame.new(0,0,5)
    end
end

--------------------------------------------------
-- BOARD LISTENER
--------------------------------------------------

task.spawn(function()

    local sign = workspace.WorkspaceCom["001_OfficeBuildings"]
        .OfficeSigns.OfficeSign3.SurfaceGui.TextLabel

    sign:GetPropertyChangedSignal("Text"):Connect(function()

        local msg = sign.Text
        local args = msg:split(" ")

        local plr = Players:FindFirstChild(args[2])
        if not plr then return end

        if args[1] == ";kill" then
            Kill(plr)

        elseif args[1] == ";freeze" then
            Freeze(plr,true)

        elseif args[1] == ";unfreeze" then
            Freeze(plr,false)

        elseif args[1] == ";jail" then
            Jail(plr, Enum.Material.Metal, Color3.new(0,0,0))

        elseif args[1] == ";unjail" then
            UnJail(plr)

        elseif args[1] == ";ice" then
            Ice(plr)

        elseif args[1] == ";unice" then
            UnIce(plr)

        elseif args[1] == ";rocketman" then
            RocketMan(plr)

        elseif args[1] == ";fling" then
            Fling(plr)

        elseif args[1] == ";bring" then
            Bring(plr)
        end

    end)

end)

--------------------------------------------------
-- UI
--------------------------------------------------

local Window = WindUI:CreateWindow({
    Title = "Nightmare Hub | Admin",
    Theme = "Dark"
})

local function PlayerList()
    local t={}
    for _,p in ipairs(Players:GetPlayers()) do
        table.insert(t,p.Name)
    end
    table.sort(t)
    return t
end

--------------------------------------------------
-- ADMIN TAB
--------------------------------------------------

local AdminTab = Window:Tab({Title="Admin Commands"})
local Selected = LocalPlayer.Name

local PlayerDropdown = AdminTab:Dropdown({
    Title="Player",
    Values=PlayerList(),
    Callback=function(v)
        Selected=v
    end
})

Players.PlayerAdded:Connect(function()
    PlayerDropdown:SetValues(PlayerList())
end)

Players.PlayerRemoving:Connect(function()
    PlayerDropdown:SetValues(PlayerList())
end)

--------------------------------------------------
-- BUTTONS
--------------------------------------------------

AdminTab:Button({
    Title="Kill",
    Callback=function()
        SendBoardCommand(";kill "..Selected)
    end
})

AdminTab:Button({
    Title="Freeze",
    Callback=function()
        SendBoardCommand(";freeze "..Selected)
    end
})

AdminTab:Button({
    Title="UnFreeze",
    Callback=function()
        SendBoardCommand(";unfreeze "..Selected)
    end
})

AdminTab:Button({
    Title="Jail",
    Callback=function()
        SendBoardCommand(";jail "..Selected)
    end
})

AdminTab:Button({
    Title="UnJail",
    Callback=function()
        SendBoardCommand(";unjail "..Selected)
    end
})

AdminTab:Button({
    Title="Ice",
    Callback=function()
        SendBoardCommand(";ice "..Selected)
    end
})

AdminTab:Button({
    Title="UnIce",
    Callback=function()
        SendBoardCommand(";unice "..Selected)
    end
})

AdminTab:Button({
    Title="RocketMan",
    Callback=function()
        SendBoardCommand(";rocketman "..Selected)
    end
})

AdminTab:Button({
    Title="Fling",
    Callback=function()
        SendBoardCommand(";fling "..Selected)
    end
})

AdminTab:Button({
    Title="Bring",
    Callback=function()
        SendBoardCommand(";bring "..Selected)
    end
})