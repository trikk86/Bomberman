extends Sprite

func _input(event):
	if(event.type == InputEvent.KEY && event.scancode == KEY_ESCAPE && !event.is_pressed() && !event.is_echo()):
		get_parent().HelpResume()

func Enable():
	set_process_input(true)
	
func Disable():
	set_process_input(false)