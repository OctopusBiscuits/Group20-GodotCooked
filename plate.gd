extends RigidBody3D

# === State ===
var picked_up = false
var in_range = false
var onCounterTop : bool = false
var countertop : Node = null
var player : Node = null
var players_in_range : Array = []
var canUseStove = false

# === Item Properties ===
@export var cutsNeeded = 0
@export var itemName : String
@export var cuttable : bool
@export var canHoldAnObject : bool
@export var holdingAnObject : bool = true
@export var heldObjects : Array[Node] = []
@export var timeToClean : float
@export var canGoInOven : bool = false
@export var onionSoup : PackedScene


func _on_area_3d_body_entered(body):
	
	if body.is_in_group("Players") and not players_in_range.has(body):
		players_in_range.append(body)
		print("in range")
		print(itemName)
func _on_area_3d_body_exited(body):
	if body.is_in_group("Players"):
		players_in_range.erase(body)

func _physics_process(_delta):
	if (onCounterTop):
		global_position = countertop.global_position + Vector3(0,0.6,0)
	for item in heldObjects:
		
		item.global_position = global_position + Vector3(0,0.1,0)
	if (itemName == "DirtyPlate"):
		canHoldAnObject = false
	
	for player in players_in_range:
		
		#print("in for loop")
		in_range = true
		if picked_up:
			_handle_while_held(player)
		elif _can_pick_up_from_floor(player):
			
			_try_pick_up_off_floor(player)
		elif _can_pick_up_from_countertop(player):
			_try_pick_up_off_countertop(player)
		else:
			#print("in the else")
			pass
		if _can_interact_with_held_object(player):
			if player.objectPickedUp:
				_place_in_container(player)
			else:
				_take_out_of_container(player)

# === Interaction Conditions ===

func _can_pick_up_from_floor(player) -> bool:
	return in_range and not picked_up and not onCounterTop and not player.objectPickedUp

func _can_pick_up_from_countertop(player) -> bool:
	return player.currentCounterTop == countertop and onCounterTop and not picked_up

func _can_interact_with_held_object(player) -> bool:
	return Input.is_action_just_pressed("putInFryingPan") and countertop == player.currentCounterTop and onCounterTop

# === Player Interaction Actions ===

func _handle_while_held(player):
	if player.currentCounterTop:
		if player.currentCounterTop.itemName == "Stove":
			if player.currentCounterTop.moreInStove == false:
				if Input.is_action_just_pressed("putInFryingPan"):
					_getFoodFromStove(player)
	if not Input.is_action_just_pressed("Toggle Pickup"):
		return

	if player.currentCounterTop and player.currentCounterTop.can_accept_item(self):
		_put_item_on_countertop(player)
	else:
		_put_item_on_floor(player)
func _getFoodFromStove(player):
	var a = 0
	if (player.currentCounterTop.itemsInStove == player.currentCounterTop.onion_soup):
		var soup = onionSoup.instantiate()
		get_parent().add_child(soup)

		soup.global_position = global_position
		heldObjects.append(soup)
		print("Trying to get it from stove")
		#print(heldObjects)
func _try_pick_up_off_floor(player):
	if Input.is_action_just_pressed("Toggle Pickup"):
		_pick_up(player)

func _try_pick_up_off_countertop(player):
	if Input.is_action_just_pressed("Toggle Pickup"):
		player.currentCounterTop._remove_item()
		player.objectPickedUp = true
		player.objectInHand = self
		picked_up = true
		onCounterTop = false
		reparent(player)

# === Core Actions ===

func _pick_up(holder: Node):
	picked_up = true
	holder.objectPickedUp = true
	holder.objectInHand = self
	reparent(holder)

func _put_item_on_countertop(player) -> void:
	if player.currentCounterTop.itemName == "trash can":
		player.objectPickedUp = false
		queue_free()
		return

	var counter = player.currentCounterTop as Countertop
	if (not counter.can_accept_item(self)):
		return
	countertop = counter
	reparent(counter)

	global_position = counter.global_position
	position.y += 0.5
	counter._setItemOnCounterTop(self)
	counter._changeItemOnCounterTop()

	picked_up = false
	onCounterTop = true
	player.objectPickedUp = false

func _put_item_on_floor(player):
	reparent(get_tree().current_scene)
	picked_up = false
	player.objectPickedUp = false

func _place_in_container(player):
	print("placing in container")
	var held_item = player.objectInHand
	var heldItemName = held_item.itemName
	#print(held_item)
	if not held_item:
		return
	
	held_item.reparent(self)
	held_item.global_position = global_position 
	held_item.inAnObject = true

	heldObjects.append(held_item)
	
	player.objectPickedUp = false
	player.objectInHand = null
	print(heldObjects)
	for child in player.get_children():
		print(child)

func _take_out_of_container(player):
	print("taking out")
	if heldObjects.is_empty():
		return

	var lastObject = heldObjects.pop_back()
	lastObject.inAnObject = false
	lastObject.get_parent().remove_child(lastObject)
	get_tree().current_scene.add_child(lastObject)

	player.objectPickedUp = true
	player.objectInHand = lastObject
