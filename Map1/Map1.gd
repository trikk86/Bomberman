extends Area2D

var gridX = 16
var gridY = 16

var bombs = preload("res://Resources/Bomb.res")

var enemies = Array()
var bombIterator = 0;

func _ready():
	get_tree().set_pause(false)
	set_process(true)
	var enemyNode = get_node("Path2D/PathFollow2D/KinematicBody2D")
	enemies.append(enemyNode)
	
func _process(delta):
	if(get_node("/root/Globals").playerLifes == 0):
		get_tree().set_pause(true)
		get_node("/root/ScreenLoader").goto_scene("res://Menu.scn")

func AddBomb(position):
	bombIterator += 1
	var bomb = bombs.instance()
	bomb.set_name(str("bomb", bombIterator))
	bomb.set_pos(position)
	add_child(bomb)
	var bombArray = Array()
	bombArray.append(bomb)
	var timer = Timer.new()
	timer.set_wait_time(2)
	timer.set_one_shot(true)
	timer.connect("timeout", self, "BombExplode", bombArray)
	add_child(timer)
	timer.start()

func BombExplode(bombs):
	remove_child(bombs)