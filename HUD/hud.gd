extends Sprite

var lifeResource = preload("res://HUD/life.res")
var lifesArray = Array()

func UpdateHUD(playerLifes, timeLeft, points):
	DrawLifes(playerLifes)
	FormatTime(timeLeft)
	SetPoints(points)
	
func SetPoints(points):
	get_node("PointValueLabel").set_text(str(points))

func DrawLifes(playerLifes):
	for life in lifesArray:
		remove_child(life)
		lifesArray.erase(life)
		life.free()

	for i in range(0, playerLifes):
		var life = lifeResource.instance()
		add_child(life)
		lifesArray.append(life)
	
		var x = -12 - (-float(playerLifes)/2 + i) * 23
			
		life.set_pos(Vector2(x, -210))
		life.set_z(2)

func FormatTime(timeLeft):
	var minutes = int(timeLeft) / 60
	
	var minutesString
	
	if(minutes < 10):
		minutesString = str("0", minutes)
	else:
		minutesString = str(minutes)
		
	var seconds = int(timeLeft) % 60
	
	var secondsString
	
	if(seconds < 10):
		secondsString = str("0", seconds)
	else:
		secondsString = str(seconds)
	
	get_node("TimeValueLabel").set_text(str(minutesString, ":", secondsString))
	