extends Button

func _ready():
	pass

func _pressed():
	get_node("/root/Globals").points = 0
	get_node("/root/Globals").playerLifes = 3
	get_node("/root/ScreenLoader").goto_scene("res://Levels/level1.scn")