extends "res://Levels/levelBase.gd"

func _ready():
	PrepareLevel()

func PrepareLevel():
	map.CreateElement("barrel",1,1)
	map.CreateElement("barrel",2,1)
	map.CreateElement("barrel",4,1)
	map.CreateElement("barrel",5,1)
	
	map.CreateElement("closedbox",10,1)
	map.CreateElement("closedbox",11,1)
	map.CreateElement("openbox",12,1)
	map.CreateElement("closedbox",13,1, "BombRange")

	map.CreateElement("barrel",1,2)
	map.CreateElement("barrel",5,2)
	map.CreateElement("openbox",11,2)
	map.CreateElement("chest",13,2)
	
	map.CreateElement("chest",1,3)
	map.CreateElement("closedbox",11,3)
	map.SpawnEnemy("Beholder", 13,3)

	map.CreateElement("pot",7,4)
	
	map.CreateElement("chest",1,5)
	map.CreateElement("barrel",9,5)
	map.CreateElement("openbox",12,5)
	map.CreateElement("openbox",13,5)
	
	map.CreateElement("closedbox", 3,6)
	map.CreateElement("closedbox", 5,6, "ExtraBomb")
	
	map.CreateElement("closedbox", 1,7)
	map.CreateElement("closedbox", 2,7)
	map.CreateElement("openbox",3,7)
	map.SpawnEnemy("Mushroom", 4,7)
	map.CreateElement("closedbox", 5,7)
	map.CreateElement("openbox",6,7)
	map.CreateElement("barrel",9,7)
	map.CreateElement("chest",13,7)
	
	map.CreateElement("closedbox", 3,8)
	map.CreateElement("openbox",5,8)
	map.CreateElement("barrel",13,8)
		
	map.CreateElement("openbox",7,9)
	map.CreateElement("barrel",12,9)
	map.CreateElement("barrel",13,9)
	
	map.SpawnEnemy("Beholder", 13,10)
	
	map.CreateElement("barrel",1,11)
	map.CreateElement("barrel",2,11)
	map.CreateElement("chest",4,11)
	map.CreateElement("pot",5,11)
	map.SpawnEnemy("Mushroom", 7,11)
	map.CreateElement("pot",8,11)
	map.CreateElement("pot",11,11)
	map.SpawnEnemy("Mushroom", 12,11)
	map.CreateElement("exit",13,11)
	
func OnFinished():
	.OnFinished()
	get_node("/root/ScreenLoader").goto_scene("res://Outro/outro.res")