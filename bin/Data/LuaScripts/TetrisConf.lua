TetrisConf = {
	Left = 0,
	Right = 36,
	Top = 36,
	Interval = 3,
	Buffer = 3,
	Direction = Vector3(0, 0, -1),
	MovementRate = 1,
	SpawnDelay = 20,
	Blocks = {
		"Objects/CornerRoomBlock.xml",
		"Objects/LineRoomBlock.xml"
	},
	SpawnNewRoom = function (scene)
		log:Write("Spawning new room")
		local count = 0
		for k, v in pairs(TetrisConf.Blocks) do
			count = count + 1
		end
		local roomIndex = RandomInt(1, count + 1)
		scene:InstantiateXML(
			cache:GetResourceFileName(TetrisConf.Blocks[roomIndex]),
			Vector3(-TetrisConf.Right, 0, -TetrisConf.Right),
			Quaternion()
		)
	end
}
