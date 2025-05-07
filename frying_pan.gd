extends RigidBody3D

# === State ===
var picked_up = false
var in_range = false
var onCounterTop = false
var countertop : Node = null
var player : Node = null
var players_in_range : Array = []
var canUseStove = false
# === Item Properties ===
@export var cutsNeeded = 0
@export var itemName : String
@export var cuttable : bool
@export var canHoldAnObject : bool
@export var holdingAnObject : bool
@export var objectBeingHeld : Node

func _on_area_3d_body_entered(body):
	
	if body.is_in_group("Players") and not players_in_range.has(body):
		players_in_range.append(body)
		print("in range")
		#print(itemName)
func _on_area_3d_body_exited(body):
	if body.is_in_group("Players"):
		players_in_range.erase(body)

func _physics_process(_delta):
	if (onCounterTop):
		global_position = countertop.global_position + Vector3(0,0.6,0)
	
	if (itemName == "DirtyPlate"):
		canHoldAnObject = false
	for player in players_in_range:
		
		#print("in for loop")
		in_range = true
		if picked_up:
			_handle_while_held(player)
		elif _can_pick_up_from_floor(player):
			#print("trying to pick up from floor")
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
	if not Input.is_action_just_pressed("Toggle Pickup"):
		return

	if player.currentCounterTop:
		_put_item_on_countertop(player)
	else:
		_put_item_on_floor(player)

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
	var held_item = player.objectInHand
	if not held_item:
		return
	
	held_item.reparent(self)
	held_item.global_position = global_position 
	held_item.inAnObject = true

	objectBeingHeld = held_item
	holdingAnObject = true

	player.objectPickedUp = false
	player.objectInHand = null

func _take_out_of_container(player):
	if not objectBeingHeld:
		return

	objectBeingHeld.inAnObject = false
	objectBeingHeld.get_parent().remove_child(objectBeingHeld)
	get_tree().current_scene.add_child(objectBeingHeld)

	player.objectPickedUp = true
	player.objectInHand = objectBeingHeld

	objectBeingHeld = null
	holdingAnObject = false

# === Signals ===
