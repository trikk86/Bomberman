
extends Panel



func _ready():
	get_node("AnimTimer").connect("timeout", self, "StartAnimation")
	set_process(true)
	get_node("StreamPlayer").play()
	pass

	
func StartAnimation():
	get_node("TextureFrame/AnimationPlayer").play("Blink")


