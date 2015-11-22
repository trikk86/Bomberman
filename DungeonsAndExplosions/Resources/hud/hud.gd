extends Sprite

var lifeResource = preload("res://Resources/lifes/life.res")
var lifeArray = Array()

func _ready():
	set_process(true)
	pass

func _process(delta):
	for life in lifeArray:
		remove_child(life)
		lifeArray.erase(life)
		life.free()
		
	var playerLifes = get_tree().get_root().get_node("/root/Globals").playerLifes
	for i in range(0, playerLifes):
		var life = lifeResource.instance()
		add_child(life)
		lifeArray.append(life)

		var x = -12 - (-float(playerLifes)/2 + i) * 24
		
		life.set_pos(Vector2(x, -7))
	#15 x 13
	