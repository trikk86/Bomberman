extends StaticBody2D

var lifes = 1;
var isEnemy = true

var playerFound = false

func _ready():
	set_fixed_process(true)
	#get_parent().get_node("RayCast2D").add_exception(self)
	var timer = get_parent().get_node("Timer")
	timer.connect("timeout", self, "Rotate")
	
func _fixed_process(delta):
	if(playerFound == true ):
		 get_parent().get_node("Timer").stop()

	#var rayCast = get_parent().get_node("RayCast2D")
	#if(rayCast.is_colliding()):
	#if(rayCast.get_collider().get_name() == "Player"):
	#	playerFound = true;
		

func Rotate():
	print("")

