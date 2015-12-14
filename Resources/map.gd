extends Node2D

#nodes

var globals
var player
var playerAnimationPlayer
var samplePlayer

#end

#game
var bombsArray = Array()

var explosionRays = Array()
var explosionIterator = 1

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

#input functions
#collision functions

func CheckCollision(playerPosition):
			
	for enemy in enemiesArray:
		if(enemy.TilePosition == playerPosition):
			player.LoseLife()

#region enemies

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