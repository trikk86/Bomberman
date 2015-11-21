extends Node

var playerLifes = 3
var points = 0;
var maxBombCount = 1
var bombRange = 3

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
	
func GetTileIndexesFromPosition(position):

	var x = round((position.x - 16)/32)
	var y = round((position.y - 80)/32)
	
	var tilePosition = Vector2()
	
	tilePosition.x = x
	tilePosition.y = y
	
	return tilePosition
	
func GetTileCenter(x, y):
	var xPos = x * 32 + 32
	var yPos = y * 32 + 96
	return Vector2(xPos, yPos)