extends "res://Map/Collectibles/collectibleTileElement.gd"

func _ready():
	Points = 50
	set_process(true)
	
func _process(delta):
	if(!get_node("AnimationPlayer").is_playing()):
		get_node("AnimationPlayer").play("Rotate")

func OnTouch():
	if(!IsTouched):
		get_node("SamplePlayer").play("treasure")
	.OnTouch()

func IsSoundFinished():
	return !get_node("SamplePlayer").is_active()
