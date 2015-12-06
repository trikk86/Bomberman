extends Sprite

var HitPoints = 2;
var IsBlocking = true
var TilePosition = Vector2()

func _ready():
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	if(HitPoints == 1):
		set_frame(0)


