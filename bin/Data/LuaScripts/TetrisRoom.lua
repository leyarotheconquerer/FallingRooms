require("LuaScripts/TetrisConf")

TetrisRoom = ScriptObject()

function TetrisRoom:Start()
	self.direction = 0
	self.spawnCount = -1
end

function TetrisRoom:DelayedStart()
	self:GenerateStart()
	local physicalNode = self.node:GetChild("Physical")
	local rigidBody = self:GetRigidBody()
	if (rigidBody ~= nil) then
		rigidBody:SetLinearVelocity(TetrisConf.Direction * TetrisConf.MovementRate)
	else
		log:Write(LOG_DEBUG, "Not can has rigid body")
	end

	local detectorNode = self.node:GetChild("Detector")
	if (detectorNode ~= nil) then
		log:Write("Registering for node collision starts")
		self:SubscribeToEvent(detectorNode, "NodeCollisionStart", "TetrisRoom:HandleNodeCollisionStart")
	end

	self:SubscribeToEvent("KeyDown", "TetrisRoom:HandleKeyDown")
	self:SubscribeToEvent("TerminateLevel", "TetrisRoom:HandleTerminateLevel")
end

function TetrisRoom:FixedUpdate()
	local detector = self.node:GetChild("Detector")
	if (detector ~= nil) then
		local rigidBody = detector:GetComponent("RigidBody")
		if (rigidBody ~= nil) then
			rigidBody:SetPosition(self.node.position)
			rigidBody:SetRotation(self.node.rotation)
			rigidBody:Activate()
		end
	end
	if (self.spawnCount > 0) then
		self.spawnCount = self.spawnCount - 1
	elseif (self.spawnCount == 0) then
		self.spawnCount = -1
		local terminator = self.node.scene:GetChild("Terminator", true)
		if (terminator ~= nil) then
			local terminatorBody = terminator:GetComponent("RigidBody")
			if (terminatorBody ~= nil) then
				terminatorBody:SetPosition(Vector3(TetrisConf.Left, 0.0, TetrisConf.Top + 1))
				TetrisConf.SpawnNewRoom(self.node.scene)
			end
		end
	end
end

function TetrisRoom:Stop()
end

function TetrisRoom:HandleKeyDown(type, data)
	local keyCode = data.Key:GetInt()
	local rotation = Quaternion()
	local boundNode = self.node:GetChild("Bound")
	local bound = Vector3(0, 0, 0)
	if (boundNode ~= nil) then
		bound = boundNode.worldPosition
	end
	local physicalNode = self.node:GetChild("Physical")
	local rigidBody = self:GetRigidBody()
	local soundSource = self.node:GetComponent("SoundSource")
	if (soundSource == nil) then
		soundSource = self.node:CreateComponent("SoundSource")
	end
	if (keyCode == KEY_W and rigidBody ~= nil) then
		soundSource:Play(cache:GetResource("Sound", "Sounds/Noise.wav"), 44100, .5)
		self:Rotate((self.direction + 1) % 4)
	elseif (keyCode == KEY_A and rigidBody ~= nil) then
		if (
			rigidBody.position.x >= TetrisConf.Left + TetrisConf.Interval
			and bound.x >= TetrisConf.Left + TetrisConf.Interval
		) then
			rigidBody:SetPosition(Vector3(
				rigidBody.position.x - TetrisConf.Interval,
				rigidBody.position.y,
				rigidBody.position.z
			))
		end
	elseif (keyCode == KEY_D and rigidBody ~= nil) then
		if (
			rigidBody.position.x <= TetrisConf.Right - TetrisConf.Interval
			and bound.x <= TetrisConf.Right - TetrisConf.Interval
		) then
			rigidBody:SetPosition(Vector3(
				rigidBody.position.x + TetrisConf.Interval,
				rigidBody.position.y,
				rigidBody.position.z
			))
		end
	elseif (keyCode == KEY_S and rigidBody ~= nil) then
		if (
			rigidBody.position.z >= TetrisConf.Interval
			and bound.z >= TetrisConf.Interval
		) then
			soundSource:Play(cache:GetResource("Sound", "Sounds/Falling.wav"))
			rigidBody:SetPosition(Vector3(
				rigidBody.position.x,
				rigidBody.position.y,
				rigidBody.position.z - TetrisConf.Interval
			))
		end
	end
end

function TetrisRoom:HandlePhysicsCollisionStart(type, data)
	local firstNode = data.NodeA:Get("Node")
	local secondNode = data.NodeB:Get("Node")
	log:Write(LOG_DEBUG, "Physics collision starting")
	if (firstNode ~= nil and secondNode ~= nil) then
		log:Write(LOG_DEBUG, string.format(
			"Collision between %s (%d) and %s (%d)",
			firstNode:GetName(),
			firstNode:GetID(),
			secondNode:GetName(),
			secondNode:GetID()
		))
	else
		log:Write(LOG_DEBUG, "Someone was null")
	end
end

function TetrisRoom:HandleNodeCollisionStart(type, data)
	local otherNode = data.OtherNode:Get("Node")
	local detector = self.node:GetChild("Detector")
	local rigidBody = self:GetRigidBody()
	if (otherNode.name == "Detector" and rigidBody ~= nil and detector ~= nil) then
		local detectorBody = detector:GetComponent("RigidBody")
		if (detectorBody ~= nil) then
			detectorBody:SetMass(0.0)
			rigidBody:SetLinearVelocity(Vector3.ZERO)
			rigidBody:SetPosition(Vector3(
				Round(rigidBody.position.x / 3) * 3,
				0,
				Round(rigidBody.position.z / 3) * 3
			))
			self:Disable()
			local terminator = self.node.scene:GetChild("Terminator", true)
			if (terminator ~= nil) then
				local terminatorBody = terminator:GetComponent("RigidBody")
				if (terminatorBody ~= nil) then
					log:Write(LOG_DEBUG, string.format("Setting position to %d", TetrisConf.Top))
					terminatorBody:SetPosition(Vector3(TetrisConf.Left, 0.0, TetrisConf.Top))
					terminatorBody:SetMass(1)
					local soundSource = self.node:CreateComponent("SoundSource")
					soundSource:Play(cache:GetResource("Sound", "Sounds/Bloop.wav"))
					self:SubscribeToEvent(terminator, "NodeCollisionStart", "TetrisRoom:HandleTerminatorCollision")
					self.spawnCount = TetrisConf.SpawnDelay
				end
			end
		end
	end
end

function TetrisRoom:HandleTerminatorCollision(type, data)
	log:Write(LOG_DEBUG, "Loss condition met")
	local otherNode = data.OtherNode:Get("Node")
	if (otherNode ~= nil) then
		log:Write(LOG_DEBUG, "Collided with " .. otherNode:GetName())
		local window = ui.root:CreateChild("Window")
		local style = cache:GetResource("XMLFile", "UI/UIStyle.xml")
		if (window ~= nil and style ~= nil) then
			window:SetStyle(style)
			window:LoadXML(cache:GetResourceFileName("UI/LossWindow.xml"))
			self:Disable()
			self:SubscribeToEvent("LoadLevel", "TetrisRoom:HandleLoadLevel")
			self.spawnCount = -1
		end
	end
end

function TetrisRoom:HandleTerminateLevel(type, data)
	self.spawnCount = -1
	self:Disable()
end

function TetrisRoom:HandleLoadLevel(type, data)
	local window = ui.root:GetChild("LossWindow")
	if (window ~= nil) then
		window:Remove()
	end
	self:UnsubscribeFromAllEvents()
end

function TetrisRoom:GetRigidBody()
	rigidBody = self.node:GetComponent("RigidBody")
	if (rigidBody ~= nil) then
		return rigidBody
	end
	return nil
end

function TetrisRoom:GenerateStart()
	local physicalNode = self.node:GetChild("Physical")
	local rigidBody = self:GetRigidBody("RigidBody")
	local boundNode = self.node:GetChild("Bound", true)

	if (rigidBody ~= nil and boundNode ~= nil) then
		local height = AbsInt(boundNode.position.z) / TetrisConf.Interval
		local width = AbsInt(boundNode.position.x) / TetrisConf.Interval
		local maxDim = height
		if (maxDim < width) then
			maxDim = width
		end
		local x = RandomInt(
			TetrisConf.Left,
			(TetrisConf.Right) / TetrisConf.Interval - maxDim
		) * TetrisConf.Interval
		local y = TetrisConf.Top - (maxDim) * TetrisConf.Interval

		log:Write(LOG_DEBUG, string.format("Generating between %d and %d by %d, chose %d, %d",
			TetrisConf.Left * TetrisConf.Interval,
			TetrisConf.Right - maxDim * TetrisConf.Interval,
			TetrisConf.Top - (maxDim + 1) * TetrisConf.Interval,
			x,
			y
		))

		local direction = RandomInt(0, 3)
		rigidBody:SetPosition(Vector3(x, 0, y))
		self:Rotate(direction)
	end
end

function TetrisRoom:Rotate(direction)
	local physicalNode = self.node:GetChild("Physical")
	local rigidBody = self:GetRigidBody()
	local boundNode = self.node:GetChild("Bound", true)

	if (rigidBody ~= nil and boundNode ~= nil) then
		local maxDim = AbsInt(boundNode.position.x)
		if (maxDim < AbsInt(boundNode.position.z)) then
			maxDim = AbsInt(boundNode.position.z)
		end

		local rotation = Quaternion()
		local position = rigidBody.position
		log:Write(LOG_DEBUG, string.format("Rotating from %d to %d, starting at pos %d, %d with a maxDim of %d",
			self.direction,
			direction,
			position.x,
			position.z,
			maxDim
		))

		if (direction == 0) then
			rotation:FromLookRotation(Vector3.FORWARD, Vector3.UP)
			position.x = position.x - maxDim
		elseif (direction == 1) then
			rotation:FromLookRotation(Vector3.RIGHT, Vector3.UP)
			position.z = position.z + maxDim
		elseif (direction == 2) then
			rotation:FromLookRotation(Vector3.BACK, Vector3.UP)
			position.x = position.x + maxDim
		elseif (direction == 3) then
			rotation:FromLookRotation(Vector3.LEFT, Vector3.UP)
			position.z = position.z - maxDim
		end
		rigidBody:SetRotation(rotation)
		rigidBody:SetPosition(position)
		self.direction = direction
		log:Write(LOG_DEBUG, string.format("Moved to pos %d, %d",
			position.x,
			position.z
		))
	end
end

function TetrisRoom:Disable()
	self:UnsubscribeFromAllEvents()
	local rigidBody = self:GetRigidBody()
	if (rigidBody ~= nil) then
		rigidBody:SetLinearVelocity(Vector3.ZERO)
		rigidBody:SetTrigger(true)
	end
end