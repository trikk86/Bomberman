extends TextureFrame

func _ready():
	get_node("AnimationPlayer").play("Roll")
	get_node("StreamPlayer").play()
	set_process_input(true)
	
func _input(event):
	if(event.type == InputEvent.KEY):
		get_node("/root/ScreenLoader").goto_scene("res://Menu/Menu.scn")