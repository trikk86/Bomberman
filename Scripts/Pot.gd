extends StaticBody2D

var lifes = 2;

func _ready():
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	if(lifes == 1):
		get_parent().set_frame(0)


