function HandleKeyDown(type, data)
	local keyCode = data.Key:GetInt()
	if keyCode == KEY_R then
		eventData = VariantMap()
		eventData.Level = "Levels/BoardLevel.xml"
		SendEvent("LoadLevel", eventData)
	elseif keyCode == KEY_ESCAPE then
		engine:Exit()
	end
end