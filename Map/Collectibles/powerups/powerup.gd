extends "res://Map/Collectibles/collectibleTileElement.gd"

const BombRange= 1
const ExtraBomb = 2
const SpeedBoost = 4
const ExtraLife = 8

func _ready():
	get_node("PopAnimationPlayer").play("Pop")
	set_process(true)

func _process(delta):
	if(!get_node("AnimationPlayer").is_playing()):
		get_node("AnimationPlayer").play("Blink")

func SetPowerUpType(type):
	if(type == BombRange):
		var bombRangeRes = load("res://Map/Collectibles/powerups/pup_range.png")
		set_texture(bombRangeRes)
		PowerUpType = 1
		
	elif(type == ExtraBomb):
		var bombRangeRes = load("res://Map/Collectibles/powerups/pup_bomb.png")
		set_texture(bombRangeRes)
		PowerUpType = 2
		
	elif(type == SpeedBoost):
		var bombRangeRes = load("res://Map/Collectibles/powerups/pup_speed.png")
		set_texture(bombRangeRes)
		PowerUpType = 4	
	else:
		var bombRangeRes = load("res://Map/Collectibles/powerups/pup_life.png")
		set_texture(bombRangeRes)
		PowerUpType = 8

func OnTouch():
	if(!IsTouched):
		get_node("SamplePlayer2D").play("power_up")
	.OnTouch()

func IsSoundFinished():
	return !get_node("SamplePlayer2D").is_voice_active(0)