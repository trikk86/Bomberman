extends "res://Map/tileElement.gd"

var Points = 0
var PowerUpType = 0
var IsTouched = false

func OnTouch():
	IsTouched = true
	
func IsSoundFinished():
	return false