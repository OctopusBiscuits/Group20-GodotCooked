extends RigidBody3D

@onready var mesh_instance = $MeshInstance

# The color you want to change to
var target_color = Color(1, 0, 0)  

func _ready() -> void:
	# Connect the signal for when the player enters the area
	connect("body_entered", self, "_on_body_entered")

# Function that will run when the player enters the area
func _on_body_entered(body):
	if body.is_in_group("player"):  # Make sure the body is the player
		# Change the color of the mesh
		var material = mesh_instance.material_override
		if material:  # Ensure the material exists
			material.albedo_color = target_color
