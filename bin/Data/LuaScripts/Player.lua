Player = ScriptObject()

Player.Acceleration = 5
Player.MaxVelocity = 15
Player.TurnRate = .2

function Player:HandleKeyDown(type, data)
	local keyCode = data.Key:GetInt()
end

function Player:Start()
	self.WalkSpeed = 1
	self.RunSpeed = 3
	self:SubscribeToEvent("KeyDown", "Player:HandleKeyDown")
	self:SubscribeToEvent("PostRenderUpdate", "Player:HandlePostRenderUpdate")
end

function Player:Update(timestep)
end

function Player:FixedUpdate(timestep)
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

	local animatedModel = self.node:GetComponent("AnimatedModel", true)
	if (rigidBody ~= nil and animatedModel ~= nil) then
		local runState = animatedModel:GetAnimationState("Animations/Player_Run.ani")
		local walkState = animatedModel:GetAnimationState("Animations/Player_Walk.ani")
		local idleState = animatedModel:GetAnimationState("Animations/Player_Idle.ani")
		if (runState ~= nil and walkState ~= nil and idleState ~= nil) then
			if (rigidBody:GetLinearVelocity():LengthSquared() >= self.RunSpeed) then
				walkState:SetWeight(Lerp(walkState:GetWeight(), 0.0, 0.1))
				idleState:SetWeight(Lerp(idleState:GetWeight(), 0.0, 0.1))
				runState:SetWeight(Lerp(runState:GetWeight(), 1.0, 0.1))
				runState:SetTime((runState:GetTime() + timestep * 2) % runState:GetLength())
			elseif (rigidBody:GetLinearVelocity():LengthSquared() >= self.WalkSpeed) then
				walkState:SetWeight(Lerp(walkState:GetWeight(), 1.0, 0.1))
				idleState:SetWeight(Lerp(idleState:GetWeight(), 0.0, 0.1))
				runState:SetWeight(Lerp(runState:GetWeight(), 0.0, 0.1))
				walkState:SetTime((walkState:GetTime() + timestep) % walkState:GetLength())
			else
				walkState:SetWeight(Lerp(walkState:GetWeight(), 0.0, 0.1))
				idleState:SetWeight(Lerp(idleState:GetWeight(), 1.0, 0.1))
				runState:SetWeight(Lerp(runState:GetWeight(), 0.0, 0.1))
				idleState:SetTime((idleState:GetTime() + timestep) % idleState:GetLength())
			end
		end
	end

end

function Player:Stop()
end

function Player:HandlePostRenderUpdate(type, data)
	if (input:GetKeyDown(KEY_P)) then
		local physicsWorld = self.node.scene:GetComponent("PhysicsWorld")
		if (physicsWorld ~= nil) then
			physicsWorld:DrawDebugGeometry(true)
		end
	end
end
