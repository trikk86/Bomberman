extends Sprite

const BombRange= 1
const ExtraBomb = 2
const SpeedBoost = 4
const ExtraLife = 8

var PowerUpType
var TilePosition

func _ready():
	set_process(true)
	# Initialization here
	pass

func _process(delta):
	if(!get_node("AnimationPlayer").is_playing()):
		get_node("AnimationPlayer").play("Blink")

func SetPowerUpType(type):
	if(type == BombRange):
		var bombRangeRes = load("res://Assets/Textures/pup_range.png")
		set_texture(bombRangeRes)
		PowerUpType = 1
		
	elif(type == ExtraBomb):
		var bombRangeRes = load("res://Assets/Textures/pup_bomb.png")
		set_texture(bombRangeRes)
		PowerUpType = 2
		
	elif(type == SpeedBoost):
		var bombRangeRes = load("res://Assets/Textures/pup_speed.png")
		set_texture(bombRangeRes)
		PowerUpType = 4	
	else:
		var bombRangeRes = load("res://Assets/Textures/pup_life.png")
		set_texture(bombRangeRes)
		PowerUpType = 8