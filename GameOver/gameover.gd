
extends TextureFrame

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
		set_process_input(true)
		
func _input(event):
	if(is_visible()):
		if(event.type == 1):
			get_node("/root/ScreenLoader").goto_scene("res://Menu/menu.scn")


