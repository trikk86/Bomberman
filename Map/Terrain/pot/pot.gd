extends "res://Map/Terrain/terrainTileElement.gd"

func _ready():
	HitPoints = 2

func OnHit():
	.OnHit()
	if(HitPoints == 1):
		set_frame(0)

func OnEnemiesCleared():
	pass
