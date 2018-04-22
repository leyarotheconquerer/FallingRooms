require("LuaScripts/Input")

scene_ = nil
camera_ = nil
music_ = nil
local newScene_ = nil

function Start()
	log:Write(LOG_DEBUG, "Starting")
	log:Write(LOG_DEBUG, "Create initial scene")

	log:Write(LOG_DEBUG, "Begin loading the first level")
	local style = cache:GetResource("XMLFile", "UI/UIStyle.xml")
	ui.root:SetDefaultStyle(style)
	LoadLevel("Levels/BoardLevel.xml")
end

function DelayedStart()
	log:Write(LOG_DEBUG, "Delayed start")
	UnsubscribeFromEvent("Update")

	log:Write(LOG_DEBUG, "Swap scenes")
	newScene_, scene_ = scene_, newScene_

	log:Write(LOG_DEBUG, "Create camera")
	camera_ = scene_:GetChild("Camera", true)
	if (camera_ ~= nil) then
		log:Write(LOG_DEBUG, "Found the camera")
	end
	camera_:CreateComponent("Camera")
	local viewport = Viewport:new(scene_, camera_:GetComponent("Camera"))
	local listener = camera_:CreateComponent("SoundListener")
	audio:SetListener(listener)
	music_ = camera_:CreateComponent("SoundSource")
	music_:Play(cache:GetResource("Sound", "Music/Background2.wav"))
	renderer:SetViewport(0, viewport)

	log:Write(LOG_DEBUG, "Subscribe to events")
	SubscribeToEvent("KeyDown", "HandleKeyDown")
	SubscribeToEvent("LoadLevel", "HandleLoadLevel")
end

function Stop()
end

function LoadLevel(level)
	log:Write(LOG_DEBUG, string.format("Loading level %s", level))
	newScene_ = Scene(context_)
	newScene_:LoadAsyncXML(cache:GetResourceFileName(level))
	if (music_ ~= nil) then
		music_:Stop()
	end
	SubscribeToEvent(newScene_, "AsyncLoadFinished", "HandleLoadedLevel")
end

function HandleLoadLevel(type, data)
	log:Write(LOG_DEBUG, "Load level")
	if (data ~= nil) then
		LoadLevel(data.Level:GetString())
	else
		log:Write(LOG_DEBUG, "Not can has level name")
	end
end

function HandleLoadedLevel(type, data)
	log:Write(LOG_DEBUG, "Level has been loaded")
	SubscribeToEvent("Update", "DelayedStart")
end