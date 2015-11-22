
extends TextureFrame

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	get_node("LoadTImer").connect("timeout", self, "LoadMap")
	get_node("LoadTImer").start()
	# Initialization here
	pass

func LoadMap():
	get_node("/root/ScreenLoader").goto_scene("res://Resources/map.res")
