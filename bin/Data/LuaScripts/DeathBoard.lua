DeathBoard = ScriptObject()

function DeathBoard:Start()
	self:SubscribeToEvent(self.node, "NodeCollisionStart", "DeathBoard:HandleNodeCollisionStart")
	self:SubscribeToEvent("LoadLevel", "DeathBoard:HandleLoadLevel")
end

function DeathBoard:DelayedStart()
end

function DeathBoard:FixedUpdate()
end

function DeathBoard:Stop()
	self:UnsubscribeFromAllEvents()
end

function DeathBoard:HandleNodeCollisionStart(type, data)
	local otherNode = data.OtherNode:Get("Node")
	local rigidBody = self.node:GetComponent("RigidBody")
	local otherBody = data.OtherBody:Get("RigidBody")
	if (otherNode ~= nil and rigidBody ~= nil) then
		if (otherNode:GetName() == "Player") then
			local window = ui.root:CreateChild("Window")
			local style = cache:GetResource("XMLFile", "UI/UIStyle.xml")
			if (window ~= nil and style ~= nil) then
				window:SetStyle(style)
				window:LoadXML(cache:GetResourceFileName("UI/LossWindow.xml"))
			end
			SendEvent("TerminateLevel")
		end
	end
end

function DeathBoard:HandleLoadLevel(type, data)
	local window = ui.root:GetChild("LossWindow")
	local count = 5
	while (window ~= nil and count > 0) do
		count = count - 1
		window:Remove()
		window = ui.root:GetChild("LossWindow")
	end
	self:UnsubscribeFromAllEvents()
end