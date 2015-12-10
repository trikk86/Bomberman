extends KinematicBody2D

var TilePosition = Vector2()
var DestinationTilePosition
var WalkSpeed = 60

var isImmune = false
var isMoving = false
var isReloading = false

var isSpeedBoost = false

var globals
var immunityTimer
var reloadTimer


func _ready():
	globals = get_tree().get_root().get_node("/root/Globals")
	
	reloadTimer = get_node("ReloadTimer")
	reloadTimer.connect("timeout", self, "ReloadFinished")
	
	immunityTimer = get_node("ImmuneTimer")
	immunityTimer.connect("timeout", self, "RemoveImmunity")
#state functions

func RemoveImmunity():
	isImmune = false

func ReloadFinished():
	isReloading = false

#end

func LoseLife():
	if(isImmune == false):
		globals.playerLifes -= 1
		immunityTimer.start()
		isImmune = true
		get_node("SamplePlayer2D").play("dmg")
