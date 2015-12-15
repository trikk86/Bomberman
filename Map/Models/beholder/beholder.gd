extends "res://Map/Models/enemyElement.gd"

func _ready():
	set_frame(0)
	Points = 200
	HitPoints = 2
	WalkSpeed = 60
	AILevel = 2

func OnHit():
	get_node("SamplePlayer2D").play("beholder_pain")
	.OnHit()
	
	
func OnDeath():
	get_node("SamplePlayer2D").play("beholder_death")
	.OnDeath()