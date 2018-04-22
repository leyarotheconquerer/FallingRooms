ExitRoom = ScriptObject()

function ExitRoom:Start()
	self:SubscribeToEvent(self.node, "NodeCollisionStart", "ExitRoom:HandleNodeCollisionStart")
	self:SubscribeToEvent("LoadLevel", "ExitRoom:HandleLoadLevel")
end

function ExitRoom:Stop()
end

function ExitRoom:HandleNodeCollisionStart(type, data)
	local otherNode = data.OtherNode:Get("Node")
	if (otherNode ~= nil and otherNode.name == "Player") then
		local window = ui.root:CreateChild("Window")
		local style = cache:GetResource("XMLFile", "UI/UIStyle.xml")
		if (style ~= nil and window ~= nil) then
			window:SetDefaultStyle(style)
			window:LoadXML(cache:GetResourceFileName("UI/VictoryWindow.xml"))
			SendEvent("TerminateLevel")
		end
	end
end

function ExitRoom:HandleLoadLevel(type, data)
	local window = ui.root:GetChild("VictoryWindow")
	if (window ~= nil) then
		window:Remove()
	end
end