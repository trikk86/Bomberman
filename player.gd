extends KinematicBody2D

var walkSpeed = 150
var velocity = Vector2()

var reloadTimer
var isReloading = false;

var isImmortal = false
var immortalityTimer

func _ready():
	immortalityTimer = get_node("ImmortalityTimer")
	immortalityTimer.set_wait_time(1)
	immortalityTimer.set_one_shot(true)
	immortalityTimer.connect("timeout", self, "RemoveImmortality")
	
	reloadTimer = get_node("ReloadTimer")
	reloadTimer.set_wait_time(1)
	reloadTimer.set_one_shot(true)
	reloadTimer.connect("timeout", self, "ReloadFinished")
	
	set_fixed_process(true)

func _fixed_process(delta):
	if(Input.is_action_pressed("ui_down")):
		velocity.y = walkSpeed
	elif(Input.is_action_pressed("ui_up")):
		velocity.y = -walkSpeed
	else:
		velocity.y = 0
		
	if(Input.is_action_pressed("ui_left")):
		velocity.x = -walkSpeed
	elif(Input.is_action_pressed("ui_right")):
		velocity.x = walkSpeed
	else:
		velocity.x = 0
	
	if(Input.is_key_pressed(KEY_SPACE) && isReloading == false):
		PlaceBomb(get_pos())
		
	var motion = velocity * delta
	motion = move( motion )    

	if (is_colliding()):
		var collisionNode = get_collider()
		var mapNode = get_tree().get_root().get_node("Map")
		print(collisionNode.get_name())
		if(mapNode.enemies.find(collisionNode) == 0 && isImmortal == false):
			isImmortal = true
			immortalityTimer.start()
			get_node("/root/Globals").LoseLife()
		else:
			var n = get_collision_normal()
			motion = n.slide( motion ) 
			velocity = n.slide( velocity )
			move( motion )
			
func RemoveImmortality():
	isImmortal = false
								
func PlaceBomb(position):
	var mapNode = get_tree().get_root().get_node("Map")
	mapNode.AddBomb(get_pos())
	isReloading = true
	reloadTimer.start()
	
func ReloadFinished():
	isReloading = false
	

	
	
