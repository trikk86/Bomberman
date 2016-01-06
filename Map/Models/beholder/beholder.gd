extends "res://Map/Models/enemyElement.gd"

func _ready():
	set_frame(0)
	Points = 200
	HitPoints = 2
	WalkSpeed = 60
	AILevel = 2

func OnHit():
	.OnHit()
	if(HitPoints != 0):
		get_node("SamplePlayer").play("beholder_pain")
	
func OnDeath():
	get_node("SamplePlayer").play("beholder_death")
	.OnDeath()
	
func RestoreSpeed():
	WalkSpeed = 60