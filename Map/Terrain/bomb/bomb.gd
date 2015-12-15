extends "res://Map/Terrain/terrainTileElement.gd"

var IsExploded = false

func _ready():
	get_node("AnimationPlayer").play("Explode")
	IsBomb = true
	IsDelayedDeath = true

func OnDeath():
	hide()
	get_node("SamplePlayer2D").play("explosion")
	IsExploded = true

func OnEnemiesCleared():
	pass
	