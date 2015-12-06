extends Sprite

var HitPoints = 1
var IsBlocking = true
var TilePosition = Vector2()

var IsBomb = true

func _ready():
	get_node("AnimationPlayer").play("Explode")
	



