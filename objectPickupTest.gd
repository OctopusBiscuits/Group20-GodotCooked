extends RigidBody3D
var picked_up = false
var player : Node
var in_range = false
var onCounterTop = false
var countertop : Node
var inAnObject = false
var players_in_range : Array = []
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
	pass
func _on_area_3d_body_entered(body):
	print("In onareaentered")
	print(body.is_in_group("Players"))
	print(body)
	if body.is_in_group("Players") and not players_in_range.has(body):
		players_in_range.append(body)
		print("in range")
func _on_area_3d_body_exited(body):
	if body.is_in_group("Players"):
		players_in_range.erase(body)

func _physics_process(_delta):
	for player in players_in_range:
		
		#print("in for loop")

		if Input.is_action_just_pressed("Toggle Pickup"):
			print("Got here")
			if picked_up and player.objectInHand == self:
				_handle_put_down(player)
			elif not picked_up and not player.objectPickedUp and not onCounterTop:
				_pick_up(player)
			elif onCounterTop and (player.currentCounterTop == countertop) and (!player.objectPickedUp):
				pickup_from_countertop(player)

func pickup_from_countertop(player):
	print("Picking up from countertop")
	print(player.currentCounterTop)
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
	picked_up = true
	onCounterTop = false
	player.objectPickedUp = true
	player.objectInHand = self
	reparent(player)

func _put_on_floor(player):
	picked_up = false
	reparent(get_tree().current_scene)
	player.objectPickedUp = false

func _put_on_countertop(player):
	var counter = player.currentCounterTop as Countertop
	reparent(counter)
	global_position = counter.global_position + Vector3(0, 0.5, 0)
	counter._place_item(self)
	onCounterTop = true
	player.currentCounterTop = counter
	picked_up = false
	player.objectPickedUp = false
	countertop = counter
