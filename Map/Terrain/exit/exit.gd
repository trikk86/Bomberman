extends "res://Map/tileElement.gd"

var IsOpened = false

func OnEnemiesCleared():
	if(!IsOpened):
		set_frame(1)
		get_node("SamplePlayer2D").play("exitopen")
		IsOpened = true