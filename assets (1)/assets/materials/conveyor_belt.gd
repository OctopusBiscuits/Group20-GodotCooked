extends MeshInstance3D
#this script scrolls the conveyor texture

@export var speed = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	get_surface_override_material(2).uv1_offset.y -= delta * speed
