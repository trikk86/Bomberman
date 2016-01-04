extends "res://Levels/levelBase.gd"

func _ready():
	PrepareLevel()

func PrepareLevel():
	map.CreateElement("chest",1,1)
	map.CreateElement("barrel",1,2)
	map.CreateElement("barrel",1,3, "BombRange")
	map.CreateElement("closedbox",1,5)
	map.CreateElement("chest",1,6)
	map.SpawnEnemy("Mushroom", 1,7)
	map.CreateElement("chest",1,8)
	map.CreateElement("closedbox",1,9, "ExtraBomb")
	map.CreateElement("exit", 1, 11)
	
	map.CreateElement("barrel",2,1)
	map.CreateElement("closedbox",2,7)
	
	map.CreateElement("barrel",3,1)
	map.SpawnEnemy("Mushroom", 3,3)
	map.CreateElement("openbox",3,5)
	map.CreateElement("barrel", 3,9, "ExtraLife")
	map.CreateElement("barrel", 3,11)
	
	map.CreateElement("closedbox", 4,3)
	map.CreateElement("closedbox", 4,7)
	
	map.CreateElement("chest",5,1)
	map.CreateElement("pot",5,2)
	map.CreateElement("closedbox", 5,6)
	map.CreateElement("pot",5,9)
	map.CreateElement("barrel", 5,11)
	
	map.CreateElement("pot",6,1, "ExtraBomb")
	map.SpawnEnemy("Beholder", 6,9)
	
	map.CreateElement("closedbox", 7,3)
	map.CreateElement("openbox",7,5)
	map.CreateElement("closedbox", 7,6)
	map.CreateElement("pot",7,9)
	map.CreateElement("chest",7,11)
	
	map.CreateElement("openbox",8,7)
	map.CreateElement("pot",8,11)
	
	map.CreateElement("barrel", 9,1)
	map.CreateElement("closedbox", 9,6)
	map.CreateElement("closedbox", 9,7)
	map.CreateElement("pot",9,10)

	map.CreateElement("closedbox", 10,7)
	map.SpawnEnemy("Beholder", 10,11)
	
	map.SpawnEnemy("Mushroom", 11, 1)
	map.CreateElement("pot", 11, 2)
	map.CreateElement("closedbox", 11, 7)
	map.CreateElement("closedbox", 11, 8)
	map.CreateElement("pot",11,10)
	
	map.CreateElement("openbox", 12, 3)
	map.CreateElement("closedbox", 12,5)
	map.CreateElement("openbox", 12, 7)
	map.CreateElement("pot", 12, 9)
	
	map.CreateElement("chest", 13,1)
	map.SpawnEnemy("Mushroom", 13, 4)
	map.SpawnEnemy("Mushroom", 13, 8)
	map.CreateElement("pot", 13, 9)
	map.CreateElement("closedbox", 13, 11)
	
func OnFinished():
	.OnFinished()
	get_node("/root/ScreenLoader").goto_scene("res://Outro/outro.res")
	