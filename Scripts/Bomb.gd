extends Node2D

var mainNode
var playerNode
var globalVariables

var TilePosition = Vector2()

func _ready():
	mainNode = get_tree().get_root().get_node("Node2D")
	playerNode = mainNode.get_node("Player")
	globalVariables = get_tree().get_root().get_node("/root/Globals")
	
	var timer = get_node("Timer")
	timer.set_wait_time(3)
	timer.set_one_shot(true)

	get_node("AnimationPlayer").play("Detonate")
	get_node("Sprite/BombBody").add_collision_exception_with(playerNode)
	
	get_node("RayCastBottom").set_cast_to(Vector2(0, globalVariables.bombRange *32))
	get_node("RayCastLeft").set_cast_to(Vector2(0, globalVariables.bombRange *32))
	get_node("RayCastRight").set_cast_to(Vector2(0, globalVariables.bombRange *32))
	get_node("RayCastTop").set_cast_to(Vector2(0, globalVariables.bombRange *32))
	
	set_fixed_process(true)
	
func _fixed_process(delta):
	if(!get_node("Sprite/Area2D").overlaps_body(playerNode)):
			get_node("Sprite/BombBody").remove_collision_exception_with(playerNode)


