extends Panel

var selectedbuttonIndex = 0
var buttons = {}
var cursor

func _ready():
	get_node("Dialog").hide()
	get_node("Info").hide()
	get_tree().set_pause(false)
	get_node("AnimTimer").connect("timeout", self, "StartAnimation")

	get_node("Items/NewGame").SetText("new game")
	get_node("Items/HighScores").SetText("highscores")
	get_node("Items/Help").SetText("help")
	get_node("Items/Credits").SetText("credits")
	get_node("Items/Quit").SetText("quit")
	get_node("ConnectTimer").connect("timeout", self, "StartProcessing")
	
	buttons[0] = get_node("Items/NewGame")
	buttons[1] = get_node("Items/HighScores")
	buttons[2] = get_node("Items/Help")
	buttons[3] = get_node("Items/Credits")
	buttons[4] = get_node("Items/Quit")

	cursor = get_node("Cursor")

	set_process_input(true)
	
func _input(event):
	var cursorPosition = cursor.get_pos()

	if(event.is_action("ui_up") && !event.is_echo() && !event.is_pressed()):
		if(selectedbuttonIndex > 0):
			cursorPosition.y -= 50
			selectedbuttonIndex -= 1
			get_node("SamplePlayer").play("click")
			
	if(event.is_action("ui_down") && !event.is_echo() && !event.is_pressed()):
		if(selectedbuttonIndex  < buttons.size() - 1):
			cursorPosition.y += 50
			selectedbuttonIndex += 1
			get_node("SamplePlayer").play("click")
			
	cursor.set_pos(cursorPosition)

	if(event.type == InputEvent.KEY && (event.scancode == KEY_SPACE or event.scancode == KEY_RETURN) && !event.is_pressed() && !event.is_echo()):
		buttons[selectedbuttonIndex].emit_signal("pressed")

func StartProcessing():
	get_node("Items/NewGame").connect("pressed", self, "NewGame")
	get_node("Items/HighScores").connect("pressed", self, "HighScores")
	get_node("Items/Help").connect("pressed", self, "Help")
	get_node("Items/Credits").connect("pressed", self, "ShowCredits")
	get_node("Items/Quit").connect("pressed", self, "Quit")

func NewGame():
	get_node("/root/Globals").points = 0
	get_node("/root/Globals").playerLifes = 3
	get_node("/root/Globals").maxBombCount = 1
	get_node("/root/Globals").bombRange = 2
	get_node("/root/Globals").maxBombCount = 1
	get_node("/root/Globals").walkSpeed = 60
	get_node("/root/Globals").level = 1
	get_node("/root/Globals").remoteDetonation = false
	get_node("/root/ScreenLoader").goto_scene("res://Intro/intro.res")
	
func HighScores():
	get_node("/root/ScreenLoader").goto_scene("res://HighScores/highscores.scn")

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

func ShowCredits():
	get_node("/root/ScreenLoader").goto_scene("res://Credits/credits.scn")
	
func StartAnimation():
	get_node("AnimationPlayer").play("Blink")


