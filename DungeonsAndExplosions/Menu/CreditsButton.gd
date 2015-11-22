extends TextureButton

func _ready():
	pass

func _pressed():
	get_node("/root/ScreenLoader").goto_scene("res://Menu/Credits.scn")

