extends Sprite

var HitPoints = 1;
var IsBlocking = true
var HasGold = true

func _ready():
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	if(HitPoints == 0):
		set_frame(1)


