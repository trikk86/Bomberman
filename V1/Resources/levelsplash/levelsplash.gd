extends TextureFrame

func _ready():
	get_node("LoadTImer").connect("timeout", self, "LoadMap")
	get_node("LoadTImer").start()
	get_node("Label").set_text(str("Level ", get_tree().get_root().get_node("/root/Globals").level))
	pass

func LoadMap():
	get_node("/root/ScreenLoader").goto_scene("res://Resources/map.res")
