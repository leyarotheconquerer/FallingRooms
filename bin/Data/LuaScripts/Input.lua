function HandleKeyDown(type, data)
	local keyCode = data.Key:GetInt()
	if keyCode == KEY_R then
		log:Write(LOG_DEBUG, "R key was pressed")
		local data = { Level = "Levels/TestLevel2.xml" }
		eventData = VariantMap()
		eventData.Level = "Levels/TestLevel2.xml"
		log:Write(LOG_DEBUG, eventData.Level:GetString())
		SendEvent("LoadLevel", eventData)
	elseif keyCode == KEY_ESCAPE then
		engine:Exit()
	end
end