extends Node

var board={}
	
var globals

const terrainTileElement = preload("res://Map/Terrain/terrainTileElement.gd")
const collectibleTileElement = preload("res://Map/Collectibles/collectibleTileElement.gd")
const tileElement = preload("res://Map/tileElement.gd")

var barrelResource = preload("res://Map/Terrain/barrel/barrel.res")
var potResource = preload("res://Map/Terrain/pot/pot.res")
var chestResource = preload("res://Map/Terrain/chest/chest.res")
var columnResource = preload("res://Map/Terrain/column/column.res")
var exitResource = preload("res://Map/Terrain/exit/exit.res")
var openBoxResource = preload("res://Map/Terrain/openbox/openbox.res")
var closedBoxResource = preload("res://Map/Terrain/closedbox/closedbox.res")

var powerUpResource = preload("res://Map/Collectibles/powerups/powerup.res")
var coinResource = preload("res://Map/Collectibles/coin/coin.res")

var mushroomResource = preload("res://Map/Models/mushroom/mushroom.res")
var beholderResource = preload("res://Map/Models/beholder/beholder.res")

var bombsResource = preload("res://Map/Terrain/bomb/bomb.res")
var explosionResource = preload("res://Map/Misc/explosion/explosion.res")
var explosionRayResource = preload("res://Map/Misc/explosion/explosionray.res")
var explosionEndResource = preload("res://Map/Misc/explosion/explosionend.res")

var enemies = Array()
var collectibles = Array()
var bombs = Array()

var exit = null

var spawnCount = 0

func _ready():
	globals = get_tree().get_root().get_node("/root/Globals")
	
	for i in range(1, 13): 
		for j in range (1, 11):
			if(i % 2 == 0 && j % 2 == 0):
				CreateElement("column",i,j)

	set_fixed_process(true)


#Pathing

func GetEnemyDestinationTileLocation(node, destinationPosition):
	if(node.AILevel == 2):
		node.DestinationTilePosition = GetShortestPath(node.TilePosition, destinationPosition)
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
	if(!CheckIfTaken(upField)):
		if(!upField in queue || queue[upField] > nextIteration ):
			queue[upField] = nextIteration
			directionArray.append(upField)
			
	var downField = Vector2(currentPosition.x, currentPosition.y + 1)
	if(!CheckIfTaken(downField)):
		if(!downField in queue || queue[downField] > nextIteration):
			queue[downField] = nextIteration
			directionArray.append(downField)
				
	var leftField = Vector2(currentPosition.x - 1, currentPosition.y)
	if(!CheckIfTaken(leftField)):
		if(!leftField in queue || queue[leftField] > nextIteration):
			queue[leftField] = nextIteration
			directionArray.append(leftField)
				
	var rightField = Vector2(currentPosition.x + 1, currentPosition.y)
	if(!CheckIfTaken(rightField)):
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
	if(!CheckIfTaken(upField)):
		directionArray.append(upField)
			
	var downField = Vector2(tilePosition.x, tilePosition.y + 1)
	if(!CheckIfTaken(downField)):
		directionArray.append(downField)
				
	var leftField = Vector2(tilePosition.x - 1, tilePosition.y)
	if(!CheckIfTaken(leftField)):
		directionArray.append(leftField)
				
	var rightField = Vector2(tilePosition.x + 1, tilePosition.y)
	if(!CheckIfTaken(rightField)):
		directionArray.append(rightField)
		
	randomize()
	
	if(directionArray.size() != 0):
		var randomDirection = randi() % directionArray.size()
		return directionArray[randomDirection]

	return null

func MoveNode(node, delta):
	var nodePixelPosition = GetPositionFromTilePosition(node.TilePosition.x, node.TilePosition.y)
	var nodeDestinationPixelPosition = GetPositionFromTilePosition(node.DestinationTilePosition.x, node.DestinationTilePosition.y)
	var nodePosition = node.get_pos()
	
	var stop = false
	
	if(node.direction == "up" && nodePosition.y <= nodeDestinationPixelPosition.y):
		stop = true
		
	if(node.direction == "down" && nodePosition.y >= nodeDestinationPixelPosition.y):
		stop = true
		
	if(node.direction == "left" && nodePosition.x <= nodeDestinationPixelPosition.x):
		stop = true
		
	if(node.direction == "right" && nodePosition.x >= nodeDestinationPixelPosition.x):
		stop = true
	
	if(stop):
		node.set_pos(nodeDestinationPixelPosition)
		node.direction = null
		node.TilePosition = node.DestinationTilePosition
		node.DestinationTilePosition = null
		node.isMoving = false
		node.set_z(node.TilePosition.y + 2)
		
		if(node.isPlayer):
			node.BombPosition = Vector2(node.TilePosition.x, node.TilePosition.y)
			if(globals.isSpeedBoostScheduled):
				globals.isSpeedBoostScheduled = false
				globals.walkSpeed = globals.walkSpeed * 2
	else:
		node.isMoving = true
	
	if(node.isPlayer):
		node.WalkSpeed = globals.walkSpeed
		if(abs(nodePosition.x - nodeDestinationPixelPosition.x) < 16 && abs(nodePosition.y - nodeDestinationPixelPosition.y) < 16):
			if(node.DestinationTilePosition != null):
				CheckTile(node.DestinationTilePosition)
				node.BombPosition = Vector2(node.DestinationTilePosition.x, node.DestinationTilePosition.y)
				node.set_z(node.DestinationTilePosition.y + 2)
		else:
			node.BombPosition = Vector2(node.TilePosition.x, node.TilePosition.y)
	
	if(node.isMoving):
		if(nodePixelPosition.y > nodeDestinationPixelPosition.y):
			nodePosition.y -= node.WalkSpeed*delta
			node.MoveUp()
		 
		elif(nodePixelPosition.y < nodeDestinationPixelPosition.y):
			nodePosition.y += node.WalkSpeed*delta
			node.MoveDown()
				
		elif(nodePixelPosition.x > nodeDestinationPixelPosition.x):
			nodePosition.x -= node.WalkSpeed*delta
			node.MoveLeft()
				
		elif(nodePixelPosition.x < nodeDestinationPixelPosition.x):
			nodePosition.x += node.WalkSpeed*delta
			node.MoveRight()

		node.set_pos(nodePosition)

#map creation and helpers

func AddNode(type, position, subType = null, subType2 = null):
	var instance
	if(type == "bomb"):
		instance = bombsResource.instance()
		bombs.append(instance)
		if(!globals.remoteDetonation):
			instance.get_node("Timer").connect("timeout", self, "BombExplode", [instance])
			instance.get_node("Timer").start()
		else:
			instance.IsRemoteDetonated = true
		board[position] = instance
		
	if(type == "coin"):
		instance = coinResource.instance()
		collectibles.append(instance)
		
	if(type == "powerup"):
		instance = powerUpResource.instance()
		instance.SetPowerUpType(subType)
		collectibles.append(instance)
		
	if(type == "explosion"):
		if(subType2 == "end"):
			instance = explosionEndResource.instance()
		elif(subType2 == "middle"):
			instance = explosionRayResource.instance()
		else:
			instance = explosionResource.instance()
		if(subType == "left"):
			instance.set_rot(-PI/2)
		elif(subType == "right"):
			instance.set_rot(PI/2)
		elif(subType == "top"):
			instance.set_flip_v(true)
		
		instance.get_node("Timer").connect("timeout", self, "RemoveNode", [instance])
		instance.get_node("Timer").start()
		
	if(type == "exit"):
		instance = exitResource.instance()
	
	instance.set_pos(GetPositionFromTilePosition(position.x, position.y))
	instance.TilePosition = position
	instance.set_z(position.y)
	add_child(instance)
	
	return instance

func RemoveNode(node):
	node.queue_free()

func CreateElement(type, x, y, powerUp = null):
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
	elif(type =="exit"):
		instance = exitResource.instance()
		exit = instance
	if(powerUp != null):
		if(powerUp == "BombRange"):
			instance.PowerUpType = 1
		elif(powerUp == "ExtraBomb"):
			instance.PowerUpType = 2
		elif(powerUp == "SpeedBoost"):
			instance.PowerUpType = 4
		elif(powerUp == "ExtraLife"):
			instance.PowerUpType = 8
	
	add_child(instance)
	instance.set_pos(GetPositionFromTilePosition(x,y))
	instance.set_z(y)
	instance.TilePosition = Vector2(x,y)
	board[instance.TilePosition] = instance

func SpawnEnemy(type, x, y):
	var instance
	if(type == "Mushroom"):
		instance = mushroomResource.instance()
	if(type == "Beholder"):
		instance = beholderResource.instance()
		
	add_child(instance)
	instance.set_pos(GetPositionFromTilePosition(x,y))
	instance.TilePosition = Vector2(x,y)
	enemies.append(instance)
	instance.set_z(y)
	return instance

func GetTilePositionFromPosition(position):
	var x = round((position.x - 16)/32)
	var y = round((position.y - 80)/32)
	
	var tilePosition = Vector2()
	
	tilePosition.x = 16 + (x *32)
	tilePosition.y = 80 + (y *32)
	
	return tilePosition

func GetPositionFromTilePosition(x,y):
	var position = Vector2()
	
	position.x = x*32 + 16
	position.y = y*32 + 80
	
	return position
	
#end region

