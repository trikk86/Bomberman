extends Node2D

#preloads

var bombs = preload("res://Resources/Bomb.res")
var explosions = preload("res://Resources/Explosion.res")

#end

#export variables

export var Time = 240
export var bombTime = 3

#end

#nodes

var mainNode 
var playerNode
var timer
var globalVariables

#end

#variables

var enemies = Array()
var bombsArray = Array()
var bombIterator = 0;

#end

#_ready function

func _ready():
	mainNode = get_tree().get_root().get_node("Node2D")
	playerNode = mainNode.get_node("Player")
	globalVariables = get_tree().get_root().get_node("/root/Globals")
	timer = get_node("Timer")
	
	get_tree().set_pause(false)
	set_fixed_process(true)
	#var enemyNode = get_node("Path2D/PathFollow2D/KinematicBody2D")
	#enemies.append(enemyNode)
	
	#get_node("AnimationPlayer").play("Start")
	#get_node("Player/MovementPlayer").play("GoDown")
	
	timer.set_wait_time(Time)
	timer.connect("timeout", self, "TimeExpired")
	timer.start()
	
#emd

#_fixed_process function
	
func _fixed_process(delta):
	if(get_node("/root/Globals").playerLifes == 0):
		get_tree().set_pause(true)
		GameOver()
#end

#other functions

func AddBomb(position):
	
	bombIterator += 1
	var bomb = bombs.instance()
	bomb.set_name(str("bomb", bombIterator))
	var tilePositon = globalVariables.GetTilePositionFromPosition(position)
	bomb.set_pos(tilePositon)

	add_child(bomb)
	bombsArray.append(bomb)
	
	var bombArray = Array()
	bombArray.append(bomb)
	
	var bombTimer = bomb.get_node("Timer")
	
	bombTimer.connect("timeout", self, "BombExplode", bombArray)
	bombTimer.start()

func BombExplode(bomb):
	CheckCollision(bomb.get_node("RayCastBottom"))
	CheckCollision(bomb.get_node("RayCastTop"))
	CheckCollision(bomb.get_node("RayCastLeft"))
	CheckCollision(bomb.get_node("RayCastRight"))
	
	bombsArray.remove(bombsArray.find(bomb))
	remove_child(bomb)
	
	var explosion = explosions.instance()
	explosion.set_pos(bomb.get_pos())
	add_child(explosion)

func CheckCollision(node):
	if(node.is_colliding()):
		var collider = node.get_collider()
		var tile = globalVariables.GetTileIndexesFromPosition(node.get_collision_point())
		if(tile.x > 0 && tile.y > 0 ):
			print(tile)
		ResolveExplosion(collider)
		
func ResolveExplosion(collider):
	if(collider.get("isPlayer") == true):
		collider.TakeLifeMakeImmortal()
	elif(collider.get("lifes")):
		collider.lifes -= 1
		if(collider.lifes == 0):
			collider.get_parent().free()

func GameOver():
	get_tree().set_pause(true)

#end

