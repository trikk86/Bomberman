extends "res://Map/Models/dynamicElement.gd"

var HitPoints = 1
var Points = 100

var isDeathAnimationFinished = false

var AILevel = 1

func _ready():
	immunityTimer = get_node("ImmunityTimer")
	immunityTimer.connect("timeout", self, "StopImmunity")
	
	get_node("AnimationPlayer").connect("finished", self, "DeathAnimationFinished")
	
	get_node("Timer").connect("timeout", self, "OnDeath")
	get_node("SlowDownTimer").connect("timeout", self, "RestoreSpeed")
	
	set_process(true)

func _process(delta):
	if(isImmune && !get_node("BlinkPlayer").is_playing()):
		get_node("BlinkPlayer").play("Blink")

func OnHit():
	if(!isImmune):
		HitPoints -= 1
		StartImmunity()
		if(HitPoints == 0):
			get_node("Timer").start()
			
func OnDeath():
	isMoving = false
	DestinationTilePosition = null
	show()
	if(!isDeathAnimationFinished):
		get_node("AnimationPlayer").play("Die")
	get_node("Area2D/CollisionShape2D").set_trigger(true)
	
func DeathAnimationFinished():
	if(get_node("AnimationPlayer").get_current_animation() == "Die"):
		isDeathAnimationFinished = true

func StartImmunity():
	isImmune = true
	immunityTimer.start()

func StopImmunity():
	isImmune = false

func SlowDown():
	WalkSpeed = WalkSpeed / 4
	get_node("SlowDownTimer").start()
	
func RestoreSpeed():
	pass