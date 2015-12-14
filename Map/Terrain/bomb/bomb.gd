extends "res://Map/Terrain/terrainTileElement.gd"

var IsExploded = false

func _ready():
	get_node("AnimationPlayer").play("Explode")
	IsBomb = true
	IsDelayedDeath = true

func OnDeath():
	set_opacity(0)
	get_node("SamplePlayer2D").play("explosion2", 0)
	IsExploded = true
	
func OnEnemiesCleared():
	pass
	