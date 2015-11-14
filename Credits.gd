extends TextureFrame


func _ready():
	get_node("Panel/AnimationPlayer").play("Roll")


func _on_Panel_input_event( ev ):
	if(ev.is_pressed()):
		get_node("/root/ScreenLoader").goto_scene("res://Menu/Menu.scn")
