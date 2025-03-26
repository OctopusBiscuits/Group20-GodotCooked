extends RigidBody3D
var picked_up = false
var player = null
var in_range = false
func _on_area_3d_body_entered(body):
	
	#print(body.name)
	"""
	if body.name == "Little Fella":
		player = body
		picked_up = true
		#freeze = true
		reparent(player)
		print("Picked up??????")
	"""
	if body.name == "Little Fella":
		in_range = true
		player = body
func _physics_process(delta):
	
	if picked_up and player:
		#global_transform.origin = player.global_transform.origin + Vector3(0, 1, 0)
		if Input.is_action_just_pressed("Toggle Pickup"):
			picked_up = false
			reparent(get_tree().current_scene)
		print("Player")
	elif in_range:
		if Input.is_action_just_pressed("Toggle Pickup"):
			
			picked_up = true
			#freeze = true
			reparent(player)
			print("Picked up??????")


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Little Fella":
		player = null 
		in_range = false
