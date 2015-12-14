extends  "res://Map/tileElement.gd"

var dynamicELementClass = load("res://Map/Models/dynamicElement.gd")

func _ready():
	get_node("AnimationPlayer").play("Explode")
	pass

func _on_Area2D_area_enter( area ):
	if(area.get_parent() extends dynamicELementClass):
		area.get_parent().OnHit()
