extends Area2D

var gridX = 16
var gridY = 16

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
	
	get_node("AnimationPlayer").play("Start")
	get_node("Player/AnimationPlayer").play("GoDown")
	
	var timer = get_node("Timer")
	timer.set_wait_time(Time)
	timer.connect("timeout", self, "GameOver")
	timer.start()
	
	
	
func _fixed_process(delta):
	if(get_node("/root/Globals").playerLifes == 0):
		get_tree().set_pause(true)
		get_node("/root/ScreenLoader").goto_scene("res://Menu.scn")

		
		
func AddBomb(position):
	bombIterator += 1
	var bomb = bombs.instance()
	var playerNode = get_node("Player")
	playerNode.add_collision_exception_with(bomb)
	bomb.set_name(str("bomb", bombIterator))
	bomb.set_pos(position)
	bomb.get_node("StaticBody2D").add_collision_exception_with(get_node("Player"))

	
	add_child(bomb)
	bombsArray.append(bomb)
	var bombArray = Array()
	bombArray.append(bomb)
	bomb.get_node("Area2D").connect("body_exit", self, "RemovePlayerCollision", bombArray)
	var timer = Timer.new()
	timer.set_wait_time(5)
	timer.set_one_shot(true)
	timer.connect("timeout", self, "BombExplode", bombArray)
	add_child(timer)
	timer.start()

func BombExplode(bombs):
	remove_child(bombs)
	
func GameOver():
	get_tree().set_pause(true)
	
func RemovePlayerCollision(body):
	print("triggered")
	body.get_node("StaticBody2D").remove_collision_exception_with(get_node("Player"))