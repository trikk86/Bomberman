extends TextureFrame

var selectedbuttonIndex = 0
var buttons = {}
var cursor

func _ready():

	#get_node("TextureFrame/NewGame").connect("pressed", self, "NewGame")
	#get_node("TextureFrame/Credits").connect("pressed", self, "ShowCredits")
	get_node("Items/Quit").connect("pressed", self, "Quit")
	
	#buttons[0] = get_node("TextureFrame/NewGame")
	#buttons[1] = get_node("TextureFrame/HighScores")
	#buttons[2] = get_node("TextureFrame/Credits")
	buttons[0] = get_node("Items/Quit")

	cursor = get_node("Cursor")

	set_process_input(true)
	
func _input(event):
	if(get_opacity() == 1):
		var cursorPosition = cursor.get_pos()
	
		if(event.is_action("ui_up") && !event.is_echo() && !event.is_pressed()):
			if(selectedbuttonIndex > 0):
				cursorPosition.y -= 50
				selectedbuttonIndex -= 1
				
		if(event.is_action("ui_down") && !event.is_echo() && !event.is_pressed()):
			if(selectedbuttonIndex < buttons.size() - 1):
				cursorPosition.y += 50
				selectedbuttonIndex += 1
				
		cursor.set_pos(cursorPosition)
	
		if(event.type == InputEvent.KEY && event.scancode == KEY_SPACE && !event.is_pressed() && !event.is_echo()):
			buttons[selectedbuttonIndex].emit_signal("pressed")
	
func Quit():
	get_tree().quit()
	
func StartAnimation():
	get_node("TextureFrame/AnimationPlayer").play("Blink")


