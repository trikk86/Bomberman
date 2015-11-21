extends KinematicBody2D

#export variables

export var walkSpeed = 120
export var immortalityTime = 2
export var reloadTime = 2

#end

#nodes
var mainNode
var globalVariables
var animationPlayer = get_node("MovementPlayer")
var reloadTimer = get_node("ReloadTimer")
var immortalityTimer = get_node("ImmortalityTimer")

#end

#state variables

var isReloading = false
var isImmortal = false
var isPlayer = true

#end

#variables

var velocity = Vector2()
#end

#_ready func
func _ready():

	mainNode = get_tree().get_root().get_node("Node2D/Main")
	globalVariables = get_tree().get_root().get_node("/root/Globals")
	
	#prepare timers
	
	immortalityTimer.set_wait_time(immortalityTime)
	immortalityTimer.set_one_shot(true)
	immortalityTimer.connect("timeout", self, "RemoveImmortality")
	
	reloadTimer.set_wait_time(reloadTime)
	reloadTimer.set_one_shot(true)
	reloadTimer.connect("timeout", self, "ReloadFinished")
	
	#set processing
	set_fixed_process(true)

#end

#_fixed_process function

func _fixed_process(delta):
	if(Input.is_action_pressed("ui_down")):
		velocity.y = walkSpeed
		if( !animationPlayer.is_playing()):
			animationPlayer.play("MoveDown")

	elif(Input.is_action_pressed("ui_up")):
		velocity.y = -walkSpeed
		if( !animationPlayer.is_playing()):
			animationPlayer.play("MoveUp")
	else:
		velocity.y = 0
		
	if(Input.is_action_pressed("ui_left")):
		velocity.x = -walkSpeed
		if( !animationPlayer.is_playing()):
			animationPlayer.play("MoveLeft")
			
	elif(Input.is_action_pressed("ui_right")):
		velocity.x = walkSpeed
		if( !animationPlayer.is_playing()):
			animationPlayer.play("MoveRight")
	else:
		velocity.x = 0
	
	if(isImmortal && !get_node("BlinkPlayer").is_playing()):
		get_node("BlinkPlayer").play("Blink")
	
	if(Input.is_key_pressed(KEY_SPACE) && isReloading == false):
		PlaceBomb(get_pos())
	
	var motion = velocity * delta
	motion = move( motion )    

	if (is_colliding()):
		var collisionNode = get_collider()
		if(collisionNode.get("isEnemy") == true && isImmortal == false):
			TakeLifeMakeImmortal()
		var n = get_collision_normal()
		motion = n.slide( motion ) 
		velocity = n.slide( velocity )
		move( motion )

#end

#functions

func PlaceBomb(playerPosition):
	var bombCount = mainNode.bombsArray.size()
	var maxBombCount = globalVariables.maxBombs

	if(bombCount < maxBombCount):
		mainNode.AddBomb(playerPosition)
		isReloading = true
		reloadTimer.start()

#state functions

func TakeLifeMakeImmortal():
	isImmortal = true
	immortalityTimer.start()
	globalVariables.playerLifes -= 1;

func RemoveImmortality():
	isImmortal = false
								
func ReloadFinished():
	isReloading = false
	
#end
