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
		"Objects/CornerRoomBlock2.xml",
		"Objects/CornerRoomBlock3.xml",
		"Objects/CornerRoomBlock4.xml",
		"Objects/CornerRoomBlock5.xml",
		"Objects/CornerRoomBlock6.xml",
		"Objects/CornerRoomBlock7.xml",
		"Objects/CornerRoomBlock8.xml",
		"Objects/CornerRoomBlock9.xml",
		"Objects/CornerRoomBlock10.xml",
		"Objects/LineRoomBlock.xml",
		"Objects/LineRoomBlock2.xml",
		"Objects/LineRoomBlock3.xml",
		"Objects/LineRoomBlock4.xml",
		"Objects/SquareRoomBlock.xml",
		"Objects/SquareRoomBlock2.xml"
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
