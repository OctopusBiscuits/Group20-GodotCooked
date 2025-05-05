extends Node
var plates_collected : int = 0

func _ready():
	add_to_group("Scorer")
	$platecount.text = "score:" + str(plates_collected)
	
func _increment():
	
	plates_collected += 1
	$platecount.text = "score:" + str(plates_collected)
