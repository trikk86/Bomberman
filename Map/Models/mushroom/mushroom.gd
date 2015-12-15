extends "res://Map/Models/enemyElement.gd"

func _ready():
	set_frame(0)
	Points = 100
	HitPoints = 1
	WalkSpeed = 60
	AILevel = 1

func OnHit():
	get_node("SamplePlayer2D").play("mushroom_death")
	.OnHit()

func OnDeath():
	#get_node("SamplePlayer2D").play("mushroom_death")
	.OnDeath()