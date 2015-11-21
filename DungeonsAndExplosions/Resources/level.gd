extends Node2D

#nodes

var globals
var player
var playerAnimationPlayer
var reloadTimer
var immunityTimer

#end

#board
var board={}

var barrelResource = preload("res://Resources/barrel/barrel.res")
var potResource = preload("res://Resources/pot/pot.res")
var chestResource = preload("res://Resources/chest/chest.res")

#end 

# state

var isMoving = false
var isReloading = false
var isImmune = false

#end

#movement

var PlayerTilePosition 
var PlayerDestinationTilePosition = null
var WalkSpeed = 120 #must be dividable by 6

#end

#game

var bombsResource = preload("res://Resources/bomb/bomb.res")
var explosionResource = preload("res://Resources/explosion/explosion.res")
var bombsArray = Array()

#end

func _ready():
	PlayerTilePosition = Vector2(7,1)
	
	globals = get_tree().get_root().get_node("/root/Globals")
	player = get_node("Player")
	playerAnimationPlayer = get_node("Player/AnimationPlayer")
	reloadTimer = get_node("Player/ReloadTimer")
	immunityTimer = get_node("ImmunityTimer")
	
	reloadTimer.connect("timeout", self, "Reloaded")
	immunityTimer.connect("timeout", self, "RemoveImmunity")
	
	
	PrepareMap()
	#CheckIfTaken(Vector2(1,11))
	set_fixed_process(true)

	get_node("AnimationPlayer").play("StartLevel")
	set_pause_mode(true)
	#board[Vector2(1,12)]= addChest(1,3)
	
func _fixed_process(delta):
	if(!get_node("AnimationPlayer").is_playing()):
		set_pause_mode(false)
		
	if(get_pause_mode() == false):
		CheckInput()
		if(PlayerDestinationTilePosition != null):
			CheckMove(delta)
			
	#var pos = Vector2(7,2)
	#if(pos in board):
	#	if(board[pos] != null):
	#		print(board[pos])
	if(isImmune && !player.get_node("BlinkPlayer").is_playing()):
		player.get_node("BlinkPlayer").play("Blink")
	
func CheckInput():
	var newPosition = Vector2()
	
	if(Input.is_action_pressed("ui_down") && isMoving == false && PlayerTilePosition.y < 11):
		newPosition = Vector2(PlayerTilePosition.x, PlayerTilePosition.y+1)
		if(!CheckIfTaken(newPosition)):
			PlayerDestinationTilePosition = newPosition
			
	elif(Input.is_action_pressed("ui_up") && isMoving == false && PlayerTilePosition.y > 1):
		newPosition = Vector2(PlayerTilePosition.x, PlayerTilePosition.y-1)
		if(!CheckIfTaken(newPosition)):
			PlayerDestinationTilePosition = newPosition
			
	elif(Input.is_action_pressed("ui_left") && isMoving == false && PlayerTilePosition.x > 1):
		newPosition = Vector2(PlayerTilePosition.x -1, PlayerTilePosition.y)
		if(!CheckIfTaken(newPosition)):
			PlayerDestinationTilePosition = newPosition
			
	elif(Input.is_action_pressed("ui_right") && isMoving == false && PlayerTilePosition.x < 13):
		newPosition = Vector2(PlayerTilePosition.x+1 , PlayerTilePosition.y)
		if(!CheckIfTaken(newPosition)):
			PlayerDestinationTilePosition = newPosition
			
	if(Input.is_key_pressed(KEY_SPACE) && isReloading == false &&  globals.maxBombCount > bombsArray.size()):
		PlaceBomb(player.get_pos())

func CheckMove(delta):
	var playerPixelPosition = globals.GetPositionFromTilePosition(PlayerTilePosition.x, PlayerTilePosition.y)
	var playerDestinationPixelPosition = globals.GetPositionFromTilePosition(PlayerDestinationTilePosition.x, PlayerDestinationTilePosition.y)
	var playerPosition = player.get_pos()
	
	#rework
	if(playerPosition == playerDestinationPixelPosition):
		PlayerTilePosition = PlayerDestinationTilePosition
		PlayerDestinationTilePosition = null
		isMoving = false
	else:
		isMoving = true
		
	if(isMoving):
		if(playerPixelPosition.y > playerDestinationPixelPosition.y):
			playerPosition.y -= WalkSpeed*delta
			if(!playerAnimationPlayer.is_playing() || playerAnimationPlayer.get_current_animation() != "MoveUp"):
				playerAnimationPlayer.play("MoveUp")
		 
		elif(playerPixelPosition.y < playerDestinationPixelPosition.y):
			playerPosition.y += WalkSpeed*delta
			if(!playerAnimationPlayer.is_playing() || playerAnimationPlayer.get_current_animation() != "MoveDown"):
				playerAnimationPlayer.play("MoveDown")
				
		elif(playerPixelPosition.x > playerDestinationPixelPosition.x):
			playerPosition.x -= WalkSpeed*delta
			if(!playerAnimationPlayer.is_playing() || playerAnimationPlayer.get_current_animation() != "MoveLeft"):
				playerAnimationPlayer.play("MoveLeft")
				
		elif(playerPixelPosition.x < playerDestinationPixelPosition.x):
			playerPosition.x += WalkSpeed*delta
			if(!playerAnimationPlayer.is_playing() || playerAnimationPlayer.get_current_animation() != "MoveRight"):
				playerAnimationPlayer.play("MoveRight")

		player.set_pos(playerPosition)

func PlaceBomb(position):
	var bomb = bombsResource.instance()
	bomb.set_pos(globals.GetTilePositionFromPosition(position))
	bomb.TilePosition = globals.GetTileIndexesFromPosition(position)
	board[bomb.TilePosition] = bomb

	add_child(bomb)
	bombsArray.append(bomb)
	
	var bombTimer = bomb.get_node("Timer")
		
	bombTimer.connect("timeout", self, "BombExplode", [bomb])
	bombTimer.start()
		
	isReloading = true
	reloadTimer.start()

func BombExplode(bomb):
	board[bomb.TilePosition] = null
	bombsArray.remove(bombsArray.find(bomb))
	remove_child(bomb)
	
	var explosion = explosionResource.instance()
	explosion.set_pos(bomb.get_pos())
	explosion.TilePosition = bomb.TilePosition
	CheckHit(explosion.TilePosition)
	
	explosion.get_node("ExplosionTimer").connect("timeout", self, "ShowExplosionRays", [explosion])
	explosion.get_node("ExplosionTimer").start()
	explosion.get_node("AnimationPlayer").play("Explode")
	add_child(explosion)
	
	CheckHit(Vector2(explosion.TilePosition.x, explosion.TilePosition.y))
	
	bomb.free()

func Reloaded():
	isReloading = false

func RemoveImmunity():
	isImmune = false


func ShowExplosionRays(explosion):
	for i in range(1, globals.bombRange):
		if(i == globals.bombRange - 1):
			CheckHit(Vector2(explosion.TilePosition.x, explosion.TilePosition.y - i))
		
	for i in range(1, globals.bombRange):
		if(i == globals.bombRange - 1):
			CheckHit(Vector2(explosion.TilePosition.x, explosion.TilePosition.y + i))
		
	for i in range(1, globals.bombRange):
		if(i == globals.bombRange - 1):
			CheckHit(Vector2(explosion.TilePosition.x+i, explosion.TilePosition.y))
		
	for i in range(1, globals.bombRange):
		if(i == globals.bombRange - 1):
			CheckHit(Vector2(explosion.TilePosition.x-i, explosion.TilePosition.y))
		
	explosion.get_node("ClearTimer").connect("timeout", self, "ClearExplosion", [explosion])
	explosion.get_node("ClearTimer").start()
	
func ClearExplosion(explosion):
	remove_child(explosion)
	explosion.free()


func CheckHit(pos):
	if(pos in board):
		if(board[pos] != null && board[pos].get("IsDestructble") == true):
			if(board[pos].get("HitPoints") == true):
				board[pos].HitPoints -= 1
				if(board[pos].HitPoints == 0):
					if(board[pos] == "Bomb"):
						BombExplode(board[pos])
					else:
						board[pos].free()
						board[pos] = null
	if(PlayerTilePosition == pos):
		LosePLayerLife()

func LosePLayerLife():
	if(isImmune == false):
		globals.playerLifes -= 1
		immunityTimer.start()
		isImmune = true
	#star immortality


func CheckIfTaken(pos):
	if(pos in board):
		if(board[pos] != null):
			if(board[pos].get("IsBlocking") == true):
				return true
	return false


















func CreateElement(type, x, y):
	var instance
	if(type == "chest"):
		instance = chestResource.instance()
	elif(type == "pot"):
		instance = potResource.instance()
	elif(type == "barrel"):
		instance = barrelResource.instance()
		
	add_child(instance)
	instance.set_pos(globals.GetPositionFromTilePosition(x,y))
	instance.set_z(x)
	return instance
	
func PrepareMap():
	for i in range(1, 13): 
		for j in range (1, 11):
			if(i % 2 == 0 && j % 2 == 0):
				board[Vector2(i,j)] = CreateElement("barrel",i,j)
