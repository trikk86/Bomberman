extends "res://Map/tileElement.gd"

var isOpened = false

func OnEnemiesCleared():
	if(!isOpened):
		set_frame(1)
		get_node("SamplePlayer2D").play("exitopen")
		isOpened = true