extends "res://Map/Terrain/terrainTileElement.gd"

func _ready():
	IsDelayedDeath = true
	HasPoints = true

func OnHit():
	.OnHit()
	if(HitPoints == 0):
		set_frame(1)
		IsBlocking = false
		
func OnDeath():
	pass
