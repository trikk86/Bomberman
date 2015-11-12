extends Label

func _ready():
	set_process(true)
	
func _process(delta):
	set_text(str("Lifes: ", get_node("/root/Globals").playerLifes))