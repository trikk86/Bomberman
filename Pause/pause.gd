extends Sprite

var selectedbuttonIndex = 0
var buttons = {}
var cursor

func _ready():
	get_node("Items/MainMenu").SetText("main menu")
	get_node("Items/Quit").SetText("quit")
	
	get_node("Items/MainMenu").connect("pressed", self, "MainMenu")
	get_node("Items/Quit").connect("pressed", self, "Quit")
	
	buttons[0] = get_node("Items/MainMenu")
	buttons[1] = get_node("Items/Quit")

	cursor = get_node("Cursor")

	set_process_input(true)
	
func _input(event):

	if(is_visible()):
		var cursorPosition = cursor.get_pos()
	
		if(event.is_action("ui_up") && !event.is_echo() && !event.is_pressed()):
			if(selectedbuttonIndex > 0):
				cursorPosition.y -= 50
				selectedbuttonIndex -= 1
				get_node("SamplePlayer").play("click")
				
		if(event.is_action("ui_down") && !event.is_echo() && !event.is_pressed()):
			if(selectedbuttonIndex < buttons.size() - 1):
				cursorPosition.y += 50
				selectedbuttonIndex += 1
				get_node("SamplePlayer").play("click")
				
		cursor.set_pos(cursorPosition)
		if(event.type == InputEvent.KEY && event.scancode == KEY_SPACE && !event.is_pressed() && !event.is_echo()):
			buttons[selectedbuttonIndex].emit_signal("pressed")
			
		if(event.type == InputEvent.KEY && event.scancode == KEY_ESCAPE && !event.is_pressed() && !event.is_echo()):
			get_parent().UnpauseGame()

func MainMenu():
	get_node("/root/ScreenLoader").goto_scene("res://Menu/menu.scn")

func Quit():
	get_tree().quit()
	
func StartAnimation():
	get_node("TextureFrame/AnimationPlayer").play("Blink")


