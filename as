repeat task.wait() until game:IsLoaded()

-- SERVICES
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Channel = TextChatService.TextChannels:WaitForChild("RBXGeneral")

-- WINDUI LOADSTRING
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Cria um tema customizado
WindUI:AddTheme({
    Name = "CoquetteBlue",
    Accent = Color3.fromHex("#4B5DFF"),       -- azul principal dos highlights e botões
    Background = Color3.fromHex("#000000"),   -- cor base (o gradiente vai sobrepor)
    Outline = Color3.fromHex("#FFFFFF"),      -- bordas brancas
    Text = Color3.fromHex("#FFFFFF"),         -- textos brancos
    Placeholder = Color3.fromHex("#7a7a7a"), -- placeholder cinza
    Button = Color3.fromHex("#1f1f23"),       -- botões preto azulado
    Icon = Color3.fromHex("#a1a1aa"),         -- ícones cinza
})

-- Gradiente do fundo do menu
WindUI:Gradient({
    ["0"] = { Color = Color3.fromHex("#0D1A4F"), Transparency = 0 }, -- azul escuro topo
    ["100"] = { Color = Color3.fromHex("#1A1A1A"), Transparency = 0.1 }, -- preto levemente cinza embaixo
}, {
    Rotation = 90, -- vertical
})

-- CHAT SYNC
local function SendCommand(cmd)
	pcall(function()
		Channel:SendAsync(cmd)
	end)
end

-- PLAYER SYSTEM
local SelectedPlayer = LocalPlayer.Name
local function GetPlayers()
	local t = {}
	for _,p in pairs(Players:GetPlayers()) do
		table.insert(t,p.Name)
	end
	return t
end

local function GetPlayer(name)
	return Players:FindFirstChild(name)
end

-- GLOBAL LOOP FLAGS
_G.LoopKill = false
_G.LoopExplode = false
_G.LoopFling = false
_G.InfiniteJump = false
_G.Noclip = false

-- COMMANDS
local function Kill(plr)
	if plr.Character and plr.Character:FindFirstChild("Humanoid") then
		plr.Character.Humanoid.Health = 0
	end
end

local function Freeze(plr,state)
	if not plr.Character then return end
	for _,v in pairs(plr.Character:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Anchored = state
		end
	end
end

-- ICE
local function Ice(plr)
	if not plr.Character then return end
	local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	if workspace:FindFirstChild("Ice_"..plr.Name) then return end

	local folder = Instance.new("Folder")
	folder.Name = "Ice_"..plr.Name
	folder.Parent = workspace

	local center = hrp.Position
	local function wall(size,pos)
		local p = Instance.new("Part")
		p.Size = size
		p.Position = pos
		p.Anchored = true
		p.CanCollide = true
		p.Material = Enum.Material.SmoothPlastic
		p.Color = Color3.fromRGB(120,170,255)
		p.Transparency = 0.6
		p.Parent = folder
	end

	wall(Vector3.new(10,8,1),center+Vector3.new(0,2,5))
	wall(Vector3.new(10,8,1),center+Vector3.new(0,2,-5))
	wall(Vector3.new(1,8,10),center+Vector3.new(5,2,0))
	wall(Vector3.new(1,8,10),center+Vector3.new(-5,2,0))

	Freeze(plr,true)
end

local function UnIce(plr)
	local f = workspace:FindFirstChild("Ice_"..plr.Name)
	if f then
		Freeze(plr,false)
		f:Destroy()
	end
end

-- JAIL
local function Jail(plr)
	if not plr.Character then return end
	local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	if workspace:FindFirstChild("Jail_"..plr.Name) then return end

	local folder = Instance.new("Folder")
	folder.Name = "Jail_"..plr.Name
	folder.Parent = workspace

	local center = hrp.Position
	local function part(size,pos,color,transparency)
		local p = Instance.new("Part")
		p.Size = size
		p.Position = pos
		p.Anchored = true
		p.CanCollide = true
		p.Color = color
		p.Transparency = transparency
		p.Parent = folder
		p.Touched:Connect(function(hit)
			if hit.Parent == plr.Character then
				hrp.CFrame = CFrame.new(center + Vector3.new(0,3,0))
			end
		end)
	end

	-- Chão e teto preto semi-transparente
	part(Vector3.new(14,1,14),center-Vector3.new(0,3,0),Color3.new(0,0,0),0.6)
	part(Vector3.new(14,1,14),center+Vector3.new(0,7,0),Color3.new(0,0,0),0.6)
	-- Paredes transparentes azul
	part(Vector3.new(1,8,14),center+Vector3.new(7,2,0),Color3.fromRGB(0,170,255),0.6)
	part(Vector3.new(1,8,14),center+Vector3.new(-7,2,0),Color3.fromRGB(0,170,255),0.6)
	part(Vector3.new(14,8,1),center+Vector3.new(0,2,7),Color3.fromRGB(0,170,255),0.6)
	part(Vector3.new(14,8,1),center+Vector3.new(0,2,-7),Color3.fromRGB(0,170,255),0.6)

	hrp.CFrame = CFrame.new(center + Vector3.new(0,3,0))
end

local function UnJail(plr)
	local f = workspace:FindFirstChild("Jail_"..plr.Name)
	if f then f:Destroy() end
end

-- FLING
local function Fling(plr)
	if plr ~= LocalPlayer then return end
	local char = plr.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then return end

	hum.WalkSpeed = 99999999
	task.spawn(function()
		while hum.Health > 0 do
			hrp.Velocity = Vector3.new(0,999999,0)
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
			task.wait()
		end
	end)
end

-- BRING
local function Bring(plr)
	local lpHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local targetHRP = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
	if lpHRP and targetHRP then
		targetHRP.CFrame = lpHRP.CFrame * CFrame.new(0,0,5)
	end
end

-- EXPLODE
local function Explode(plr)
	local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		local e = Instance.new("Explosion")
		e.Position = hrp.Position
		e.Parent = workspace
	end
end

-- LOOP EXPLODE
local function LoopExplode(plr)
	_G.LoopExplode = true
	task.spawn(function()
		while _G.LoopExplode do
			Explode(plr)
			task.wait(1)
		end
	end)
end
local function UnLoopExplode()
	_G.LoopExplode = false
end

-- LOOP KILL
local function LoopKill(plr)
	_G.LoopKill = true
	task.spawn(function()
		while _G.LoopKill do
			Kill(plr)
			task.wait(0.5)
		end
	end)
end
local function UnLoopKill()
	_G.LoopKill = false
end

-- CHAT LISTENER
Channel.MessageReceived:Connect(function(msg)
	local text = msg.Text
	if not text then return end
	local args = string.split(text," ")
	local cmd = args[1]
	local name = args[2]
	if not name then return end
	local plr = GetPlayer(name)
	if not plr then return end

	if cmd == ";kill" then Kill(plr)
	elseif cmd == ";loopkill" then LoopKill(plr)
	elseif cmd == ";unloopkill" then UnLoopKill()
	elseif cmd == ";freeze" then Freeze(plr,true)
	elseif cmd == ";unfreeze" then Freeze(plr,false)
	elseif cmd == ";jail" then Jail(plr)
	elseif cmd == ";unjail" then UnJail(plr)
	elseif cmd == ";ice" then Ice(plr)
	elseif cmd == ";unice" then UnIce(plr)
	elseif cmd == ";fling" then Fling(plr)
	elseif cmd == ";bring" then Bring(plr)
	elseif cmd == ";explode" then Explode(plr)
	elseif cmd == ";loopexplode" then LoopExplode(plr)
	elseif cmd == ";unloopexplode" then UnLoopExplode()
	elseif cmd == ";controlchat" then
		local message = table.concat(args," ",3)
		if plr == LocalPlayer then
			Channel:SendAsync(message)
		end
	elseif cmd == ";uncontrolchat" then
		-- apenas placeholder para parar controle
	end
end)

-- UI
local Window = WindUI:CreateWindow({
	Title = "Coquette Hub Style",
	Icon = "shield",
	Author = "by Otavio",
	Folder = "MySuperHub",
	Size = UDim2.fromOffset(580,460),
	MinSize = Vector2.new(560,350),
	MaxSize = Vector2.new(850,560),
	Transparent = true,
	Theme = "CoquetteBlue",
	Resizable = true,
	SideBarWidth = 200,
	BackgroundImageTransparency = 0.42,
	HideSearchBar = true,
	ScrollBarEnabled = false,
	User = {Enabled = true, Anonymous = false}
})

-- SCRIPTS TAB
local ScriptsTab = Window:Tab({Title="Scripts"})
local Dropdown = ScriptsTab:Dropdown({
	Title="Selecionar Player",
	Values=GetPlayers(),
	Callback=function(v) SelectedPlayer=v end
})
Players.PlayerAdded:Connect(function() Dropdown:Refresh(GetPlayers()) end)
Players.PlayerRemoving:Connect(function() Dropdown:Refresh(GetPlayers()) end)

-- BUTTONS
ScriptsTab:Button({Title="Kill", Callback=function() SendCommand(";kill "..SelectedPlayer) end})
ScriptsTab:Button({Title="LoopKill", Callback=function() SendCommand(";loopkill "..SelectedPlayer) end})
ScriptsTab:Button({Title="UnLoopKill", Callback=function() SendCommand(";unloopkill "..SelectedPlayer) end})
ScriptsTab:Button({Title="Freeze", Callback=function() SendCommand(";freeze "..SelectedPlayer) end})
ScriptsTab:Button({Title="UnFreeze", Callback=function() SendCommand(";unfreeze "..SelectedPlayer) end})
ScriptsTab:Button({Title="Jail", Callback=function() SendCommand(";jail "..SelectedPlayer) end})
ScriptsTab:Button({Title="UnJail", Callback=function() SendCommand(";unjail "..SelectedPlayer) end})
ScriptsTab:Button({Title="Ice", Callback=function() SendCommand(";ice "..SelectedPlayer) end})
ScriptsTab:Button({Title="UnIce", Callback=function() SendCommand(";unice "..SelectedPlayer) end})
ScriptsTab:Button({Title="Fling", Callback=function() SendCommand(";fling "..SelectedPlayer) end})
ScriptsTab:Button({Title="Bring", Callback=function() SendCommand(";bring "..SelectedPlayer) end})
ScriptsTab:Button({Title="Explode", Callback=function() SendCommand(";explode "..SelectedPlayer) end})
ScriptsTab:Button({Title="LoopExplode", Callback=function() SendCommand(";loopexplode "..SelectedPlayer) end})
ScriptsTab:Button({Title="UnLoopExplode", Callback=function() SendCommand(";unloopexplode "..SelectedPlayer) end})

-- LOCAL PLAYER
local LP = Window:Tab({Title="LocalPlayer"})
LP:Input({Title="Speed",Callback=function(v) local n=tonumber(v) if n and LocalPlayer.Character then LocalPlayer.Character.Humanoid.WalkSpeed=n end end})
LP:Input({Title="JumpPower",Callback=function(v) local n=tonumber(v) if n and LocalPlayer.Character then LocalPlayer.Character.Humanoid.JumpPower=n end end})
LP:Toggle({Title="InfiniteJump",Callback=function(v) _G.InfiniteJump=v end})
UIS.JumpRequest:Connect(function() if _G.InfiniteJump and LocalPlayer.Character then LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end end)

-- CONTROL TAB
local ControlTab = Window:Tab({Title="Control"})

local ControlPlayer = SelectedPlayer

local ControlDropdown = ControlTab:Dropdown({
	Title = "Selecionar Player",
	Values = GetPlayers(),
	Callback = function(v)
		ControlPlayer = v
	end
})

Players.PlayerAdded:Connect(function()
	ControlDropdown:Refresh(GetPlayers())
end)

Players.PlayerRemoving:Connect(function()
	ControlDropdown:Refresh(GetPlayers())
end)

-- Control Chat Textbox
ControlTab:Input({
	Title = "ControlChat",
	Placeholder = "Mensagem que o player vai falar",
	Callback = function(msg)
		if msg and msg ~= "" then
			SendCommand(";controlchat "..ControlPlayer.." "..msg)
		end
	end
})

-- UnControlChat
ControlTab:Button({
	Title = "UnControlChat",
	Callback = function()
		SendCommand(";uncontrolchat "..ControlPlayer)
	end
})

-- NOTIFY
WindUI:Notify({Title="Coquette Hub",Content="Admin Sync Ativo",Duration=5})