extends "res://Map/Models/dynamicElement.gd"

var HitPoints = 1
var Points = 100

var isDeathAnimationFinished = false

var AILevel = 1

func _ready():
	immunityTimer = get_node("ImmunityTimer")
	immunityTimer.connect("timeout", self, "StopImmunity")
	set_process(true)
	get_node("AnimationPlayer").connect("finished", self, "DeathAnimationFinished")

	
func _process(delta):
	if(isImmune && !get_node("BlinkPlayer").is_playing()):
		get_node("BlinkPlayer").play("Blink")

func OnHit():
	if(!isImmune):
		HitPoints -= 1
		isImmune = true
		immunityTimer.start()
	if(HitPoints == 0):
		OnDeath()

func OnDeath():
	isMoving = false
	DestinationTilePosition = null
	if(!isDeathAnimationFinished):
		get_node("AnimationPlayer").play("Die")
		
	get_node("Area2D/CollisionShape2D").set_trigger(true)

func DeathAnimationFinished():
	if(get_node("AnimationPlayer").get_current_animation() == "Die"):
		print("DeathAnimationFinished")
		isDeathAnimationFinished = true


func StopImmunity():
	isImmune = false