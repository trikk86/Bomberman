extends TextureFrame

func _ready():
	set_process_input(true)
		
func _input(event):
	if(is_visible()):
		if(event.type == 1 && !event.is_pressed() && !event.is_echo()):
			get_node("/root/ScreenLoader").goto_scene("res://Menu/menu.res")


