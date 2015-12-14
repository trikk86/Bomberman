extends "levelBase.gd"

func _ready():
	._ready()
	PrepareLevel()
	
	timer.connect("timeout", self, "UpdateTime")

	timer.start()

func PrepareLevel():
	map.CreateElement("chest",1,1)
	map.CreateElement("barrel",1,2)
	map.CreateElement("barrel",1,3, "BombRange")
	map.CreateElement("closedbox",1,5)
	map.CreateElement("chest",1,6)
	#map.SpawnEnemy("Goblin", 1,7)
	map.CreateElement("chest",1,8)
	map.CreateElement("closedbox",1,9, "ExtraBomb")
	map.CreateElement("barrel", 1, 11, null, true)
	
	map.CreateElement("openbox",3,5)
	map.CreateElement("barrel", 3,9, "ExtraLife")
	
	map.CreateElement("closedbox", 4,3)
	map.CreateElement("closedbox", 4,7)
	
	map.CreateElement("chest",5,1)
	map.CreateElement("pot",5,2)
	map.CreateElement("closedbox", 5,6)
	map.CreateElement("pot",5,9)
	map.CreateElement("barrel", 5,11)
	
	map.CreateElement("pot",6,1)
	#map.SpawnEnemy("Beholder", 6,9)

	map.CreateElement("barrel", 9,1)
	map.CreateElement("closedbox", 9,6)
	map.CreateElement("closedbox", 9,7)
	map.CreateElement("pot",9,10)

	map.CreateElement("closedbox", 10,7)
	#map.SpawnEnemy("Beholder", 10,11)
