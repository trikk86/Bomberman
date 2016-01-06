extends Node2D

var selected = "right"

func _input(event):
	var cursorPosition = get_node("Cursor").get_pos()

	if(event.is_action("ui_left") && !event.is_echo() && !event.is_pressed() && selected != "left"):
		selected = "left"
		cursorPosition.x -= 150
		get_node("SamplePlayer").play("click")
			
	if(event.is_action("ui_right") && !event.is_echo() && !event.is_pressed() && selected != "right"):
		cursorPosition.x += 150
		selected = "right"
		get_node("SamplePlayer").play("click")
			
	get_node("Cursor").set_pos(cursorPosition)

	if(event.type == InputEvent.KEY && event.scancode == KEY_SPACE && !event.is_pressed() && !event.is_echo()):
		if(selected == "left"):
			get_tree().quit()
		else:
			get_parent().QuitResume()

func Enable():
	set_process_input(true)
	
func Disable():
	set_process_input(false)