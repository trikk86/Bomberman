extends Node2D

#nodes

var globals
var player
var playerAnimationPlayer

#end

#board
var board={}

var barrelResource = preload("res://Resources/barrel/barrel.res")
var potResource = preload("res://Resources/pot/pot.res")
var chestResource = preload("res://Resources/chest/chest.res")
var columnResource = preload("res://Resources/column/column.res")

#end


#game

var bombsResource = preload("res://Resources/bomb/bomb.res")
var explosionResource = preload("res://Resources/explosion/explosion.res")
var explosionRayResource = preload("res://Resources/explosion/explosionRay.res")
var bombsArray = Array()
var enemiesArray = Array()
var explosionRays = Array()
var explosionIterator = 1

#end

func _ready():
	globals = get_tree().get_root().get_node("/root/Globals")
	player = get_node("Player")
	playerAnimationPlayer = get_node("Player/AnimationPlayer")
	player.TilePosition = Vector2(7,1)
	PrepareMap()
	#CheckIfTaken(Vector2(1,11))
	set_fixed_process(true)
	get_node("Timer").connect("timeout", self, "GameOver")
	get_node("AnimationPlayer").play("StartLevel")
	set_pause_mode(true)
	get_node("Timer").start()
	#board[Vector2(1,12)]= addChest(1,3)
	
func _fixed_process(delta):
	if(!get_node("AnimationPlayer").is_playing()):
		set_pause_mode(false)
		

	if(get_pause_mode() == false):
		if(globals.playerLifes == 0):
			set_pause_mode(true)
			get_node("/root/ScreenLoader").goto_scene("res://Menu/Menu.scn")
			
		CheckInput()
		if(player.DestinationTilePosition != null):
			MoveNode(delta, player)
		#MoveEnemies()
		if(player.isImmune && !player.get_node("BlinkPlayer").is_playing()):
			player.get_node("BlinkPlayer").play("Blink")
		
#input functions

func CheckInput():
	var newPosition = Vector2()
	
	if(Input.is_action_pressed("ui_down") && player.isMoving == false):
		newPosition = Vector2(player.TilePosition.x, player.TilePosition.y+1)
		if(!CheckIfTaken(newPosition, true)):
			player.DestinationTilePosition = newPosition
			
	elif(Input.is_action_pressed("ui_up") && player.isMoving == false):
		newPosition = Vector2(player.TilePosition.x, player.TilePosition.y-1)
		if(!CheckIfTaken(newPosition, true)):
			player.DestinationTilePosition = newPosition
			
	elif(Input.is_action_pressed("ui_left") && player.isMoving == false):
		newPosition = Vector2(player.TilePosition.x -1, player.TilePosition.y)
		if(!CheckIfTaken(newPosition, true)):
			player.DestinationTilePosition = newPosition
			
	elif(Input.is_action_pressed("ui_right") && player.isMoving == false):
		newPosition = Vector2(player.TilePosition.x+1 , player.TilePosition.y)
		if(!CheckIfTaken(newPosition, true)):
			player.DestinationTilePosition = newPosition
			
	if(Input.is_key_pressed(KEY_SPACE) && globals.maxBombCount > bombsArray.size() && player.isReloading == false):
		print("test")
		PlaceBomb(player.get_pos())

#end

#movement functions

func MoveNode(delta, node):
	var nodePixelPosition = globals.GetPositionFromTilePosition(node.TilePosition.x, node.TilePosition.y)
	var nodeDestinationPixelPosition = globals.GetPositionFromTilePosition(node.DestinationTilePosition.x, node.DestinationTilePosition.y)
	var nodePosition = node.get_pos()
	
	var animationPlayer = node.get_node("AnimationPlayer")
	
	if(nodePosition == nodeDestinationPixelPosition):
		node.TilePosition = node.DestinationTilePosition
		node.DestinationTilePosition = null
		node.isMoving = false
	else:
		node.isMoving = true
		
	if(node.isMoving):
		if(nodePixelPosition.y > nodeDestinationPixelPosition.y):
			nodePosition.y -= node.WalkSpeed*delta
			if(!animationPlayer.is_playing() || animationPlayer.get_current_animation() != "MoveUp"):
				animationPlayer.play("MoveUp")
		 
		elif(nodePixelPosition.y < nodeDestinationPixelPosition.y):
			nodePosition.y += node.WalkSpeed*delta
			if(!animationPlayer.is_playing() || animationPlayer.get_current_animation() != "MoveDown"):
				animationPlayer.play("MoveDown")
				
		elif(nodePixelPosition.x > nodeDestinationPixelPosition.x):
			nodePosition.x -= node.WalkSpeed*delta
			if(!animationPlayer.is_playing() || animationPlayer.get_current_animation() != "MoveLeft"):
				animationPlayer.play("MoveLeft")
				
		elif(nodePixelPosition.x < nodeDestinationPixelPosition.x):
			nodePosition.x += node.WalkSpeed*delta
			if(!animationPlayer.is_playing() || animationPlayer.get_current_animation() != "MoveRight"):
				animationPlayer.play("MoveRight")

		node.set_pos(nodePosition)

#bomb logic function

func PlaceBomb(position):
	if(player.isReloading == false):
		for bomb in bombsArray:
			if(bomb.TilePosition == position):
				return

		var bomb = bombsResource.instance()
		bomb.set_pos(globals.GetTilePositionFromPosition(position))
		bomb.TilePosition = globals.GetTileIndexesFromPosition(position)
		board[bomb.TilePosition] = bomb
		bomb.set_z(bomb.get_pos().y -1)

		add_child(bomb)
		bombsArray.append(bomb)
	
		var bombTimer = bomb.get_node("Timer")
		bombTimer.connect("timeout", self, "BombExplode", [bomb])
		bombTimer.start()
		player.isReloading = true
		player.reloadTimer.start()

func BombExplode(bomb):
	board[bomb.TilePosition] = null
	bombsArray.remove(bombsArray.find(bomb))
	remove_child(bomb)
	
	var explosion = explosionResource.instance()
	explosion.set_pos(bomb.get_pos())
	explosion.set_z(bomb.get_pos().y -1)
	explosion.TilePosition = bomb.TilePosition
	explosion.explosionId = explosionIterator
	explosionIterator += 1
	explosion.get_node("ExplosionTimer").connect("timeout", self, "ShowExplosionRays", [explosion])
	explosion.get_node("ExplosionTimer").start()
	explosion.get_node("AnimationPlayer").play("Explode")
	add_child(explosion)
	
	ResolveHit(Vector2(explosion.TilePosition.x, explosion.TilePosition.y))
	
	bomb.free()

func ShowExplosionRays(explosion):
	CheckTop(explosion)
	CheckBottom(explosion)
	CheckLeft(explosion)
	CheckRight(explosion)
	
	explosion.get_node("ClearTimer").connect("timeout", self, "ClearExplosion", [explosion])
	explosion.get_node("ClearTimer").start()
	
func CheckTop(explosion):
	var finished = false
	for i in range(1, globals.bombRange):
		if(!finished):
			var position = Vector2(explosion.TilePosition.x, explosion.TilePosition.y - i)
			if(CheckIfTaken(position, false)):
				finished = true
			elif(!CheckIfTaken(position, false) && i+1 < globals.bombRange):
				var nextPosition = Vector2(position.x, position.y-1)
				if(CheckIfTaken(nextPosition, false)):
					AddExplosionRay(explosion, "top", position, "end")
					finished = true
				else:
					AddExplosionRay(explosion, "top", position, "middle")
			elif(!CheckIfTaken(position, false) && i + 1 == globals.bombRange):
				AddExplosionRay(explosion, "top", position, "end")
			ResolveHit(position)

func CheckBottom(explosion):
	var finished = false
	for i in range(1, globals.bombRange):
		if(!finished):
			var position = Vector2(explosion.TilePosition.x, explosion.TilePosition.y + i)
			if(CheckIfTaken(position, false)):
				finished = true
			elif(!CheckIfTaken(position, false) && i+1 < globals.bombRange):
				var nextPosition = Vector2(position.x, position.y+1)
				if(CheckIfTaken(nextPosition, false)):
					AddExplosionRay(explosion, "bottom", position, "end")
					finished = true
				else:
					AddExplosionRay(explosion, "bottom", position, "middle")
			elif(!CheckIfTaken(position, false) && i + 1 == globals.bombRange):
				AddExplosionRay(explosion, "bottom", position, "end")
			ResolveHit(position)

func CheckLeft(explosion):
	var finished = false
	for i in range(1, globals.bombRange):
		if(!finished):
			var position = Vector2(explosion.TilePosition.x - i, explosion.TilePosition.y)
			if(CheckIfTaken(position, false)):
				finished = true
			elif(!CheckIfTaken(position, false) && i+1 < globals.bombRange):
				var nextPosition = Vector2(position.x - 1, position.y)
				if(CheckIfTaken(nextPosition, false)):
					AddExplosionRay(explosion, "left", position, "end")
					finished = true
				else:
					AddExplosionRay(explosion, "left", position, "middle")
			elif(!CheckIfTaken(position, false) && i + 1 == globals.bombRange):
				AddExplosionRay(explosion, "left", position, "end")
			ResolveHit(position)
	
func CheckRight(explosion):
	var finished = false
	for i in range(1, globals.bombRange):
		if(!finished):
			var position = Vector2(explosion.TilePosition.x + i, explosion.TilePosition.y)
			if(CheckIfTaken(position, false)):
				finished = true
			elif(!CheckIfTaken(position, false) && i+1 < globals.bombRange):
				var nextPosition = Vector2(position.x + 1, position.y)
				if(CheckIfTaken(nextPosition, false)):
					AddExplosionRay(explosion, "right", position, "end")
					finished = true
				else:
					AddExplosionRay(explosion, "right", position, "middle")
			elif(!CheckIfTaken(position, false) && i + 1 == globals.bombRange):
				AddExplosionRay(explosion, "right", position, "end")
			ResolveHit(position)

func AddExplosionRay(explosion, direction, position, type):
	var explosionRay = explosionRayResource.instance()
	explosionRay.explosionId = explosion.explosionId
	add_child(explosionRay)
	if(type == "end"):
		explosionRay.set_frame(3)
	else:
		explosionRay.set_frame(4)
		
	if(direction == "top"):
		explosionRay.set_rot(-PI/2)
	elif(direction == "bottom"):
		explosionRay.set_rot(PI/2)
	elif(direction == "right"):
		explosionRay.set_flip_h(true)
	
	explosionRay.set_pos(globals.GetPositionFromTilePosition(position.x, position.y))
	explosionRay.set_z(position.y -1)
	explosionRays.append(explosionRay)
	
func ClearExplosion(explosion):
	for ray in explosionRays:
		if(ray.explosionId == explosion.explosionId):
			remove_child(ray)
			ray.free()
			explosionRays.erase(ray)
	remove_child(explosion)
	explosion.free()

#end

func ResolveHit(pos):
	if(board[pos] != null && board[pos].get("HitPoints")):
		board[pos].HitPoints -= 1
		if(board[pos].HitPoints == 0):
			if(board[pos].get("IsBomb") == true):
				board[pos].get_node("Timer").stop()
				BombExplode(board[pos])
			else:
				board[pos].free()
				board[pos] = null

	if(player.TilePosition == pos):
		player.LoseLife()
	
func CheckIfTaken(pos, areBombsBlocking):
	if((pos.x < 1 || pos.x >13) || (pos.y < 1 || pos.y > 11)):
		return true

	if(board[pos] != null && board[pos].get("IsBlocking") == true):
		if(areBombsBlocking):
			return true
		else:
			if(board[pos].get("IsBomb") == true):
				return false
			return true
	return false
	
func GameOver():
	set_pause_mode(true)



















func CreateElement(type, x, y):
	var instance
	if(type == "chest"):
		instance = chestResource.instance()
	elif(type == "pot"):
		instance = potResource.instance()
	elif(type == "barrel"):
		instance = barrelResource.instance()
	elif(type == "column"):
		instance = columnResource.instance()
		
	add_child(instance)
	instance.set_pos(globals.GetPositionFromTilePosition(x,y))
	instance.set_z(x)
	return instance
	
func PrepareMap():
	for i in range(1, 13): 
		for j in range (1, 11):
			if(i % 2 == 0 && j % 2 == 0):
				board[Vector2(i,j)] = CreateElement("column",i,j)
			else:
				board[Vector2(i,j)] = null
