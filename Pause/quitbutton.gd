extends TextureButton
	
func _pressed():
	get_node("/root/ScreenLoader").goto_scene("res://Menu/menu.scn")