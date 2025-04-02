extends RigidBody3D
var picked_up = false
var player : Node
var in_range = false
var onCounterTop = false
@export var cutsNeeded = 0
@export var itemName : String
@export var cuttable : bool


func _ready():
	var players = get_tree().get_nodes_in_group("Player1")
	if players.size() > 0:
		player = players[0]  # Assuming you want the first player in the group


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
		print("in range to be picked up")
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
					
					picked_up = false
					var temp = player.currentCounterTop as Countertop
					self.global_position = player.currentCounterTop.global_position
					temp._changeItemOnCounterTop()
					temp._setItemOnCounterTop(self)
					reparent(player.currentCounterTop)
					self.position.y += 0.5
					print(self.position)
					print(player.currentCounterTop.position)
					onCounterTop = true
				else: #place it on the floor
					print("Error: currentCounterTop is null")
					picked_up = false
					if (self.is_inside_tree()):
						var main = get_tree().current_scene
						reparent(main)
						player.objectPickedUp = false
						
			else:
				print("Player is null")
			
		#Drop item
		elif Input.is_action_just_pressed("Toggle Pickup"):
			picked_up = false
			player.objectPickedUp = false
			
			reparent(get_tree().current_scene)
			player = null
		#print("Player")
	#This is for when item is on floor (not on countertop) - pick it up
	elif in_range and player.objectPickedUp == false and onCounterTop == false:
		if Input.is_action_just_pressed("Toggle Pickup"):
			player.objectPickedUp = true
			picked_up = true
			player.objectInHand = self
			
			#freeze = true
			reparent(player)
			print("Picked up??????")
	#This is for when item is on countertop and you try to pick it up
	elif player!= null:
		if (player.currentCounterTop != null) and onCounterTop == true:
			if (Input.is_action_just_pressed("Toggle Pickup")):
				player.objectPickedUp = true
				picked_up = true
				player.objectInHand = self
				reparent(player)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Little Fella":
		#player = null 
		in_range = false
