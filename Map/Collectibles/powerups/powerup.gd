extends "res://Map/Collectibles/collectibleTileElement.gd"

const BombRange= 1
const ExtraBomb = 2
const SpeedBoost = 4
const ExtraLife = 8
const RemoteDetonation = 16

func _ready():
	get_node("PopAnimationPlayer").play("Pop")
	set_process(true)

func _process(delta):
	if(!get_node("AnimationPlayer").is_playing()):
		get_node("AnimationPlayer").play("Blink")

func SetPowerUpType(type):
	var texture
	if(type == BombRange):
		texture = load("res://Map/Collectibles/powerups/pup_range.png")
		PowerUpType = 1
		
	elif(type == ExtraBomb):
		texture = load("res://Map/Collectibles/powerups/pup_bomb.png")
		PowerUpType = 2
	elif(type == SpeedBoost):
		texture = load("res://Map/Collectibles/powerups/pup_speed.png")
		PowerUpType = 4	
	elif(type == ExtraLife):
		texture = load("res://Map/Collectibles/powerups/pup_life.png")
		PowerUpType = 8
	elif(type == RemoteDetonation):
		texture = load("res://Map/Collectibles/powerups/pup_remote.png")
		PowerUpType = 16
		
	set_texture(texture)

func OnTouch():
	if(!IsTouched):
		get_node("SamplePlayer2D").play("power_up")
	.OnTouch()

func IsSoundFinished():
	return !get_node("SamplePlayer2D").is_voice_active(0)