extends "res://Map/tileElement.gd"

var DestinationTilePosition
var WalkSpeed = 60

var isMoving = false
var isImmune = false
var isPlayer = false

var direction = null

var immunityTimer

func _ready():
	set_process(true)

func _process(delta):
	if(isImmune && !get_node("BlinkPlayer").is_playing()):
		get_node("BlinkPlayer").play("Blink")

func OnHit():
	pass
	
func MoveUp():
	if(!get_node("AnimationPlayer").is_playing()):
		get_node("AnimationPlayer").play("MoveUp")
	direction = "up"

func MoveDown():
	if(!get_node("AnimationPlayer").is_playing()):
		get_node("AnimationPlayer").play("MoveDown")
	direction = "down"
	
func MoveLeft():
	if(!get_node("AnimationPlayer").is_playing()):
		get_node("AnimationPlayer").play("MoveLeft")
	direction = "left"
	
func MoveRight():
	if(!get_node("AnimationPlayer").is_playing()):
		get_node("AnimationPlayer").play("MoveRight")
	direction = "right"

