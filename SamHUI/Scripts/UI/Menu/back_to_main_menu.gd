extends Button

var UI = load("res://SamHUI/Scenes/UI/Menu/menu.tscn")

func _on_pressed() -> void:
	remove_children(get_node("/root/Layout/UI"))
	get_node("/root/Layout/Game/Node3D").free()
	
	var instance = UI.instantiate()
	get_node("/root/Layout/UI").add_child(instance)
	
	get_tree().paused = false

func remove_children(node) -> void:
	for child in node.get_children():
		child.queue_free()
