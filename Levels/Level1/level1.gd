extends "res://Levels/levelBase.gd"

func _ready():
	._ready()
	PrepareLevel()
	
	timer.connect("timeout", self, "UpdateTime")

	timer.start()

func PrepareLevel():
	map.CreateElement("barrel",1,1)
	map.CreateElement("barrel",2,1)
	map.CreateElement("closedbox",5,1)
	map.CreateElement("openbox",9,1, "ExtraBomb")
	map.CreateElement("barrel",12,1)
	map.CreateElement("barrel",13,1)
	
	map.CreateElement("barrel",1,2)
	map.CreateElement("closedbox",5,2)
	map.CreateElement("barrel",13,2)
	
	map.CreateElement("barrel",1,3)
	map.CreateElement("closedbox",3,3)
	map.CreateElement("barrel",10,3)
	map.CreateElement("barrel",11,3)
	map.CreateElement("barrel",13,3)

	map.CreateElement("pot",9,4)
	
	map.CreateElement("chest",1,5)
	map.CreateElement("openbox",3,5, "SpeedBoost")
	map.CreateElement("chest",6,5)
	map.CreateElement("chest",8,5)
	map.CreateElement("pot",10,5)
	map.CreateElement("chest",13,5)
	
	map.CreateElement("chest",1,6)
	map.CreateElement("closedbox", 5,6)
	map.CreateElement("pot",9,6)
	map.CreateElement("chest",13,6)
		
	map.CreateElement("chest",1,7)
	map.CreateElement("closedbox", 5,7)
	map.CreateElement("closedbox", 11,7)
	map.CreateElement("chest",13,7)

	map.CreateElement("openbox",11,8)
	
	map.CreateElement("barrel",1,9)
	map.CreateElement("chest",6,9)
	map.CreateElement("chest",8,9)
	map.CreateElement("openbox",11,9, "BombRange")
	map.CreateElement("barrel", 13,9)
	
	map.CreateElement("pot",1,10)
	map.CreateElement("pot",3,10)
	map.CreateElement("pot",5,10)
	map.CreateElement("barrel",13,10)
	
	map.CreateElement("exit", 1,11)
	map.SpawnEnemy("Mushroom", 2,11)
	#map.SpawnEnemy("Beholder", 2,11)
	map.CreateElement("barrel", 5, 11)
	map.CreateElement("closedbox",8,11)
	map.CreateElement("closedbox",9,11, "ExtraLife")
	map.CreateElement("openbox",10,11)
	map.CreateElement("barrel", 12,11)
	map.CreateElement("barrel", 13,11)