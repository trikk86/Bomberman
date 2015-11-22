extends TextureFrame

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	get_node("Panel/AnimationPlayer").play("Roll")
	set_process(true)

func _process(delta):
	if(Input.is_mouse_button_pressed(1)):
		get_node("/root/ScreenLoader").goto_scene("res://Menu/Menu.scn")
