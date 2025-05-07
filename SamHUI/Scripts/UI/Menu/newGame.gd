extends Button

@export var GameLevel: PackedScene
var UI = load("res://SamHUI/Scenes/UI/Game UI/GameUI.tscn")

func on_pressed() -> void:
	get_tree().paused = false
	# First delete all nodes in Game tree and UI tree
	remove_children(get_node("/root/Layout/UI"))
	
	if get_node("/root/Layout/Game/Node3D") != null:
		get_node("/root/Layout/Game/Node3D").free()
	
	var instance = UI.instantiate()
	get_node("/root/Layout/UI").add_child(instance)
	
	instance = GameLevel.instantiate()
	get_node("/root/Layout/Game").add_child(instance)

func remove_children(node) -> void:
	for child in node.get_children():
		child.queue_free()
