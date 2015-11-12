extends Node

var playerLifes = 1
var points = 0;

func AddPoints(pointsToAdd):
	points += pointsToAdd
	
func LoseLife():
	playerLifes = playerLifes -1
	