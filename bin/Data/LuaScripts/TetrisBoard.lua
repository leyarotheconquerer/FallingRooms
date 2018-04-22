TetrisBoard = ScriptObject()

TetrisBoard.Left = 0
TetrisBoard.Right = 36
TetrisBoard.Top = 36

function TetrisBoard:Start()
	log:Write(LOG_DEBUG, "Starting board level")
end

function TetrisBoard:DelayedStart()
	log:Write(LOG_DEBUG, "Delayed starting board level")
	playerSpawn = self.node.scene:GetChild("PlayerSpawn", true)
	if (playerSpawn ~= nil) then
		player = self.node.scene:InstantiateXML(
			cache:GetResourceFileName("Objects/Player.xml"),
			playerSpawn.position,
			playerSpawn.rotation
		)
	else
		log:Write(LOG_DEBUG, "Couldn't find player spawn")
	end
end

function TetrisBoard:Stop()
end