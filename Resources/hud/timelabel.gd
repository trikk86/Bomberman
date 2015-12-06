extends Label

func _ready():
	set_text(str("04:00"))
	set_fixed_process(true)
	
func _fixed_process(delta):
	var timeInSeconds = get_tree().get_root().get_node("Map/Timer").get_time_left()
	var minutes = int(timeInSeconds) / 60
	var minutesString
	if(minutes < 10):
		minutesString = str("0", minutes)
	else:
		minutesString = str(minutes)
		
	var seconds = int(timeInSeconds) % 60
	var secondsString
	if(seconds < 10):
		secondsString = str("0", seconds)
	else:
		secondsString = str(seconds)
	
	set_text(str(minutesString, ":", secondsString))