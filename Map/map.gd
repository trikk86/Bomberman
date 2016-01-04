extends "res://Map/baseMap.gd"

func _ready():
	get_node("RespawnTimer").connect("timeout", self, "SpawnEnemies")

func _fixed_process(delta):
	if(enemies.size() == 0):
		for item in board:
			if(board[item] != null && board[item] extends tileElement):
				board[item].OnEnemiesCleared()
				
	for bomb in bombs:
		if(bomb.is_visible() == 0 && bomb.IsExploded && !bomb.get_node("SamplePlayer2D").is_voice_active(0)):
			bombs.erase(bomb)
			bomb.free()
			
	for enemy in enemies:
		if(enemy.HitPoints == 0 && enemy.isDeathAnimationFinished):
			globals.points += enemy.Points
			enemies.erase(enemy)
			enemy.free()
			
	for collectible in collectibles:
		if(collectible.IsTouched && collectible.IsSoundFinished()):
			collectibles.erase(collectible)
			collectible.free()

func CheckTile(tilePosition):
	for collectible in collectibles:
		if(collectible extends collectibleTileElement && tilePosition == collectible.TilePosition && !collectible.IsTouched):
			globals.points += collectible.Points
			if(collectible.PowerUpType == 1):
				globals.bombRange += 1
			elif(collectible.PowerUpType == 2):
				globals.maxBombCount += 1
			elif(collectible.PowerUpType == 4):
				globals.isSpeedBoostScheduled = true
			elif(collectible.PowerUpType == 8 && globals.playerLifes < globals.playerMaxLifes):
				globals.playerLifes += 1

			collectible.hide()
			collectible.OnTouch()

func CheckIfTaken(pos):
	if((pos.x < 1 || pos.x >13) || (pos.y < 1 || pos.y > 11)):
		return true
	if(pos in board && board[pos] != null && board[pos] extends terrainTileElement && board[pos].IsBlocking):
		return true
	return false
	
func ResolveHit(position):
	if(exit != null && exit.TilePosition == position):
		spawnCount = 3
		get_node("RespawnTimer").start()

	if(position in board && board[position] != null && board[position].is_visible()):
		board[position].OnHit()
		
		if(board[position].HitPoints == 0):
			if(board[position].PowerUpType > 0):
				AddNode("powerup", position, board[position].PowerUpType)
			if(board[position].HasPoints):
				AddNode("coin", position)
				board[position].get_node("Timer").connect("timeout", self, "RemoveNode", [board[position]])
				board[position].get_node("Timer").start()
			
			if(board[position].IsBomb):
				if(!board[position].IsExploded):
					BombExplode(board[position])
			else:
				board[position].OnDeath()
				if(!board[position].IsDelayedDeath && !board[position].IsBomb):
					board[position].free()
				board[position] = null;

func SpawnEnemies():
	if(spawnCount != 0):
		var instance = SpawnEnemy("Beholder", exit.TilePosition.x, exit.TilePosition.y)
		spawnCount -=1
	else:
		get_node("RespawnTimer").stop()

func BombExplode(bomb):
	var explosion = AddNode("explosion", bomb.TilePosition, "main")
	bomb.IsBlocking = false
	board[bomb.TilePosition] = null;
	bomb.OnDeath()
	ShowExplosionRays(explosion)

func ShowExplosionRays(explosion):
	CheckTop(explosion)
	CheckBottom(explosion)
	CheckLeft(explosion)
	CheckRight(explosion)
	
func CheckTop(explosion):
	var finished = false
	for i in range(1, globals.bombRange):
		if(!finished):
			var position = Vector2(explosion.TilePosition.x, explosion.TilePosition.y - i)
			if(CheckIfTaken(position)):
				finished = true
			elif(!CheckIfTaken(position) && i+1 < globals.bombRange):
				var nextPosition = Vector2(position.x, position.y-1)
				if(CheckIfTaken(nextPosition)):
					AddNode("explosion", position, "top", "end")
				else:
					AddNode("explosion", position, "top", "middle")
			elif(!CheckIfTaken(position) && i + 1 == globals.bombRange):
				AddNode("explosion", position, "top", "end")
			ResolveHit(position)

func CheckBottom(explosion):
	var finished = false
	for i in range(1, globals.bombRange):
		if(!finished):
			var position = Vector2(explosion.TilePosition.x, explosion.TilePosition.y + i)
			if(CheckIfTaken(position)):
				finished = true
			elif(!CheckIfTaken(position) && i+1 < globals.bombRange):
				var nextPosition = Vector2(position.x, position.y+1)
				if(CheckIfTaken(nextPosition)):
					AddNode("explosion", position, "bottom", "end")
				else:
					AddNode("explosion", position, "bottom", "middle")
			elif(!CheckIfTaken(position) && i + 1 == globals.bombRange):
				AddNode("explosion", position, "bottom", "end")
			ResolveHit(position)

func CheckLeft(explosion):
	var finished = false
	for i in range(1, globals.bombRange):
		if(!finished):
			var position = Vector2(explosion.TilePosition.x - i, explosion.TilePosition.y)
			if(CheckIfTaken(position)):
				finished = true
			elif(!CheckIfTaken(position) && i+1 < globals.bombRange):
				var nextPosition = Vector2(position.x - 1, position.y)
				if(CheckIfTaken(nextPosition)):
					AddNode("explosion", position, "left", "end")
				else:
					AddNode("explosion", position, "left", "middle")
			elif(!CheckIfTaken(position) && i + 1 == globals.bombRange):
				AddNode("explosion", position, "left", "end")
			ResolveHit(position)

func CheckRight(explosion):
	var finished = false
	for i in range(1, globals.bombRange):
		if(!finished):
			var position = Vector2(explosion.TilePosition.x + i, explosion.TilePosition.y)
			if(CheckIfTaken(position)):
				finished = true
			elif(!CheckIfTaken(position) && i+1 < globals.bombRange):
				var nextPosition = Vector2(position.x + 1, position.y)
				if(CheckIfTaken(nextPosition)):
					AddNode("explosion", position, "right", "end")
				else:
					AddNode("explosion", position, "right", "middle")
			elif(!CheckIfTaken(position) && i + 1 == globals.bombRange):
				AddNode("explosion", position, "right", "end")
			ResolveHit(position)

func MoveEnemies(player, delta):
	var destinationPosition
	if(player.DestinationTilePosition != null):
		destinationPosition = Vector2(player.DestinationTilePosition.x, player.DestinationTilePosition.y)
	else:
		destinationPosition = Vector2(player.TilePosition.x, player.TilePosition.y)
	for enemy in enemies:
		if(!enemy.isMoving && enemy.HitPoints > 0):
			GetEnemyDestinationTileLocation(enemy, destinationPosition)
			
		if(enemy.DestinationTilePosition != null):
			MoveNode(enemy, delta)

