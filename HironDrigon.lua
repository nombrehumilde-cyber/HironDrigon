-- === SISTEMA DE COMANDOS AUXILIAR ===
local Camera = Workspace.CurrentCamera
local Commands = {}

local function GetPlayer(name)
	name = name:lower()
	for _,plr in pairs(Players:GetPlayers()) do
		if plr.Name:lower():sub(1,#name) == name then
			return plr
		end
	end
end

local function Notify(title, text)
	warn(title .. ": " .. text)
end

-- === VIEW FUNCIONAL ===
Commands["view"] = function(targetName)
	local target = GetPlayer(targetName)
	if not target or not target.Character then
		Notify("View", "Player inválido")
		return
	end
	local hum = target.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		Camera.CameraSubject = hum
	end
end

Commands["unview"] = function()
	local char = LocalPlayer.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			Camera.CameraSubject = hum
		end
	end
end

-- === GOTO FUNCIONAL ===
Commands["goto"] = function(targetName)
	local target = GetPlayer(targetName)
	if not target then
		Notify("Goto", "Player não encontrado")
		return
	end
	local char = LocalPlayer.Character
	local tchar = target.Character
	if char and tchar and char:FindFirstChild("HumanoidRootPart") and tchar:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = tchar.HumanoidRootPart.CFrame * CFrame.new(0,0,-3)
	end
end

-- === INFINITE JUMP REAL ===
local UIS = game:GetService("UserInputService")
UIS.JumpRequest:Connect(function()
	if InfiniteJump then
		local char = LocalPlayer.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				hum:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	end
end)

Commands["infinitejump"] = function()
	InfiniteJump = not InfiniteJump
	Notify("InfiniteJump", InfiniteJump and "ATIVADO" or "DESATIVADO")
end

-- === EXECUÇÃO DE COMANDOS ===
local function ExecuteCommand(text)
	local args = text:split(" ")
	local cmd = args[1]:lower()
	local char = LocalPlayer.Character
	local humanoid = char and char:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	if cmd == ";speed" and args[2] == "me" and args[3] then
		local speed = tonumber(args[3])
		if speed then humanoid.WalkSpeed = speed end

	elseif cmd == ";jumppower" and args[2] then
		humanoid.JumpPower = tonumber(args[2]) or 50

	elseif cmd == ";tptool" then
		local tool = Instance.new("Tool")
		tool.Name = "TPTool"
		tool.RequiresHandle = false
		tool.CanBeDropped = false
		tool.Parent = LocalPlayer.Backpack
		tool.Activated:Connect(function()
			local mouse = LocalPlayer:GetMouse()
			if char and char:FindFirstChild("HumanoidRootPart") then
				char.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0,3,0))
			end
		end)

	elseif cmd == ";music" and args[2] then
		local sound = Instance.new("Sound")
		sound.SoundId = "rbxassetid://" .. args[2]
		sound.Volume = 1
		sound.Looped = false
		sound.Parent = SoundService
		sound:Play()

	elseif cmd == ";emotes" then
		loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-7yd7-I-Emote-Script-48024"))()

	elseif cmd == ";fly" then
		loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-HD-Admin-Fly-60269"))()

	elseif cmd == ";bring" and args[2] then
		local target = GetPlayer(args[2])
		if target and target.Character and char and char:FindFirstChild("HumanoidRootPart") then
			target.Character.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame
		end

	elseif cmd == ";aviso" and args[2] then
		Commands["aviso"](table.concat({select(2, table.unpack(args))}, " "))

	elseif cmd == ";gravity" and args[2] then
		local num = tonumber(args[2])
		if num then
			Workspace.Gravity = num
			Notify("Gravity", "Gravidade definida para "..num)
		else
			Notify("Gravity", "Valor inválido")
		end

	elseif cmd == ";ungravity" then
		Workspace.Gravity = 196.2
		Notify("Gravity", "Gravidade restaurada para padrão")

	elseif Commands[cmd:sub(2)] then
		Commands[cmd:sub(2)](args[2])
	end
end

CommandBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		ExecuteCommand(CommandBox.Text)
		CommandBox.Text = ""
	end
end)-- === DRAG ===
TopBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		Dragging = true
		DragOffset = input.Position - MenuFrame.AbsolutePosition
	end
end)

TopBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		Dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		MenuFrame.Position = UDim2.new(0, input.Position.X - DragOffset.X, 0, input.Position.Y - DragOffset.Y)
	end
end)

-- === Fechar / Minimizar ===
CloseBtn.MouseButton1Click:Connect(function()
	MenuFrame.Visible = false
end)

MinimizeBtn.MouseButton1Click:Connect(function()
	BodyVisible = not BodyVisible
	BodyFrame.Visible = BodyVisible
end)

-- === Ball toggle flutuante ===
local Ball = Instance.new("TextButton")
Ball.Size = UDim2.new(0,40,0,40)
Ball.Position = UDim2.new(0,50,0,100)
Ball.Text = "cmd"
Ball.BackgroundColor3 = Color3.fromRGB(0,0,0)
Ball.BackgroundTransparency = 0.3
Ball.TextColor3 = Color3.fromRGB(255,255,255)
Ball.BorderSizePixel = 2
Ball.Parent = ScreenGui
Ball.ZIndex = 10

spawn(function()
	local direction = 1
	while true do
		local pos = Ball.Position
		local newY = pos.Y.Offset + direction
		if newY > 120 then direction = -1 end
		if newY < 80 then direction = 1 end
		Ball.Position = UDim2.new(pos.X.Scale,pos.X.Offset,pos.Y.Scale,newY)
		task.wait(0.02)
	end
end)

Ball.MouseButton1Click:Connect(function()
	MenuVisible = not MenuVisible
	MenuFrame.Visible = MenuVisible
end)

-- === Bordas pulsantes ===
spawn(function()
	local hue = 0
	while task.wait(0.02) do
		hue = (hue + 0.5) % 360
		Border.Color = Color3.fromHSV(0.6,0.8,0.5 + 0.5*math.sin(hue/180*math.pi))
	end
end)

-- === Quadrados de fundo ===
local Squares = {}
local MenuWidth = MenuFrame.Size.X.Offset
local MenuHeight = MenuFrame.Size.Y.Offset

for i=1,50 do
	local size = math.random(5,18)
	local sq = Instance.new("Frame")
	sq.Size = UDim2.new(0,size,0,size)
	sq.Position = UDim2.new(0, math.random(0, MenuWidth - size), 0, math.random(30, MenuHeight - size))
	sq.BackgroundColor3 = Color3.fromRGB(0,0,0)
	sq.BorderSizePixel = 0
	sq.Parent = MenuFrame
	table.insert(Squares, {frame = sq, speed = math.random(1,4), state = math.random() * 10})
end

RunService.RenderStepped:Connect(function()
	for _,sqData in ipairs(Squares) do
		local sq = sqData.frame
		sq.Position = UDim2.new(0, sq.Position.X.Offset, 0, sq.Position.Y.Offset + sqData.speed)
		if sq.Position.Y.Offset > MenuHeight then
			sq.Position = UDim2.new(0, math.random(0, MenuWidth - sq.Size.X.Offset), 0, 30)
		end
		sqData.state += 0.2
		local alpha = (math.sin(sqData.state * math.pi * 10) + 1)/2
		sq.BackgroundColor3 = Color3.fromRGB(0, 0, math.floor(255 * alpha))
	end
end)

-- === Noclip ===
RunService.Stepped:Connect(function()
	if Noclip then
		local char = LocalPlayer.Character
		if char then
			for _,part in pairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end
	end
end)

-- === COMANDO ;ESPECIAL ===
Commands["especial"] = function()
	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	-- Ativa noclip
	Noclip = true
	for _, part in pairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
		end
	end

	-- Spin ultra
	local spin = Instance.new("BodyAngularVelocity")
	spin.Name = "EspecialSpin"
	spin.AngularVelocity = Vector3.new(0, 999999, 0)
	spin.MaxTorque = Vector3.new(0, math.huge, 0)
	spin.Parent = hrp

	-- Teleporta para todos os players
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			hrp.CFrame = plr.Character.HumanoidRootPart.CFrame
			task.wait(0.1)
		end
	end

	-- Cancela depois de 10 segundos
	task.delay(10, function()
		if spin then spin:Destroy() end
		Noclip = false
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
		Notify("Especial", "Comando finalizado")
	end)
end

print("CMD-X FINAL COM ;ESPECIAL ADICIONADO")-- === COMANDO ;ESPECIAL ===
Commands["especial"] = function()
	local char = LocalPlayer.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	-- Ativa noclip
	Noclip = true
	for _, part in pairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
		end
	end

	-- Spin ultra
	local spin = Instance.new("BodyAngularVelocity")
	spin.Name = "EspecialSpin"
	spin.AngularVelocity = Vector3.new(0, 999999, 0)
	spin.MaxTorque = Vector3.new(0, math.huge, 0)
	spin.Parent = hrp

	-- Teleporta para cada player a cada 2 segundos
	local players = Players:GetPlayers()
	local index = 1
	local teleportLoop
	teleportLoop = task.spawn(function()
		while index <= #players do
			local plr = players[index]
			if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				hrp.CFrame = plr.Character.HumanoidRootPart.CFrame
			end
			index += 1
			task.wait(2) -- espera 2 segundos antes do próximo
		end
	end)

	-- Cancela depois de 10 segundos
	task.delay(10, function()
		if spin then spin:Destroy() end
		Noclip = false
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
		Notify("Especial", "Comando finalizado")
	end)
end
