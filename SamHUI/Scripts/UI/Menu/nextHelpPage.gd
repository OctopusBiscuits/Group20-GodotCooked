extends Button

@export var scene  : PackedScene
@export var menutoclose: Node

func on_pressed() -> void:
	menutoclose.queue_free()
	
	var instance = scene.instantiate()
	get_node("/root/Layout/UI").add_child(instance)
