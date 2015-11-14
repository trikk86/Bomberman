extends Label

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	var timeInSeconds = get_node("/root/MainTextureFrame/Area2D/Timer").get_time_left()
	var minutes = int(timeInSeconds) / 60
	var seconds = int(timeInSeconds) % 60
	set_text(str(minutes, ":", seconds))