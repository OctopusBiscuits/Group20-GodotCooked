extends Button


#This script queue frees the set
func on_pressed() -> void:
	get_node(".").queue_free()
