extends Node3D
class_name Countertop
var itemOnCounterTop : bool = false
var itemHeldOnCounterTop : Node
@export var itemName : StringName #This is for the object where items can be placed - eg countertop, sink or trash can
@export var cut_onion : PackedScene
var player : Node
var canPlaceInObject : bool = false
#To cut more objects - make their scenes and add them here. Make an inherited scene from pickUpObject and add the relevenat blender file. Then name the scene
func _ready() -> void:
	var players = get_tree().get_nodes_in_group("Player1")
	if players.size() > 0:
		player = players[0]

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Little Fella":
		if body.counterTopsTouching == 0:
			print("This could work")
			print(itemHeldOnCounterTop)
			body.currentCounterTop = self
		body.counterTopsTouching += 1
func _changeItemOnCounterTop() -> void:
	if itemOnCounterTop == true:
		itemOnCounterTop = false
	else:
		itemOnCounterTop = true
func _setItemOnCounterTop(item : Node) -> void:
	itemHeldOnCounterTop = item
func _getcanPlaceInObject() -> bool:
	return canPlaceInObject
func _getItemOnCounterTop() -> bool:
	return itemOnCounterTop
func _physics_process(delta):
	if itemName == "trash can":
		itemOnCounterTop = false 
	if itemHeldOnCounterTop != null:
		#print("Something is on me")
		#print(itemHeldOnCounterTop.cuttable)
		#print(itemHeldOnCounterTop.name)
		if Input.is_action_just_pressed("attack") and player.currentCounterTop == self:
			#print(itemHeldOnCounterTop.cutsNeeded)
			if itemHeldOnCounterTop.cutsNeeded > 0 and itemHeldOnCounterTop.cuttable :
				itemHeldOnCounterTop.cutsNeeded -= 1
				if itemHeldOnCounterTop.cutsNeeded == 0:
					if itemHeldOnCounterTop.itemName == "Uncut Onion": #Copy this for other objects
						#print("Test")
						var itemPos = itemHeldOnCounterTop.global_position
						itemHeldOnCounterTop.queue_free()
						var newItem = cut_onion.instantiate()
						add_child(newItem)
						newItem.global_position = itemPos
						#newItem.global_position.y += 1
						print(newItem.position)
						#print(newItem)
						newItem.reparent(self)
						itemHeldOnCounterTop = newItem.get_child(0)
						itemHeldOnCounterTop.onCounterTop = true
						print("switch happened")
						
		if itemHeldOnCounterTop.canHoldAnObject:
			if itemHeldOnCounterTop.holdingAnObject == false:
				canPlaceInObject = true
			else:
				canPlaceInObject = false
							 
				#print("Object added to frying pan")
		pass


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Little Fella":
		body.counterTopsTouching -= 1
		if body.currentCounterTop == self:
			body.currentCounterTop = null# Replace with function body.
