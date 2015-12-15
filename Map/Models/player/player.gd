extends "res://Map/Models/dynamicElement.gd"

var globals
var reloadTimer
var BombPosition = Vector2()

var enemyElementClass = load("res://Map/Models/enemyElement.gd")

var isReloading = false

func _ready():
	._ready()
	WalkSpeed = 60
	isPlayer = true
	globals = get_tree().get_root().get_node("/root/Globals")
	
	immunityTimer = get_node("ImmunityTimer")
	immunityTimer.connect("timeout", self, "StopImmunity")
	
	reloadTimer = get_node("ReloadTimer")
	reloadTimer.connect("timeout", self, "ReloadFinished")
	set_process(true)

func StopImmunity():
	isImmune = false

func ReloadFinished():
	isReloading = false

func OnHit():
	if(!isImmune):
		globals.playerLifes -= 1
		immunityTimer.start()
		isImmune = true
		get_node("BlinkPlayer").play("Blink")
		get_node("SamplePlayer2D").play("dmg")

func MoveUp():
	.MoveUp();
	if(!get_node("SamplePlayer2D").is_voice_active(0)):
		get_node("SamplePlayer2D").play("step")

func MoveDown():
	.MoveDown();
	if(!get_node("SamplePlayer2D").is_voice_active(0)):
		get_node("SamplePlayer2D").play("step")
	
func MoveLeft():
	.MoveLeft();
	if(!get_node("SamplePlayer2D").is_voice_active(0)):
		get_node("SamplePlayer2D").play("step", 0)
	
func MoveRight():
	.MoveRight();
	if(!get_node("SamplePlayer2D").is_voice_active(0)):
		get_node("SamplePlayer2D").play("step")

func _on_Area2D_area_enter(area):
	if(area.get_parent() extends enemyElementClass):
		OnHit() 
