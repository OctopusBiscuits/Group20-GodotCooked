extends Button

@export var menutoclose: Node

#This script queue frees the set
func _on_pressed() -> void:
	get_tree().paused = false
	menutoclose.queue_free()
