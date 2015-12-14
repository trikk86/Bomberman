extends "res://Map/Collectibles/collectibleTileElement.gd"

func _ready():
	Points = 50
	set_process(true)
	
func _process(delta):
	if(!get_node("AnimationPlayer").is_playing()):
		get_node("AnimationPlayer").play("Rotate")

func OnTouch():
	if(!IsTouched):
		get_node("SamplePlayer2D").play("treasure", 0)
	.OnTouch()


func IsSoundFinished():
	return !get_node("SamplePlayer2D").is_voice_active(0)
