extends "res://Map/tileElement.gd"

var HitPoints = 1
var PowerUpType = 0
var IsBlocking = true
var HasPoints = false;
var IsBomb = false
var IsDelayedDeath = false

func OnHit():
	if(is_visible()):
		HitPoints -= 1

func OnDeath():
	pass

func OnEnemiesCleared():
	if(PowerUpType > 0):
		if(!get_node("AnimationPlayer").is_playing()):
			get_node("AnimationPlayer").play("Blink")

