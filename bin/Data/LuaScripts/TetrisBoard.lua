require('LuaScripts/TetrisConf')
TetrisBoard = ScriptObject()

TetrisBoard.Left = 0
TetrisBoard.Right = 36
TetrisBoard.Top = 36
TetrisBoard.State = "Welcome"

function TetrisBoard:Start()
	log:Write(LOG_DEBUG, "Starting board level")

	local window = ui.root:CreateChild("Window")
	local style = cache:GetResource("XMLFile", "UI/UIStyle.xml")
	window:SetStyle(style)
	window:LoadXML(cache:GetResourceFileName("UI/WelcomeWindow.xml"))
	TetrisBoard.State = "Welcome"
	self:SubscribeToEvent("KeyDown", "TetrisBoard:HandleKeyDown")
	self:SubscribeToEvent("LoadLevel", "TetrisBoard:HandleLoadLevel")
end

function TetrisBoard:DelayedStart()
	log:Write(LOG_DEBUG, "Delayed starting board level")
	playerSpawn = self.node.scene:GetChild("PlayerSpawn", true)
	if (playerSpawn ~= nil) then
		player = self.node.scene:InstantiateXML(
			cache:GetResourceFileName("Objects/Player.xml"),
			playerSpawn.position,
			playerSpawn.rotation
		)
	else
		log:Write(LOG_DEBUG, "Couldn't find player spawn")
	end

end

function TetrisBoard:Stop()
end

function TetrisBoard:HandleKeyDown(type, data)
	local keyCode = data.Key:GetInt()
	if (keyCode == KEY_RETURN) then
		local window = self:GetWindow()
		log:Write(LOG_DEBUG, string.format("State %s %d", TetrisBoard.State, self.node:GetID()))
		if (window ~= nil and TetrisBoard.State == "Welcome") then
			log:Write(LOG_DEBUG, "Transitioning to second window")
			window:RemoveAllChildren()
			window:LoadXML(cache:GetResourceFileName("UI/SecondWindow.xml"))
			TetrisBoard.State = "Second"
		elseif (window ~= nil) then
			log:Write(LOG_DEBUG, "Spawning new room")
			TetrisConf.SpawnNewRoom(self.node.scene)
			window:Remove()
		else
			log:Write(LOG_DEBUG, "Window is nil")
		end
	end
end

function TetrisBoard:HandleLoadLevel(type, data)
	local window = self:GetWindow()
	if (window ~= nil) then
		window:Remove()
	end
	self:UnsubscribeFromAllEvents()
end

function TetrisBoard:GetWindow()
	if (TetrisBoard.State == "Welcome") then
		return ui.root:GetChild("WelcomeWindow")
	elseif (TetrisBoard.State == "Second") then
		return ui.root:GetChild("SecondWindow")
	else
		return nil
	end
end