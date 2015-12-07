
extends Sprite

var Points = 50

var TilePosition = Vector2()

func _ready():
	set_process(true)
	pass
	
func _process(delta):
	if(!get_node("AnimationPlayer").is_playing()):
		get_node("AnimationPlayer").play("Rotate")


