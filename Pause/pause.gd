extends Sprite

var selectedbuttonIndex = 0
var buttons = {}
var cursor

func _ready():
	get_node("Dialog").hide()
	get_node("Info").hide()
	
	get_node("Items/Resume").SetText("resume")
	get_node("Items/Help").SetText("help")
	get_node("Items/MainMenu").SetText("main menu")
	get_node("Items/Quit").SetText("quit")
	
	get_node("Items/Resume").connect("pressed", self, "Unpause")
	get_node("Items/Help").connect("pressed", self, "Help")
	get_node("Items/MainMenu").connect("pressed", self, "MainMenu")
	get_node("Items/Quit").connect("pressed", self, "Quit")
	
	buttons[0] = get_node("Items/Resume")
	buttons[1] = get_node("Items/Help")
	buttons[2] = get_node("Items/MainMenu")
	buttons[3] = get_node("Items/Quit")

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

func Unpause():
	if(get_parent() != null):
		get_parent().UnpauseGame()

func MainMenu():
	get_node("/root/ScreenLoader").goto_scene("res://Menu/menu.res")

func Help():
	get_node("Info").show()
	set_process_input(false)
	get_node("Info").Enable()
	get_node("Cursor").hide()

func HelpResume():
	get_node("Info").hide()
	set_process_input(true)
	get_node("Info").Disable()
	get_node("Cursor").show()

func StartAnimation():
	get_node("TextureFrame/AnimationPlayer").play("Blink")

func Quit():
	get_node("Dialog").show()
	set_process_input(false)
	get_node("Dialog").Enable()
	get_node("Cursor").hide()
	
func QuitResume():
	get_node("Dialog").hide()
	set_process_input(true)
	get_node("Dialog").Disable()
	get_node("Cursor").show()