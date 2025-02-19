extends Node3D
@export var objectTest = "cutting"
@export var count = 10


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		count = count - 1
		print(count)
	if count == 0:
		self.queue_free()
