extends Node

var map
var timer 
var hud
var player

var globals

#state

var isOver = false
var isPaused = false
var isComplete = false

var TimeLeft = 240

func _ready():
	map = get_node("Map")
	timer = get_node("Timer")
	hud = get_node("HUD")
	player = get_node("Player")
	get_node("Pause").hide()
	
	set_process_input(true)
	globals = get_tree().get_root().get_node("/root/Globals")
	
	player.TilePosition = Vector2(7,1)
	player.BombPosition = Vector2(7,1)
	player.set_pos(map.GetPositionFromTilePosition(7,1))
	
	set_fixed_process(true)
	get_node("InputTimer").connect("timeout", self, "EnablePause")
	
	timer.connect("timeout", self, "UpdateTime")
	timer.start()

func _fixed_process(delta):
	CheckFinish()
	hud.UpdateHUD(globals.playerLifes, TimeLeft, globals.points)
	if(!isComplete):
		if(player.DestinationTilePosition != null):
			map.MoveNode(player, delta)
		map.MoveEnemies(player, delta)
		CheckInput()
		
func _input(event):
	if(event.type == 1 && !event.is_pressed() && event.scancode == KEY_ESCAPE && !event.is_echo() && !isPaused):
		PauseGame()
		
	if(event.type == 1 && event.is_pressed() && event.scancode == KEY_SPACE && !event.is_echo() && globals.maxBombCount > GetActiveBombCount()  && player.isReloading == false):
		PlaceBomb(player.BombPosition)

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
				set_process_input(false)
				timer.stop()
				isComplete = true
				get_node("LevelComplete").show()
				get_node("LevelComplete").Complete(TimeLeft)
				get_tree().set_pause(true)

func OnFinished():
	get_tree().set_pause(false)
	
func UpdateTime():
	TimeLeft -= 1
	if(TimeLeft == 0):
		GameOver()

func EnablePause():
	isPaused = false

func PauseGame():
	isPaused = true
	get_node("Pause").show()
	get_node("Timer").stop()
	get_tree().set_pause(true)

func UnpauseGame():
	get_node("InputTimer").start()
	get_node("Pause").hide()
	get_tree().set_pause(false)
	
	timer.start()

func GameOver():
	get_node("GameOver").show()
	isOver = true
	get_tree().set_pause(true)

