extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

#NOTE - THIS NEEDS TO CHECK WHAT OBJECT PLAYER IS HOLDING AND THAT PLAYER IS NEAR BIN.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		var objectToDelete = null 
		if objectToDelete:
			objectToDelete.queue_free()
