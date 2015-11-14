extends Label

func _ready():
	set_process(true)
	
func _process(delta):
	set_text(str(get_node("/root/Globals").playerLifes))