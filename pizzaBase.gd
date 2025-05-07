extends RigidBody3D

# === State ===
var picked_up = false #is it picked up
var in_range = false #is it in range to be picked up
var onCounterTop = false #bool to say if on a countertop or not
var countertop : Node = null #countertop this item is currently on (if not on countertop it is null)
var player : Node = null #player
var inAnObject = false
var players_in_range : Array = []
var canGoInOven : bool
var canUseStove = false
# === Item Properties ===
@export var cutsNeeded = 0
@export var itemName : String #For pizza bases this should be pizza base + toppings
@export var cuttable : bool
@export var canHoldAnObject : bool
@export var heldObjects : Array[Node] = []
@export var timeToClean : float
@export var timeToCook = 5

func _ready():
	#player = get_tree().get_nodes_in_group("Player1").front()
	pass
func _on_area_3d_body_entered(body):
	
	if body.is_in_group("Players") and not players_in_range.has(body):
		players_in_range.append(body)
		#print("in range")
		#print(itemName)
func _on_area_3d_body_exited(body):
	if body.is_in_group("Players"):
		players_in_range.erase(body)

func _physics_process(_delta):
	if itemName == "PizzaBaseNowWithCheeseMushroom":
		canGoInOven = true
		
	if (onCounterTop):
		global_position = countertop.global_position + Vector3(0,0.6,0)
	for item in heldObjects:
		item.global_position = global_position + Vector3(0,0.1,0)
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
	#print(player.currentCounterTop == countertop, onCounterTop, not picked_up)
	return player.currentCounterTop == countertop and onCounterTop and not picked_up

func _can_interact_with_held_object(player) -> bool:
	return Input.is_action_just_pressed("putInFryingPan") and countertop == player.currentCounterTop and onCounterTop

# === Player Interaction Actions ===

func _handle_while_held(player):
	if not Input.is_action_just_pressed("Toggle Pickup"):
		return

	if player.currentCounterTop and player.currentCounterTop.itemName != "Conveyer Belt":
		_put_item_on_countertop(player)
	else:
		_put_item_on_floor(player)

func _try_pick_up_off_floor(player):
	if Input.is_action_just_pressed("Toggle Pickup"):
		_pick_up(player)

func _try_pick_up_off_countertop(player):
	#print("in trypickup")
	if Input.is_action_just_pressed("Toggle Pickup"):
	#	print("trying to get off countertop :3")
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
	
	held_item.global_position = global_position
	held_item.inAnObject = true
	held_item.get_parent().remove_child(held_item)
	add_child(held_item)

	heldObjects.append(held_item)
	#print("trying to place in container")
	player.objectPickedUp = false
	player.objectInHand = null
	if (held_item.itemName == "Cut Cheese" and itemName == "PizzaBaseNowWithSauce"):
		itemName = "PizzaBaseNowWithCheese"
		print("DEBUG: Trying to switch")
		countertop._getNewItemOnCounterTop(player)
	if (held_item.itemName == "Sauce" and itemName == "Pizza Base"):
		print("here")
		itemName = "PizzaBaseNowWithSauce"
		countertop._getNewItemOnCounterTop(player)
	if (held_item.itemName == "Cut Mushroom" and itemName == "PizzaBaseNowWithCheese"):
		itemName = "PizzaBaseNowWithCheeseMushroom"
		countertop._getNewItemOnCounterTop(player)

func _take_out_of_container(player):
	if heldObjects.is_empty():
		return

	var lastObject = heldObjects.pop_back()
	lastObject.inAnObject = false
	lastObject.get_parent().remove_child(lastObject)
	get_tree().current_scene.add_child(lastObject)

	player.objectPickedUp = true
	player.objectInHand = lastObject

# === Signals ===
