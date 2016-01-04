extends Sprite

var globals
var timeLabel
var scoreLabel

var isComplete = false

var TimeLeft  = 0

func _ready():
	globals = get_tree().get_root().get_node("/root/Globals")
	timeLabel = get_node("TimeLeftValue")
	scoreLabel = get_node("ScoreValue")
	get_node("DelayTimer").connect("timeout", self, "StartCalculation")
	set_process(true)

func _process(delta):
	timeLabel.set_text(FormatTime(TimeLeft))
	scoreLabel.set_text(str(globals.points))

func StartCalculation():
	if(!isComplete):
		if(TimeLeft > 0):
			globals.points += 2
			TimeLeft -= 1
		else:
			globals.level += 1
			isComplete = true
			get_node("Prompt").show()
			set_process_input(true)

func _input(event):
	if(event.type == InputEvent.KEY):
		get_parent().OnFinished()

func Complete(levelTime):
	TimeLeft = levelTime
	get_node("DelayTimer").start()

func FormatTime(timeLeft):
	var minutes = int(timeLeft) / 60
	
	var minutesString
	
	if(minutes < 10):
		minutesString = str("0", minutes)
	else:
		minutesString = str(minutes)
		
	var seconds = int(timeLeft) % 60
	
	var secondsString
	
	if(seconds < 10):
		secondsString = str("0", seconds)
	else:
		secondsString = str(seconds)
	
	return str(minutesString, ":", secondsString)