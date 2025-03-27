extends RigidBody3D
var picked_up = false
var player : Node
var in_range = false
func _ready():
	player = get_tree().find_object_in_group("Player1")

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
		#player = body
func _physics_process(delta):
	
	if picked_up:
		#global_transform.origin = player.global_transform.origin + Vector3(0, 1, 0)
		
		#This is if player is next to a countertop and is holding an item (Place it on counter top)
		if Input.is_action_just_pressed("Toggle Pickup") and player != null:
			if player != null:  # Ensure player is valid before accessing its properties
				if player.currentCounterTop != null:
					print("Placeholder")
					reparent(player.currentCounterTop)
					picked_up = false
					self.position = player.currentCounterTop.position
				else:
					print("Error: currentCounterTop is null")
			else:
				print("Player is null")
			
			
		elif Input.is_action_just_pressed("Toggle Pickup"):
			picked_up = false
			player.objectPickedUp = false
			
			reparent(get_tree().current_scene)
			player = null
		#print("Player")
	elif in_range and player.objectPickedUp == false:
		if Input.is_action_just_pressed("Toggle Pickup"):
			player.objectPickedUp = true
			picked_up = true
			player.objectInHand = self
			
			#freeze = true
			reparent(player)
			print("Picked up??????")


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Little Fella":
		#player = null 
		in_range = false
