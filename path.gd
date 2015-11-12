extends PathFollow2D

var location = 0
var speed = .001

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	set_unit_offset(location)
	location += speed
	