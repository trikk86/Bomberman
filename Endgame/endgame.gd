extends Sprite

var globals

var regex

var maxScoreCount = 5
var topScores = Array()

func _ready():
	globals = get_tree().get_root().get_node("/root/Globals")
	get_node("ScoreValue").set_text(str(globals.points))
	get_node("NamePrompt").set_text("Please type in your name\nand press Enter")
	get_node("LineEdit").grab_focus()
	
	regex = RegEx.new()
	regex.compile("^[a-zA-Z0-9]*$")
	
func SaveResult():
	var score = {}
	
	score["Name"] = get_node("LineEdit").get_text()
	score["Score"] = globals.points

	var scoreFile = File.new()
	var maxScores = Array()
	maxScores.append(score)
	if (scoreFile.file_exists("user://highscores.save")):
		scoreFile.open("user://highscores.save", File.READ_WRITE)
		while (!scoreFile.eof_reached()):
			var currentline = {}
			currentline.parse_json(scoreFile.get_line())
			if(!currentline.empty()):
				maxScores.append(currentline)
				
		for score in maxScores:
			if(topScores.size() == 0):
				topScores.append(score)
			else:
				var success = false;
				for topScore in topScores:
					if(!success && score["Score"] > topScore.Score):
						topScores.insert(topScores.find(topScore), score)
						success = true
				if(!success):
					topScores.append(score)
		
		scoreFile.seek(0)
		for i in range(0, maxScoreCount):
			if(i < topScores.size()):
				scoreFile.store_line(topScores[i].to_json())
		
	else:
		scoreFile.open("user://highscores.save", File.WRITE)
		scoreFile.store_string(score.to_json())
		
	scoreFile.close()

func _on_LineEdit_text_changed( text ):
	if(regex.find(text) == -1):
		get_node("LineEdit").set_text(text.substr(0, text.length() - 1))
		get_node("LineEdit").set_cursor_pos(text.length() - 1)

func _on_LineEdit_text_entered( text ):
	SaveResult()
	get_node("/root/ScreenLoader").goto_scene("res://Menu/menu.res")
