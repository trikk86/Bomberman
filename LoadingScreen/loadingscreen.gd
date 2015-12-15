extends Sprite

var quotes = {}

func _ready():
	set_process(true)
	get_node("Timer").connect("timeout", self, "LoadMap")
	get_node("Timer").start()
	
	randomize()
	quotes[0] = "\"Burning! Looting! Plunging! Shooting!\"\n-Mortar Team Warcraft 3"
	quotes[1] = "\"Bombs do not choose.\nThey will hit everything.\"\n-Nikita Khrushchev"
	quotes[2] = "\"First thou pullest the Holy Pin.\nThen thou must count to three.\nThree shall be the number of the counting\nand the number of the counting \nshall be three\"\n-Monty Python and the holy grail"
	quotes[3] = "\"Work would be a lot better \nif it involved blowing things up\"\n-Borderlands 2"
	
	var random = randi() % quotes.size()
	get_node("HintLabel").set_text(quotes[random])
	
	get_node("LevelLabel").set_text(str("LEVEL ", get_node("/root/Globals").level))
	
func _process(delta):
	if(!get_node("AnimationPlayer").is_playing()):
		get_node("AnimationPlayer").play("Load")

func LoadMap():
	get_node("FinishedLabel").show()
	set_process_input(true)
	
func _input(event):
	if(event.type == 1):
		var currentLevel = get_node("/root/Globals").level
		var levelstringMap = str("res://Levels/level", currentLevel, ".scn")
		get_node("/root/ScreenLoader").goto_scene(levelstringMap)