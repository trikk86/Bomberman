extends Sprite

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	get_node("AnimationPlayer").play("Explode")
	set_fixed_process(true)
	pass
	
func _fixed_process(delta):
	if(!get_node("AnimationPlayer").is_playing()):
		free()


