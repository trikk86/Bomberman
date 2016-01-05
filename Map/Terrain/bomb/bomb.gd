extends "res://Map/Terrain/terrainTileElement.gd"

var IsExploded = false
var IsRemoteDetonated = false

func _ready():
	get_node("AnimationPlayer").play("Explode")
	IsBomb = true
	IsDelayedDeath = true

func OnDeath():
	get_node("Timer").stop()
	hide()
	get_node("SamplePlayer2D").play("explosion")
	IsExploded = true

func OnEnemiesCleared():
	pass
	