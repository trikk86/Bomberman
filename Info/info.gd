extends Sprite

func _input(event):
	if(event.type == InputEvent.KEY  && !event.is_pressed() && !event.is_echo()):
		if(event.scancode == KEY_SPACE or event.scancode == KEY_ESCAPE):
			get_parent().HelpResume()

func Enable():
	set_process_input(true)
	
func Disable():
	set_process_input(false)