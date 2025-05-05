extends Node3D
class_name Countertop

@export var itemName: String
@export var cut_onion: PackedScene
@export var clean_plate: PackedScene
@export var pizza_base_cheese: PackedScene
@export var foodSentList : Node
@export var itemsInStove : Array[String] 
@export var itemStored : PackedScene #Used for Produce crates 
@export var cut_cheese : PackedScene
@export var Scoring: Node

var moreInStove = true
var onion_soup : Array[String ]= ["Cut_Onion", "Cut_Onion", "Cut_Onion"]
var itemOnCountertop := false
var held_item: Node = null
var can_place_in_object := false
var player: Node = null

func _ready():
	player = get_tree().get_nodes_in_group("Player1")[0]
	foodSentList = get_tree().get_nodes_in_group("FoodSentPrefab")[0]
	

	if (itemName == "Stove"):
		itemsInStove = onion_soup
	#print(foodSentList)
	

func _on_area_3d_body_entered(body: Node3D) -> void: 
	if body.name == "Little Fella":
		if not self in body.nearbyCounterTops:
			body.nearbyCounterTops.append(self)
		body.update_currentCounterTop()

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Little Fella":
		body.nearbyCounterTops.erase(self)
		body.update_currentCounterTop()

func _physics_process(_delta: float):
	
	
	if itemName == "trash can":
		itemOnCountertop = false
		if (held_item):
			held_item.queue_free()
	elif itemName == "Produce Crate":
		
		itemOnCountertop = true
		
		if (player.currentCounterTop == self and player.objectPickedUp == false):
			_handle_produce()
	elif itemName == "Converybelt" and held_item:
		if (held_item.itemName == "Plate"):
			itemOnCountertop = false
			
			if (held_item):
				
				# Increment score when an item is placed on the conveyor belt
				var scorer = get_tree().get_nodes_in_group("Scorer")
				if scorer.size() > 0:
					scorer[0]._increment()
					
				held_item.queue_free()



	elif itemName == "Hob" and held_item :
		can_place_in_object = held_item.canHoldAnObject and not held_item.holdingAnObject
		#print("GOt here for hob")
		_handle_hob(_delta)
	elif itemName == "Sink" and held_item:
		print("Got here")
		if held_item.itemName == "DirtyPlate":
			_handle_washing(_delta)
	elif itemName == "Oven" and held_item:
		if held_item.canGoInOven:
			_handle_oven(_delta)

	elif itemName == "Stove" and held_item:
		_handle_stove(_delta)
		_check_for_finished_recipe()
		
	elif held_item: #normal countertop
		#print("Item is held")
		_handle_cutting()
		can_place_in_object = held_item.canHoldAnObject and not held_item.holdingAnObject
		
func _changeItemOnCounterTop() -> void:
	if itemOnCountertop == true:
		itemOnCountertop = false
	else:
		itemOnCountertop = true
func _handle_produce() -> void:
	#print("handling produce.")
	if Input.is_action_just_pressed("Toggle Pickup"):
		print("trying to spawn new produce")
		_getNewItemOnCounterTop()
func _handle_hob(_delta: float) -> void:
	#print("I am hobbing so hard rn")
	if held_item.itemName != "Frying Pan" or held_item.holdingAnObject != true:
		return

	print (held_item.objectBeingHeld.timeNeededOnStove)
	held_item.objectBeingHeld.timeNeededOnStove -= _delta
	if held_item.objectBeingHeld.timeNeededOnStove <= 0:
		held_item.holdingAnObject = false
		held_item.objectBeingHeld.queue_free()
func _handle_cutting():
	if Input.is_action_just_pressed("attack") and player.currentCounterTop == self and itemName == "Countertop":
		if held_item.cuttable and held_item.cutsNeeded > 0:
			held_item.cutsNeeded -= 1
			if held_item.cutsNeeded == 0:
				_getNewItemOnCounterTop()
func _handle_washing(_delta : float):
	print ("washing a dirty plate")
	held_item.timeToClean -= _delta
	if (held_item.timeToClean < 0):
		_getNewItemOnCounterTop()
		
func _handle_oven(_delta: float):
	print("Ovening")
	held_item.timeToCook -= _delta
	if (held_item.timeToCook <= 0):
		print("COOKED")
		held_item.queue_free()
func _place_item(item: Node):
	held_item = item
	itemOnCountertop = true
func _handle_stove(_delta: float): 
	if (held_item.canUseStove and moreInStove):
		itemsInStove.append(held_item.itemName)
		held_item.queue_free()
		_remove_item()
	
		print(itemsInStove)
		
	
func _check_for_finished_recipe():
	if (itemsInStove == onion_soup):
		print("ONION SOUP")
		moreInStove = false
		
func _remove_item():
	held_item = null
	itemOnCountertop = false

func _getItemOnCounterTop() -> bool:
	return itemOnCountertop
func _setItemOnCounterTop(item: Node) -> void:
	held_item = item
	itemOnCountertop = true
func _getNewItemOnCounterTop() -> Node: #Function to swap object on countertop eg uncut onion to cut onion
	var new_item : Node
	var itemPos
	if (itemName == "Produce Crate"):
		new_item = itemStored.instantiate()
		itemPos = self.global_position + Vector3(0, 0.5, 0)
	else:
		
		if (held_item.itemName == "Uncut Onion"):
			new_item = cut_onion.instantiate()
			print("Instantiated")
		elif (held_item.itemName == "DirtyPlate"):
			new_item = clean_plate.instantiate()
		elif (held_item.itemName == "PizzaBaseNowWithCheese"):
			new_item = pizza_base_cheese.instantiate()
		elif (held_item.itemName == "Uncut Cheese"):
			new_item = cut_cheese.instantiate()
		itemPos = held_item.global_position
		held_item.queue_free()
	
	#var new_item = cut_onion.instantiate()
	
	add_child(new_item)
	new_item.global_position = itemPos
	new_item.reparent(self)
	held_item = new_item.get_node("test")
	print(held_item)
	held_item.onCounterTop = true
	held_item.picked_up = false
	held_item.countertop = self
	held_item.player = player
	
	_place_item(held_item)
	return null
