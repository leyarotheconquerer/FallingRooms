Camera = ScriptObject()

function Camera:Start()
	self.TargetPosition = Vector3(18, 50, -8)
	self.Offset = Vector3(0, 8, -5)
	self.FollowRate = 0.01
	self.Mode = "Player"

	self:SubscribeToEvent("KeyDown", "Camera:HandleKeyDown")
end

function Camera:Update()
	local currentTarget = self.node.worldPosition
	local player = self.node.scene:GetChild("Player", true)
	if (player ~= nil) then
		-- if (input:GetKeyDown(KEY_SPACE)) then
		-- 	self.Mode = "Target"
		-- end
		if (self.Mode == "Target") then
			currentTarget = self.TargetPosition
		else
			currentTarget = player.worldPosition + self.Offset
		end
		self.node.worldPosition = self.node.worldPosition:Lerp(currentTarget, self.FollowRate)
	end
end

function Camera:Stop()
end

function Camera:HandleKeyDown(type, data)
	local keyCode = data.Key:GetInt()
	if (keyCode == KEY_SPACE) then
		if (self.Mode == "Target") then
			self.Mode = "Player"
		else
			self.Mode = "Target"
		end
	end
end