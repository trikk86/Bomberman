extends "res://Map/Models/enemyElement.gd"

func _ready():
	set_frame(0)
	Points = 200
	HitPoints = 1
	WalkSpeed = 60
	AILevel = 2
	
func OnDeath():
	get_node("BlinkPlayer").stop()
	set_opacity(1)
	.OnDeath()