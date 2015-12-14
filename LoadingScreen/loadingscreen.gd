extends Sprite

func _ready():
	set_process(true)
	get_node("Timer").connect("timeout", self, "LoadMap")
	get_node("Timer").start()
	
func _process(delta):
	if(!get_node("AnimationPlayer").is_playing()):
		get_node("AnimationPlayer").play("Load")

func LoadMap():
	var currentLevel = get_node("/root/Globals").level
	var levelstringMap = str("res://Levels/level", currentLevel, ".scn")
	get_node("/root/ScreenLoader").goto_scene(levelstringMap)