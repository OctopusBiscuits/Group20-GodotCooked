extends RigidBody3D

# === State ===
var picked_up = false
var in_range = false
var onCounterTop = false
var countertop : Node = null
var player : Node = null

# === Item Properties ===
@export var cutsNeeded = 0
@export var itemName : String
@export var cuttable : bool
@export var canHoldAnObject : bool
@export var heldObjects : Array[Node] = []
@export var timeToClean : float

func _ready():
	player = get_tree().get_nodes_in_group("Player1").front()

func _physics_process(delta):
	if player == null:
		return
	if (onCounterTop):
		global_position = countertop.global_position + Vector3(0,0.6,0)
	for item in heldObjects:
		item.global_position = global_position + Vector3(0,0.1,0)
	if (itemName == "DirtyPlate"):
		canHoldAnObject = false
		#print("DIRTY FUCKER")
	if picked_up:
		_handle_while_held()
	elif _can_pick_up_from_floor():
		_try_pick_up_off_floor()
	elif _can_pick_up_from_countertop():
		_try_pick_up_off_countertop()

	if _can_interact_with_held_object():
		if player.objectPickedUp:
			_place_in_container()
		else:
			_take_out_of_container()

# === Interaction Conditions ===

func _can_pick_up_from_floor() -> bool:
	return in_range and not picked_up and not onCounterTop and not player.objectPickedUp

func _can_pick_up_from_countertop() -> bool:
	return player.currentCounterTop == countertop and onCounterTop and not picked_up

func _can_interact_with_held_object() -> bool:
	return Input.is_action_just_pressed("putInFryingPan") and countertop == player.currentCounterTop and onCounterTop

# === Player Interaction Actions ===

func _handle_while_held():
	if not Input.is_action_just_pressed("Toggle Pickup"):
		return

	if player.currentCounterTop:
		_put_item_on_countertop()
	else:
		_put_item_on_floor()

func _try_pick_up_off_floor():
	if Input.is_action_just_pressed("Toggle Pickup"):
		_pick_up(player)

func _try_pick_up_off_countertop():
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

func _put_item_on_countertop():
	if player.currentCounterTop.itemName == "trash can":
		player.objectPickedUp = false
		queue_free()
		return

	var counter = player.currentCounterTop as Countertop
	countertop = counter
	reparent(counter)

	global_position = counter.global_position
	position.y += 0.5
	counter._setItemOnCounterTop(self)
	counter._changeItemOnCounterTop()

	picked_up = false
	onCounterTop = true
	player.objectPickedUp = false

func _put_item_on_floor():
	reparent(get_tree().current_scene)
	picked_up = false
	player.objectPickedUp = false

func _place_in_container():
	var held_item = player.objectInHand
	if not held_item:
		return
	
	held_item.global_position = global_position
	held_item.inAnObject = true
	held_item.get_parent().remove_child(held_item)
	add_child(held_item)

	heldObjects.append(held_item)

	player.objectPickedUp = false
	player.objectInHand = null


func _take_out_of_container():
	if heldObjects.is_empty():
		return

	var lastObject = heldObjects.pop_back()
	lastObject.inAnObject = false
	lastObject.get_parent().remove_child(lastObject)
	get_tree().current_scene.add_child(lastObject)

	player.objectPickedUp = true
	player.objectInHand = lastObject

# === Signals ===

func _on_area_3d_body_entered(body):
	if body.name == "Little Fella":
		in_range = true

func _on_area_3d_body_exited(body):
	if body.name == "Little Fella":
		in_range = false
