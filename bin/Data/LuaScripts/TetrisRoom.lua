require("LuaScripts/TetrisConf")

TetrisRoom = ScriptObject()

function TetrisRoom:Start()
	self.direction = 0
end

function TetrisRoom:DelayedStart()
	self:GenerateStart()
	local rigidBody = self.node:GetComponent("RigidBody")
	if (rigidBody ~= nil) then
		rigidBody:SetLinearVelocity(TetrisConf.Direction * TetrisConf.MovementRate)
	else
		log:Write(LOG_DEBUG, "Not can has rigid body")
	end

	local detectorNode = self.node:GetChild("Detector")
	if (detectorNode ~= nil) then
		self:SubscribeToEvent(detectorNode, "NodeCollisionStart", "TetrisRoom:HandleNodeCollisionStart")
	end

	self:SubscribeToEvent("KeyDown", "TetrisRoom:HandleKeyDown")
	self:SubscribeToEvent("PostRenderUpdate", "TetrisRoom:HandlePostRenderUpdate")
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
	local rigidBody = self.node:GetComponent("RigidBody")
	if (keyCode == KEY_W and rigidBody ~= nil) then
		self:Rotate((self.direction + 1) % 4)
	elseif (keyCode == KEY_A and rigidBody ~= nil) then
		log:Write(LOG_DEBUG, string.format("X from %d to %d", rigidBody.position.x, bound.x))
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
	elseif (keyCode == KEY_S) then
		log:Write(LOG_DEBUG, "Implement the down movement, eh?")
	end
end

function TetrisRoom:HandlePostRenderUpdate(type, data)
	log.Write(LOG_DEBUG, "Head")
	local physicsWorld = self.node.scene:GetComponent("PhysicsWorld")
	if (physicsWorld ~= nil) then
		log.Write(LOG_DEBUG, "Noggin")
		physicsWorld:DrawDebugGeometry(true)
		log.Write(LOG_DEBUG, "Dudez...")
	end
end

function TetrisRoom:HandleNodeCollisionStart(type, data)
	local otherNode = data.OtherNode:Get("Node")
	log:Write(LOG_DEBUG, string.format("Detector collision with %s", otherNode.name))
	if (otherNode.name == "Detector") then
		log:Write(LOG_DEBUG, "Detector collision")
	end
end

function TetrisRoom:GenerateStart()
	local rigidBody = self.node:GetComponent("RigidBody")
	local boundNode = self.node:GetChild("Bound", true)

	if (rigidBody ~= nil and boundNode ~= nil) then
		local buffer = TetrisConf.Buffer
		if (boundNode ~= nil) then
			buffer = boundNode.position.x / TetrisConf.Interval
		end
		local x = RandomInt(
			TetrisConf.Left + buffer,
			(TetrisConf.Right) / TetrisConf.Interval - buffer
		) * TetrisConf.Interval
		local y = TetrisConf.Top - buffer * TetrisConf.Interval

		local direction = RandomInt(0, 3)
		self:Rotate(direction)
		rigidBody:SetPosition(Vector3(x, 0, y))
	end
end

function TetrisRoom:Rotate(direction)
	local rigidBody = self.node:GetComponent("RigidBody")
	local boundNode = self.node:GetChild("Bound", true)
	log:Write(LOG_DEBUG, string.format("Rotating from %d to %d", self.direction, direction))

	if (rigidBody ~= nil and boundNode ~= nil) then
		local maxDim = AbsInt(boundNode.position.x)
		if (maxDim < AbsInt(boundNode.position.z)) then
			maxDim = AbsInt(boundNode.position.z)
		end

		local rotation = Quaternion()
		local position = rigidBody.position

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
	end
end