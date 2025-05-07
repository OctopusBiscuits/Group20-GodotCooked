extends Button

@export var scene  : PackedScene

func on_pressed() -> void:
	var instance = scene.instantiate()
	get_node("/root/Layout/UI").add_child(instance)
