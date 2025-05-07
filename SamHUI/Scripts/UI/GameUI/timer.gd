extends Timer
#When one of the recipe's timer runs out it changes the game's state to the game over state

var gameoverScene = load("res://SamHUI/Scenes/UI/Menu/gameOver.tscn")

func _on_timeout() -> void:
	gameover()
#This function spawns in the game over UI, and displays the final score on it.
func gameover() -> void:
	var instance = gameoverScene.instantiate()
	instance.get_node("PanelContainer/VBoxContainer/Score").text = "High Score: " + "one krillion"
	get_node("/root/Layout/UI").add_child(instance)
	get_tree().paused = true
