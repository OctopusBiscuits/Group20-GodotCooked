extends Node3D
class_name Countertop

@export var itemName: String
@export var cut_onion: PackedScene

var itemOnCountertop := false
var held_item: Node = null
var can_place_in_object := false
var player: Node = null

func _ready():
	player = get_tree().get_nodes_in_group("Player1")[0]

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Little Fella":
		if body.counterTopsTouching == 0:
			print("This could work")
			#print(itemHeldOnCounterTop)
			body.currentCounterTop = self
		body.counterTopsTouching += 1

func _on_area_3d_body_exited(body):
	if body.name == "Little Fella":
		body.counterTopsTouching -= 1
		if body.currentCounterTop == self:
			body.currentCounterTop = null

func _physics_process(_delta: float):
	if itemName == "trash can":
		itemOnCountertop = false
	if itemName == "Hob" and held_item :
		can_place_in_object = held_item.canHoldAnObject and not held_item.holdingAnObject
		_handle_hob(_delta)
	elif held_item:
		_handle_cutting()
		can_place_in_object = held_item.canHoldAnObject and not held_item.holdingAnObject
		
func _changeItemOnCounterTop() -> void:
	if itemOnCountertop == true:
		itemOnCountertop = false
	else:
		itemOnCountertop = true
func _handle_hob(_delta: float) -> void:
	print("I am hobbing so hard rn")
	if held_item.itemName != "Frying Pan" or held_item.holdingAnObject != true:
		return

	print (held_item.objectBeingHeld.timeNeededOnStove)
	held_item.objectBeingHeld.timeNeededOnStove -= _delta
	if held_item.objectBeingHeld.timeNeededOnStove <= 0:
		held_item.holdingAnObject = false
		held_item.objectBeingHeld.queue_free()
func _handle_cutting():
	if Input.is_action_just_pressed("attack") and player.currentCounterTop == self:
		if held_item.cuttable and held_item.cutsNeeded > 0:
			held_item.cutsNeeded -= 1
			if held_item.cutsNeeded == 0 and held_item.itemName == "Uncut Onion":
				var item_pos = held_item.global_position
				held_item.queue_free()
				var new_item = cut_onion.instantiate()
				add_child(new_item)
				new_item.global_position = item_pos
				new_item.reparent(self)
				held_item = new_item.get_child(0)
				held_item.onCounterTop = true
				held_item.picked_up = false

func _place_item(item: Node):
	held_item = item
	itemOnCountertop = true

func _remove_item():
	held_item = null
	itemOnCountertop = false

func _getItemOnCounterTop() -> bool:
	return itemOnCountertop
func _setItemOnCounterTop(item: Node) -> void:
	held_item = item
	itemOnCountertop = true
