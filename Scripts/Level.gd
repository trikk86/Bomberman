extends Node2D

var gridX = 4
var gridY = 4

export var Time = 240

var bombs = preload("res://Resources/Bomb.res")

var enemies = Array()
var bombsArray = Array()
var bombIterator = 0;

func _ready():
	get_tree().set_pause(false)
	set_fixed_process(true)
	var enemyNode = get_node("Path2D/PathFollow2D/KinematicBody2D")
	enemies.append(enemyNode)
	
	#get_node("AnimationPlayer").play("Start")
	#get_node("Player/MovementPlayer").play("GoDown")
	
	var timer = get_node("Timer")
	timer.set_wait_time(Time)
	timer.connect("timeout", self, "GameOver")
	timer.start()
	
	
	
func _fixed_process(delta):
	if(get_node("/root/Globals").playerLifes == 0):
		get_tree().set_pause(true)
		get_node("/root/ScreenLoader").goto_scene("res://Menu.scn")
	for bomb in bombsArray:
		if(!bomb.get_node("Area2D").overlaps_body(get_node("Player"))):
			bomb.get_node("StaticBody2D").remove_collision_exception_with(get_node("Player"))
	
func AddBomb():
	bombIterator += 1
	var bomb = bombs.instance()
	var playerNode = get_node("Player")
	playerNode.add_collision_exception_with(bomb)
	var position = playerNode.get_pos()
	bomb.set_name(str("bomb", bombIterator))
	var bombTileX = (int(position.x + 31.339235))/5
	var bombTileY = (int(position.y + 22.384819))/5

	print(str(position.x, ":", bombTileX, ",", position.y, ":", bombTileY))
	var newPosition = Vector2()
	newPosition.x = bombTileX *5 - 26.883186
	newPosition.y = bombTileY *5 - 22.403492
	bomb.set_pos(newPosition)
	bomb.get_node("StaticBody2D").add_collision_exception_with(get_node("Player"))

	
	add_child(bomb)
	bombsArray.append(bomb)
	var bombArray = Array()
	bombArray.append(bomb)
	var timer = Timer.new()
	timer.set_wait_time(5)
	timer.set_one_shot(true)
	timer.connect("timeout", self, "BombExplode", bombArray)
	add_child(timer)
	timer.start()

func BombExplode(bombs):
	bombsArray.remove(bombsArray.find(bombs))
	remove_child(bombs)
	
func GameOver():
	get_tree().set_pause(true)