extends Label

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	var points = get_tree().get_root().get_node("/root/Globals").points
	set_text(str(points))