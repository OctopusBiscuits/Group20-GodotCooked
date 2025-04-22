extends RigidBody3D
var picked_up = false
var player : Node
var in_range = false
var onCounterTop = false
var countertopThisIsCurrentlyOn : Node
var inAnObject = false
@export var cutsNeeded = 0
@export var itemName : String
@export var cuttable : bool
@export var canHoldAnObject : bool #This will be false for food and true for pans/plates etc
@export var holdingAnObject : bool
@export var objectBeingHeld : PackedScene
func _ready():
	player = get_tree().get_nodes_in_group("Player1")[0]

func _on_area_3d_body_entered(body):
	if body.name == "Little Fella":
		in_range = true

func _on_area_3d_body_exited(body):
	if body.name == "Little Fella":
		in_range = false

func _physics_process(_delta):
	if not player:
		return
	#print(countertopThisIsCurrentlyOn)
	if Input.is_action_just_pressed("Toggle Pickup"):
		print("E pressed")
		if picked_up:
			print("put down")
			_handle_put_down()
		elif in_range and not picked_up and not player.objectPickedUp and not onCounterTop:
			# Pick up off floor
			print("floor pickup")
			_pick_up()
		elif onCounterTop and (player.currentCounterTop == countertopThisIsCurrentlyOn) and (!player.objectPickedUp):
			# Pick up off countertop
			print("from coutnertop")
			pickup_from_countertop()

func pickup_from_countertop():
	print("Picking up from countertop")
	print(player.currentCounterTop)
	player.currentCounterTop._remove_item()
	player.objectPickedUp = true
	player.objectInHand = self
	picked_up = true
	onCounterTop = false
	reparent(player)

func _handle_put_down():
	if player.currentCounterTop and not player.currentCounterTop._getItemOnCounterTop():
		_put_on_countertop()
	else:
		_put_on_floor()

func _pick_up():
	picked_up = true
	onCounterTop = false
	player.objectPickedUp = true
	player.objectInHand = self
	reparent(player)

func _put_on_floor():
	picked_up = false
	reparent(get_tree().current_scene)
	player.objectPickedUp = false

func _put_on_countertop():
	var counter = player.currentCounterTop as Countertop
	reparent(counter)
	global_position = counter.global_position + Vector3(0, 0.5, 0)
	counter._place_item(self)
	onCounterTop = true
	player.currentCounterTop = counter
	picked_up = false
	player.objectPickedUp = false
	countertopThisIsCurrentlyOn = counter
