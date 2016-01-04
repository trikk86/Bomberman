extends TextureFrame

func _ready():
	var scoreFile = File.new()
	get_node("Tree").set_columns(2)
	
	get_node("BackButton").SetText("Back")
	get_node("ConnectTimer").connect("timeout", self, "StartProcessing")
	
	get_node("Tree").set_column_min_width(0,2)
	var scoreList = Array()

	if (scoreFile.file_exists("user://highscores.save")):
		scoreFile.open("user://highscores.save", File.READ)
		while (!scoreFile.eof_reached()):
			var currentline = {}
			currentline.parse_json(scoreFile.get_line())
			if(!currentline.empty()):
				scoreList.append(currentline)
	
	var labelItem = get_node("Tree").create_item()
	
	labelItem.set_text(0, "Name:")
	labelItem.set_custom_color(0, Color(255,255,255,255))
	labelItem.set_text(1, "\tScore:")
	labelItem.set_custom_color(1, Color(255,255,255,255))
	
	for item in scoreList:
		var treeItem = get_node("Tree").create_item(labelItem)
		treeItem.set_text(0, item.Name)
		treeItem.set_text(1, str(item.Score))
	
	
	set_process_input(true)
		
func _input(event):
	if(event.type == InputEvent.KEY && event.scancode == KEY_SPACE && !event.is_pressed() && !event.is_echo()):
		get_node("BackButton").emit_signal("pressed")
		
func StartProcessing():
	get_node("BackButton").connect("pressed", self, "Back")

func Back():
	get_node("/root/ScreenLoader").goto_scene("res://Menu/menu.res")

