extends "res://Map/Terrain/terrainTileElement.gd"

var isImmune = false
var immunityTimer

func _ready():
	HitPoints = 2
	immunityTimer = get_node("ImmunityTimer")
	immunityTimer.connect("timeout", self, "StopImmunity")

func StopImmunity():
	isImmune = false

func OnHit():
	if(!isImmune):
		.OnHit()
		isImmune = true
		immunityTimer.start()
		if(HitPoints == 1):
			set_frame(0)

func OnEnemiesCleared():
	pass
