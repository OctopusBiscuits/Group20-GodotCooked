extends Control

#this is to test the pause menu
@export var scene  : PackedScene

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("pause") && get_node("/root/Layout/UI/Pause Menu") == null:
		get_tree().paused = true
		var instance = scene.instantiate()
		get_node("/root/Layout/UI").add_child(instance)
