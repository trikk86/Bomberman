extends Node2D

#nodes

var globals
var player
var playerAnimationPlayer
var samplePlayer

#end

#board
var board={}

var barrelResource = preload("res://Resources/barrel/barrel.res")
var potResource = preload("res://Resources/pot/pot.res")
var chestResource = preload("res://Resources/chest/chest.res")
var columnResource = preload("res://Resources/column/column.res")
var exitResource = preload("res://Resources/exit/exit.res")
var openBoxResource = preload("res://Resources/openbox/openbox.res")
var closedBoxResource = preload("res://Resources/closedbox/closedbox.res")
var powerUpResource = preload("res://Resources/powerups/powerup.res")
var coinResource = preload("res://Resources/coin/coin.res")

var goblinResource = preload("res://Resources/goblin/goblin.res")
var beholderResource = preload("res://Resources/beholder/beholder.res")

#end

#game

var bombsResource = preload("res://Resources/bomb/bomb.res")
var explosionResource = preload("res://Resources/explosion/explosion.res")
var explosionRayResource = preload("res://Resources/explosion/explosionRay.res")
var bombsArray = Array()
var enemiesArray = Array()
var explosionRays = Array()
var explosionIterator = 1

var powerUpsArray = Array()

var coinsArray = Array()

var exit = null

var isPaused = false
var isOver = false

var timeLeft

#end

func _ready():
	#set nodes
	
	globals = get_tree().get_root().get_node("/root/Globals")
	player = get_node("Player")
	playerAnimationPlayer = get_node("Player/AnimationPlayer")
	samplePlayer = get_node("SamplePlayer2D")
	
	#end
	
	#generate map
	
	PrepareMap()
	
	#end
	
	#set start values
	
	player.TilePosition = Vector2(7,1)
	get_node("Timer").connect("timeout", self, "GameOver")
	get_node("AnimationPlayer").play("StartLevel")
	set_pause_mode(true)
	get_node("Timer").start()
	
	set_fixed_process(true)
	
	#end
	
func _fixed_process(delta):
	if(!get_node("AnimationPlayer").is_playing()):
		set_pause_mode(false)

	if(get_pause_mode() == false && !isOver && !isPaused):
		CheckInput()
		CheckFinish()
		CheckPowerUps()
		MoveEnemies(delta)
		UpdateTimer()
		
		if(player.DestinationTilePosition != null):
			MoveNode(delta, player)

		if(player.isImmune && !player.get_node("BlinkPlayer").is_playing()):
			player.get_node("BlinkPlayer").play("Blink")

#input functions

func UpdateTimer():
	if(get_node("Timer").is_processing()):
		timeLeft = get_node("Timer").get_time_left()
		get_node("HUD/TimeValueLabel").SetTime(timeLeft)

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
		PlaceBomb(player.get_pos())
		
	if(Input.is_key_pressed(KEY_ESCAPE)):
		if(!isPaused):
			isPaused = true;
			set_pause_mode(true)
			get_node("Timer").stop()
		#showmenu

#end

#collision functions

func CheckCollision(playerPosition):
	for powerup in powerUpsArray:
		if(playerPosition == powerup.TilePosition):
			samplePlayer.play("power_up")
			if(powerup.PowerUpType == powerup.BombRange):
				globals.bombRange += 1
			elif(powerup.PowerUpType == powerup.ExtraBomb):
				globals.maxBombCount += 1
			elif(powerup.PowerUpType == powerup.SpeedBoost):
				player.isSpeedBoost = true
			elif(powerup.PowerUpType == powerup.ExtraLife && globals.playerLifes < globals.playerMaxLifes):
				globals.playerLifes += 1
			remove_child(powerup)
			powerUpsArray.erase(powerup)
			powerup.free()
			
	for enemy in enemiesArray:
		if(enemy.TilePosition == playerPosition):
			player.LoseLife()
			
	for coin in coinsArray:
		if(playerPosition == coin.TilePosition):
			globals.points += coin.Points
			remove_child(coin)
			coinsArray.erase(coin)
			coin.free()
			samplePlayer.play("treasure")

func CheckPowerUps():
	if(enemiesArray.size() == 0):
		for pos in board:
			if(board[pos] != null && board[pos].get("PowerUp") != null && board[pos].PowerUp > 0):
				if(!board[pos].get_node("AnimationPlayer").is_playing()):
					board[pos].get_node("AnimationPlayer").play("Blink")

func CheckFinish():
	if(globals.playerLifes == 0 && isOver == false):
		GameOver()
	if(get_node("Timer").get_time_left() == 0):
		GameOver()

	if(enemiesArray.size() == 0 && exit != null):
		exit.set_frame(1)
		if(player.TilePosition == exit.TilePosition):
			set_pause_mode(true)
			get_node("Timer").stop()
			if(timeLeft > 5):
				globals.points += 5
				timeLeft -= 5
			else:
				globals.points += timeLeft
				timeLeft = 0
			globals.level += 1
			get_node("/root/ScreenLoader").goto_scene("res://Resources/levelsplash/levelsplash.res")

func GameOver():
	if(isOver == false):
		get_node("AnimationPlayer").play("GameOver")
	isOver = true
	set_pause_mode(true)
	
#region enemies

func MoveEnemies(delta):
	for enemy in enemiesArray:
		if(enemy.TilePosition == player.TilePosition):
			player.LoseLife()
		if(!enemy.isMoving):
			GetEnemyDestinationTileLocation(enemy)
			
		if(enemy.DestinationTilePosition != null):
			MoveNode(delta, enemy)

func GetEnemyDestinationTileLocation(node):
	if(node.AILevel == 2):
		node.DestinationTilePosition = GetShortestPath(node.TilePosition, player.TilePosition)
	if(node.DestinationTilePosition == null):
		node.DestinationTilePosition = GetRandomPath(node.TilePosition)

func GetShortestPath(sourcePosition, destinationPosition):
	var queue = {}
	queue[sourcePosition] = 0
	CheckAdjastentFields(sourcePosition, destinationPosition, queue, 0)
	if(destinationPosition in queue && queue[destinationPosition] != null):
		var destination = ReversePath(queue, destinationPosition, queue[destinationPosition])
		return destination
	return null
	
func CheckAdjastentFields(currentPosition, destinationPosition, queue, currentIteration):
	if(currentPosition == destinationPosition):
		return
	
	var directionArray  = Array()
	var nextIteration = currentIteration + 1
	
	var upField = Vector2(currentPosition.x, currentPosition.y -1)
	if(!CheckIfTaken(upField, true)):
		if(!upField in queue || queue[upField] > nextIteration ):
			queue[upField] = nextIteration
			directionArray.append(upField)
			
	var downField = Vector2(currentPosition.x, currentPosition.y + 1)
	if(!CheckIfTaken(downField, true)):
		if(!downField in queue || queue[downField] > nextIteration):
			queue[downField] = nextIteration
			directionArray.append(downField)
				
	var leftField = Vector2(currentPosition.x - 1, currentPosition.y)
	if(!CheckIfTaken(leftField, true)):
		if(!leftField in queue || queue[leftField] > nextIteration):
			queue[leftField] = nextIteration
			directionArray.append(leftField)
				
	var rightField = Vector2(currentPosition.x + 1, currentPosition.y)
	if(!CheckIfTaken(rightField, true)):
		if(!rightField in queue || queue[rightField] > nextIteration):
			queue[rightField] = nextIteration
			directionArray.append(rightField)
			
	for direction in directionArray:
		CheckAdjastentFields(direction, destinationPosition, queue, nextIteration)

func ReversePath(query, destinationPosition, currentValue):
	if(currentValue == 1):
		return destinationPosition

	if(destinationPosition.y > 1):
		var upField = Vector2(destinationPosition.x, destinationPosition.y -1)
		if(upField in query && query[upField] != null &&  query[upField] == currentValue - 1):
			return ReversePath(query, upField, currentValue - 1)

	if(destinationPosition.y <11):
		var downField = Vector2(destinationPosition.x, destinationPosition.y + 1)
		if(downField in query && query[downField] != null && query[downField] == currentValue - 1):
			return ReversePath(query, downField, currentValue - 1)
				
	if(destinationPosition.x > 1):
		var leftField = Vector2(destinationPosition.x - 1, destinationPosition.y)
		if(leftField in query && query[leftField] != null && query[leftField] == currentValue - 1):
			return ReversePath(query, leftField, currentValue - 1)
				
	if(destinationPosition.x < 13):
		var rightField = Vector2(destinationPosition.x + 1, destinationPosition.y)
		if(rightField in query && query[rightField] != null && query[rightField] == currentValue - 1):
			return ReversePath(query, rightField, currentValue - 1)

func GetRandomPath(tilePosition):
	var directionArray  = Array()
	
	var upField = Vector2(tilePosition.x, tilePosition.y -1)
	if(!CheckIfTaken(upField, true)):
		directionArray.append(upField)
			
	var downField = Vector2(tilePosition.x, tilePosition.y + 1)
	if(!CheckIfTaken(downField, true)):
		directionArray.append(downField)
				
	var leftField = Vector2(tilePosition.x - 1, tilePosition.y)
	if(!CheckIfTaken(leftField, true)):
		directionArray.append(leftField)
				
	var rightField = Vector2(tilePosition.x + 1, tilePosition.y)
	if(!CheckIfTaken(rightField, true)):
		directionArray.append(rightField)
		
	randomize()
	if(directionArray.size() != 0):
		var randomDirection = randi()%directionArray.size()
		return directionArray[randomDirection]
		
	return null

#end region enemies

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
		
		if(node == player && node.isSpeedBoost):
				node.isSpeedBoost = false
				node.WalkSpeed = node.WalkSpeed * 2
	else:
		node.isMoving = true
		
	if(abs(nodePosition.x - nodeDestinationPixelPosition.x) < 16 && abs(nodePosition.y - nodeDestinationPixelPosition.y) < 16):
		if(node == player):
			CheckCollision(node.DestinationTilePosition)

	
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

#end movement function

#bomb logic function

func PlaceBomb(position):
	if(player.isReloading == false):
		for bomb in bombsArray:
			if(bomb.TilePosition == player.TilePosition):
				return

		var bomb = bombsResource.instance()
		bomb.set_pos(globals.GetTilePositionFromPosition(position))
		bomb.TilePosition = globals.GetTileIndexesFromPosition(position)
		board[bomb.TilePosition] = bomb
		bomb.set_z(0)

		add_child(bomb)
		bombsArray.append(bomb)
	
		var bombTimer = bomb.get_node("Timer")
		
		bombTimer.connect("timeout", self, "BombExplode", [bomb])
		bombTimer.start()
		
		player.isReloading = true
		player.reloadTimer.start()

func BombExplode(bomb):
	samplePlayer.play("explosion2")
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

	
	ResolveBombHit(Vector2(explosion.TilePosition.x, explosion.TilePosition.y))
	
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
				else:
					AddExplosionRay(explosion, "top", position, "middle")
			elif(!CheckIfTaken(position, false) && i + 1 == globals.bombRange):
				AddExplosionRay(explosion, "top", position, "end")
			ResolveBombHit(position)

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
				else:
					AddExplosionRay(explosion, "bottom", position, "middle")
			elif(!CheckIfTaken(position, false) && i + 1 == globals.bombRange):
				AddExplosionRay(explosion, "bottom", position, "end")
			ResolveBombHit(position)

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
				else:
					AddExplosionRay(explosion, "left", position, "middle")
			elif(!CheckIfTaken(position, false) && i + 1 == globals.bombRange):
				AddExplosionRay(explosion, "left", position, "end")
			ResolveBombHit(position)

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
				else:
					AddExplosionRay(explosion, "right", position, "middle")
			elif(!CheckIfTaken(position, false) && i + 1 == globals.bombRange):
				AddExplosionRay(explosion, "right", position, "end")
			ResolveBombHit(position)

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

func ResolveBombHit(pos):
	if(pos in board && board[pos] != null && board[pos].get("HitPoints")):
		board[pos].HitPoints -= 1
		if(board[pos].HitPoints == 0):
			if(board[pos].get("IsBomb") == true):
				board[pos].get_node("Timer").stop()
				BombExplode(board[pos])
			else:
				if(board[pos].get("IsExit") == true):
					var exitNode = exitResource.instance()
					exitNode.TilePosition = pos
					exitNode.set_pos(globals.GetPositionFromTilePosition(pos.x, pos.y))
					add_child(exitNode)
					exit = exitNode
				elif(board[pos].get("PowerUp") != null && board[pos].get("PowerUp") > 0):
					var powerUpNode = powerUpResource.instance()
					powerUpNode.TilePosition = pos

					powerUpsArray.append(powerUpNode)
					add_child(powerUpNode)
					powerUpNode.SetPowerUpType(board[pos].get("PowerUp"))
					powerUpNode.set_pos(globals.GetPositionFromTilePosition(pos.x, pos.y))
					#powerUpNode.get_node("PopAnimationPlayer").play("Pop")
				
				if(board[pos].get("HasGold") != null):
					board[pos].get_node("Timer").connect("timeout", self, "Remove", [board[pos]])
					board[pos].get_node("Timer").start()
					
					var coin = coinResource.instance()
					coin.TilePosition = pos
					coin.set_z(pos.y + 2)
					coinsArray.append(coin)
					add_child(coin)
					coin.set_pos(globals.GetPositionFromTilePosition(pos.x, pos.y))
				else:
					board[pos].free()
					board[pos] = null

	if(player.TilePosition == pos):
		player.LoseLife()
		
	for enemy in enemiesArray:
		if(pos == enemy.TilePosition):
			enemy.HitPoints -= 1
			print(enemy.HitPoints)
			if(enemy.HitPoints == 0):
				globals.points += enemy.Points
				enemiesArray.erase(enemy)
				remove_child(enemy)
				enemy.free()

func Remove(node):
	board[node.TilePosition] = null
	node.free()
	remove_child(node)

#end bomb logic
	
func CheckIfTaken(pos, areBombsBlocking):
	if((pos.x < 1 || pos.x >13) || (pos.y < 1 || pos.y > 11)):
		return true
		
	if(pos in board):
		if(board[pos] != null && board[pos].get("IsBlocking") == true):
			if(areBombsBlocking):
				return true
			else:
				if(board[pos].get("IsBomb") == true):
					return false
				return true
	return false

#region mapgeneration

func CreateElement(type, x, y, isExit = false, powerUp = null):
	var instance
	if(type == "chest"):
		instance = chestResource.instance()
	elif(type == "pot"):
		instance = potResource.instance()
	elif(type == "barrel"):
		instance = barrelResource.instance()
	elif(type == "column"):
		instance = columnResource.instance()
	elif(type == "openbox"):
		instance = openBoxResource.instance()
	elif(type == "closedbox"):
		instance = closedBoxResource.instance()
	
	if(powerUp != null && instance.get("PowerUp") != null):
		if(powerUp == "BombRange"):
			instance.PowerUp = 1
		elif(powerUp == "ExtraBomb"):
			instance.PowerUp = 2
		elif(powerUp == "SpeedBoost"):
			instance.PowerUp = 4
		elif(powerUp == "ExtraLife"):
			instance.PowerUp = 8
		
	if(isExit == true):
		instance.IsExit = true
	
	add_child(instance)
	instance.set_pos(globals.GetPositionFromTilePosition(x,y))
	instance.set_z(y)
	instance.TilePosition = Vector2(x,y)
	board[instance.TilePosition] = instance
	
func SpawnEnemy(type, x, y):
	var instance
	if(type == "Goblin"):
		instance = goblinResource.instance()
	if(type == "Beholder"):
		instance = beholderResource.instance()
		
	add_child(instance)
	instance.set_pos(globals.GetPositionFromTilePosition(x,y))
	instance.set_z(y)
	instance.TilePosition = Vector2(x,y)
	enemiesArray.append(instance)
	
func PrepareMap():
	for i in range(1, 13): 
		for j in range (1, 11):
			if(i % 2 == 0 && j % 2 == 0):
				CreateElement("column",i,j, false, null)
				
	CreateElement("chest",1,1)
	CreateElement("barrel",1,2)
	CreateElement("barrel",1,3)
	CreateElement("closedbox",1,5)
	CreateElement("chest",1,6)
	SpawnEnemy("Goblin", 1,7)
	CreateElement("chest",1,8)
	CreateElement("closedbox",1,9)
	CreateElement("barrel", 1, 11, true)
	
	CreateElement("barrel",2,1)
	CreateElement("closedbox",2,7)
	
	CreateElement("barrel",3,1)
	SpawnEnemy("Goblin", 3,3)
	CreateElement("openbox",3,5)
	CreateElement("barrel", 3,9, false, "ExtraLife")
	CreateElement("barrel", 3,11)
	
	CreateElement("closedbox", 4,3)
	CreateElement("closedbox", 4,7)
	
	CreateElement("chest",5,1)
	CreateElement("pot",5,2)
	CreateElement("closedbox", 5,6)
	CreateElement("pot",5,9)
	CreateElement("barrel", 5,11)
	
	CreateElement("pot",6,1)
	SpawnEnemy("Beholder", 6,9)
	
	CreateElement("closedbox", 7,3)
	CreateElement("openbox",7,5)
	CreateElement("closedbox", 7,6)
	CreateElement("pot",7,9)
	CreateElement("chest",7,11)
	
	CreateElement("openbox",8,7)
	CreateElement("pot",8,11)
	
	CreateElement("barrel", 9,1)
	CreateElement("closedbox", 9,6)
	CreateElement("closedbox", 9,7)
	CreateElement("pot",9,10)

	CreateElement("closedbox", 10,7)
	SpawnEnemy("Beholder", 10,11)
	
	SpawnEnemy("Goblin", 11, 1)
	CreateElement("pot", 11, 2)
	CreateElement("closedbox", 11, 7)
	CreateElement("closedbox", 11, 8)
	CreateElement("pot",11,10)
	
	CreateElement("openbox", 12, 3)
	CreateElement("closedbox", 12,5)
	CreateElement("openbox", 12, 7)
	CreateElement("pot", 12, 9)
	
	CreateElement("chest", 13,1)
	SpawnEnemy("Goblin", 13, 4)
	SpawnEnemy("Goblin", 13, 8)
	CreateElement("pot", 13, 9)
	CreateElement("closedbox", 13, 11)
	
	