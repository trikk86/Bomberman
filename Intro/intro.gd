extends Node2D

func _ready():
	get_node("AnimationPlayer").play("Roll")
	set_process_input(true)
	
func _input(event):
	if(event.type == InputEvent.KEY || event.type == InputEvent.MOUSE_BUTTON):
		get_node("AnimationPlayer").stop(true)
		get_node("/root/ScreenLoader").goto_scene("res://LoadingScreen/loadingscreen.scn")
