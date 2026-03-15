-- NIGHTMARE HUB | ADMIN LOCAL COM CHAT SYNC

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
-- CHAT SYNC
--------------------------------------------------

local function SendCommand(cmd)
    pcall(function()
        local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
        if channel then
            channel:SendAsync(cmd)
        end
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
    if hum then
        hum.Health = 0
    end
end

local function Freeze(plr,state)
    local char = GetChar(plr)
    if not char then return end
    for _,v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Anchored = state
        end
    end
end

local function Jail(plr)
    if workspace:FindFirstChild("NightmareJail_"..plr.Name) then return end
    local hrp = GetHRP(plr)
    if not hrp then return end

    local folder = Instance.new("Folder",workspace)
    folder.Name = "NightmareJail_"..plr.Name

    local function part(size,pos)
        local p = Instance.new("Part")
        p.Size = size
        p.Position = pos
        p.Anchored = true
        p.CanCollide = true
        p.Parent = folder
    end

    local base = hrp.Position - Vector3.new(0,3,0)

    part(Vector3.new(12,1,12),base)
    part(Vector3.new(1,6,12),base+Vector3.new(6,3,0))
    part(Vector3.new(1,6,12),base+Vector3.new(-6,3,0))
    part(Vector3.new(12,6,1),base+Vector3.new(0,3,6))
    part(Vector3.new(12,6,1),base+Vector3.new(0,3,-6))
    part(Vector3.new(12,1,12),base+Vector3.new(0,6,0))

    hrp.CFrame = CFrame.new(base+Vector3.new(0,3,0))
end

local function UnJail(plr)
    local j = workspace:FindFirstChild("NightmareJail_"..plr.Name)
    if j then j:Destroy() end
end

local function Fling(plr)
    local hrp = GetHRP(plr)
    if not hrp then return end

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e9,1e9,1e9)
    bv.Velocity = Vector3.new(0,500000,0)
    bv.Parent = hrp

    task.delay(1,function()
        bv:Destroy()
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
-- CHAT LISTENER
--------------------------------------------------

TextChatService.MessageReceived:Connect(function(msg)

    local text = msg.Text
    if not text then return end

    local args = text:split(" ")
    local cmd = args[1]
    local name = args[2]

    if not name then return end

    local plr = Players:FindFirstChild(name)
    if not plr then return end

    if cmd == ";kill" then
        Kill(plr)

    elseif cmd == ";freeze" then
        Freeze(plr,true)

    elseif cmd == ";unfreeze" then
        Freeze(plr,false)

    elseif cmd == ";jail" then
        Jail(plr)

    elseif cmd == ";unjail" then
        UnJail(plr)

    elseif cmd == ";fling" then
        Fling(plr)

    elseif cmd == ";bring" then
        Bring(plr)
    end

end)

--------------------------------------------------
-- UI
--------------------------------------------------

local Window = WindUI:CreateWindow({
Title="Nightmare Hub | Admin",
Theme="Dark"
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
SendCommand(";kill "..Selected)
end
})

AdminTab:Button({
Title="Freeze",
Callback=function()
SendCommand(";freeze "..Selected)
end
})

AdminTab:Button({
Title="UnFreeze",
Callback=function()
SendCommand(";unfreeze "..Selected)
end
})

AdminTab:Button({
Title="Jail",
Callback=function()
SendCommand(";jail "..Selected)
end
})

AdminTab:Button({
Title="UnJail",
Callback=function()
SendCommand(";unjail "..Selected)
end
})

AdminTab:Button({
Title="Fling",
Callback=function()
SendCommand(";fling "..Selected)
end
})

AdminTab:Button({
Title="Bring",
Callback=function()
SendCommand(";bring "..Selected)
end
})