extends Button

var scene = load("res://SamHUI/Scenes/UI/Menu/levelSelect.tscn")

func on_pressed() -> void:
	var instance = scene.instantiate()
	get_node("/root/Layout/UI").add_child(instance)
