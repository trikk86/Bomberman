extends Node

var playerLifes = 3
var playerMaxLifes = 5

var points = 0

var maxBombCount = 2
var bombRange = 4

var isSpeedBoostScheduled = false  
var walkSpeed = 75

var remoteDetonation = true

var level = 1

func _ready():
	Input.set_mouse_mode(1)