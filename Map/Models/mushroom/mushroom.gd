extends "res://Map/Models/enemyElement.gd"

func _ready():
	set_frame(0)
	Points = 100
	HitPoints = 1
	WalkSpeed = 30
	AILevel = 1
	
func OnHit():
	.OnHit()

func OnDeath():
	get_node("SamplePlayer").play("mushroom_death")
	.OnDeath()
	
func RestoreSpeed():
	WalkSpeed = 30