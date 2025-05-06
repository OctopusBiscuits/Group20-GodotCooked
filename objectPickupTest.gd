extends RigidBody3D
var picked_up = false
var player : Node
var in_range = false
var onCounterTop = false
var countertop : Node
var inAnObject = false
var players_in_range : Array = []
var totalPlayers : Array = []

@export var canUseStove : bool
@export var timeNeededOnStove : float
@export var cutsNeeded = 0
@export var itemName : String
@export var cuttable : bool
@export var canHoldAnObject : bool #This will be false for food and true for pans/plates etc
@export var holdingAnObject : bool
@export var objectBeingHeld : PackedScene
@export var canGoInOven : bool
@export var timeToCook : float 
func _ready():
	#player = get_tree().get_nodes_in_group("Player1")[0]
	print("Start of ready")
	
	totalPlayers = get_tree().get_nodes_in_group("Players")
	
	for player in totalPlayers:
		if (player.name != "Little Fella"):
			print("This should not be here")
			#totalPlayers.remove(player)
	#totalPlayers[0] = totalPlayers[0].get_child(2)
	#totalPlayers[1] = totalPlayers[1].get_child(2)
	#print(totalPlayers[0])
	#print(totalPlayers[1])
func _on_area_3d_body_entered(body):
	#print("In onareaentered")
	#print(body.is_in_group("Players"))
	#print(body)
	if body.is_in_group("Players") and not players_in_range.has(body):
		players_in_range.append(body)
		#print("in range")
func _on_area_3d_body_exited(body):
	if body.is_in_group("Players"):
		players_in_range.erase(body)

func _physics_process(_delta) -> void:
	
	
		
		#print("Start of phsysics process")
		
		#print("wrapper")
	if (picked_up):
		if (player and players_in_range.has(player) == false):
			
			players_in_range.append(player)
	players_in_range = players_in_range.filter(func(p): return p != null and is_instance_valid(p))

	for player in players_in_range:
		
		if (not player):
			continue
		if (picked_up):
			global_position = player.global_position + Vector3(0,0,0.3)
		if Input.is_action_just_pressed("Toggle Pickup"):
			
			if picked_up and player.objectInHand == self:
				_handle_put_down(player)
				print("put down")
				return
			elif not picked_up and not player.objectPickedUp and not onCounterTop:
				print("trying to pickup")
				_pick_up(player)
			elif onCounterTop and (player.currentCounterTop == countertop) and (!player.objectPickedUp):
				print("trying to pick up from countertop")
				pickup_from_countertop(player)
	if (onCounterTop):
		for player in totalPlayers:
			if (player.currentCounterTop == null):
				return
			if onCounterTop and (player.currentCounterTop == countertop) and (!player.objectPickedUp) and Input.is_action_just_pressed("Toggle Pickup"):
				print("trying to pick up from countertop outside for loop")
				pickup_from_countertop(player)
	
func pickup_from_countertop(player):
	print("Picking up from countertop")
	print(player.currentCounterTop)
	#print(itemName)
	player.currentCounterTop._remove_item()
	player.objectPickedUp = true
	player.objectInHand = self
	picked_up = true
	onCounterTop = false
	reparent(player)

func _handle_put_down(player):
	if (player.currentCounterTop and player.currentCounterTop.itemName == "Produce Crate"):
		print("Cannot put down here")
		return
	if player.currentCounterTop and not player.currentCounterTop._getItemOnCounterTop() and player.currentCounterTop.itemName != "Hob" and player.currentCounterTop.itemName != "Produce Crate":
		print("Going on countertop")
		_put_on_countertop(player)
	
	else:
		print("on the floor")
		_put_on_floor(player)

func _pick_up(player):
	print ("Picked up by:" , player)
	picked_up = true
	onCounterTop = false
	player.objectPickedUp = true
	player.objectInHand = self
	reparent(player)

func _put_on_floor(player):
	picked_up = false
	reparent(get_tree().current_scene)
	player.objectPickedUp = false

func _put_on_countertop(player) -> void:
	var counter = player.currentCounterTop as Countertop
	if (not counter.can_accept_item(self)):
		return
	reparent(counter)
	global_position = counter.global_position + Vector3(0, 0.5, 0)
	counter._place_item(self)
	onCounterTop = true
	player.currentCounterTop = counter
	picked_up = false
	player.objectPickedUp = false
	countertop = counter
