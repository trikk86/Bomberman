extends Node

var map
var timer 
var hud
var player

var globals

#state

var isOver = false

var TimeLeft = 240

func _ready():
	map = get_node("Map")
	timer = get_node("Timer")
	hud = get_node("HUD")
	player = get_node("Player")
	
	globals = get_tree().get_root().get_node("/root/Globals")
	
	player.TilePosition = Vector2(7,1)
	player.BombPosition = Vector2(7,1)
	player.set_pos(map.GetPositionFromTilePosition(7,1))
	
	set_fixed_process(true)
	set_process_input(true)
	pass
	
func _fixed_process(delta):
	CheckFinish()
	hud.UpdateHUD(globals.playerLifes, TimeLeft, globals.points)
	if(player.DestinationTilePosition != null):
		map.MoveNode(player, delta)
	map.MoveEnemies(player, delta)
	CheckInput()
		
func _input(event):
	if(event.type == 1 && !event.is_pressed() && event.scancode == KEY_ESCAPE && !event.is_echo()):
		if(get_tree().is_paused()):
			UnpauseGame()
		else:
			PauseGame()

func CheckInput():
	var newPosition = Vector2()
	
	if(Input.is_action_pressed("ui_down") && !player.isMoving):
		newPosition = Vector2(player.TilePosition.x, player.TilePosition.y+1)
		if(!map.CheckIfTaken(newPosition)):
			player.DestinationTilePosition = newPosition

	elif(Input.is_action_pressed("ui_up") && !player.isMoving):
		newPosition = Vector2(player.TilePosition.x, player.TilePosition.y-1)
		if(!map.CheckIfTaken(newPosition)):
			player.DestinationTilePosition = newPosition

	elif(Input.is_action_pressed("ui_left") && !player.isMoving):
		newPosition = Vector2(player.TilePosition.x -1, player.TilePosition.y)
		if(!map.CheckIfTaken(newPosition)):
			player.DestinationTilePosition = newPosition

	elif(Input.is_action_pressed("ui_right") && !player.isMoving):
		newPosition = Vector2(player.TilePosition.x+1 , player.TilePosition.y)
		if(!map.CheckIfTaken(newPosition)):
			player.DestinationTilePosition = newPosition

	if(Input.is_action_pressed("place_bomb") && globals.maxBombCount > GetActiveBombCount()  && player.isReloading == false):
		PlaceBomb(player.BombPosition)

func GetActiveBombCount():
	var counter = 0
	for bomb in map.bombs:
		if(!bomb.IsExploded):
			counter += 1
	return counter

func PlaceBomb(position):
	if(player.isReloading == false):
		for bomb in map.bombs:
			if(bomb.TilePosition == player.BombPosition && bomb.is_visible()):
				return
		map.AddNode("bomb", position)
		player.isReloading = true
		player.reloadTimer.start()

func CheckFinish():
	if(globals.playerLifes == 0 && !isOver):
		GameOver()
	if(map.enemies.size() == 0 ):
		if(map.exit != null):
			if(player.TilePosition == map.exit.TilePosition):
				set_pause_mode(true)
				timer.stop()
				if(TimeLeft > 0):
					globals.points += 1
					TimeLeft -= 1
				else:
					globals.level += 1
				#get_node("/root/ScreenLoader").goto_scene("res://Resources/levelsplash/levelsplash.res")

func UpdateTime():
	TimeLeft -= 1
	if(TimeLeft == 0):
		GameOver()

func PauseGame():
	get_tree().set_pause(true)
	get_node("Pause").show()
	get_node("Timer").stop()

func UnpauseGame():
	get_tree().set_pause(false)
	get_node("Pause").hide()
	get_node("Timer").start()

func GameOver():
	get_node("GameOver").show()
	isOver = true
	get_tree().set_pause(true)

