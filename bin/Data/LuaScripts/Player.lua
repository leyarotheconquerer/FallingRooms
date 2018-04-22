Player = ScriptObject()

Player.Acceleration = 5
Player.MaxVelocity = 15
Player.TurnRate = .2

function Player:HandleKeyDown(type, data)
	local keyCode = data.Key:GetInt()
end

function Player:Start()
	self:SubscribeToEvent("KeyDown", "Player:HandleKeyDown")
	self:SubscribeToEvent("PostRenderUpdate", "Player:HandlePostRenderUpdate")
end

function Player:FixedUpdate()
	local rigidBody = self.node:GetComponent("RigidBody")
	local force = Vector3(0.0, 0.0, 0.0)

	if (input:GetKeyDown(KEY_UP)) then
		force = force + Vector3(0.0, 0.0, 1.0)
	elseif (input:GetKeyDown(KEY_DOWN)) then
		force = force + Vector3(0.0, 0.0, -1.0)
	end

	if (input:GetKeyDown(KEY_LEFT)) then
		force = force + Vector3(-1.0, 0.0, 0.0)
	elseif (input:GetKeyDown(KEY_RIGHT)) then
		force = force + Vector3(1.0, 0.0, 0.0)
	end

	if (force:LengthSquared() > 0) then
		rotation = Quaternion()
		rotation:FromRotationTo(Vector3.FORWARD, force)
		rigidBody.rotation = rigidBody.rotation:Slerp(rotation, self.TurnRate)

	end

	if (
		rigidBody ~= nil
		and force:LengthSquared() > 0
		and rigidBody:GetLinearVelocity():LengthSquared() < self.MaxVelocity
	) then
		rigidBody:ApplyForce(force:Normalized() * self.Acceleration)
	end
end

function Player:Stop()
end

function Player:HandlePostRenderUpdate(type, data)
	self.node.scene:GetComponent("PhysicsWorld"):DrawDebugGeometry(true)
end
