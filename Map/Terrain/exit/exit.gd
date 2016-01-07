extends "res://Map/tileElement.gd"

var IsOpened = false
var HitPoints = 1

func OnEnemiesCleared():
	if(!IsOpened):
		set_frame(1)
		get_node("SamplePlayer").play("exitopen")
		IsOpened = true
		
func OnHit():
	pass