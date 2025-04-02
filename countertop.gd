extends Node3D
class_name Countertop
var itemOnCounterTop : bool = false
var itemHeldOnCounterTop : Node

@export var cut_onion : PackedScene
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Little Fella":
		if body.counterTopsTouching == 0:
			print("This could work")
			body.currentCounterTop = self
		body.counterTopsTouching += 1
func _changeItemOnCounterTop() -> void:
	if itemOnCounterTop == true:
		itemOnCounterTop = false
	else:
		itemOnCounterTop = true
func _setItemOnCounterTop(item : Node) -> void:
	itemHeldOnCounterTop = item

func _physics_process(delta):
	if itemHeldOnCounterTop != null:
		#print("Something is on me")
		#print(itemHeldOnCounterTop.cuttable)
		if itemHeldOnCounterTop.cuttable and Input.is_action_just_pressed("attack"):
			#print(itemHeldOnCounterTop.cutsNeeded)
			if itemHeldOnCounterTop.cutsNeeded > 0 :
				itemHeldOnCounterTop.cutsNeeded -= 1
				if itemHeldOnCounterTop.cutsNeeded == 0:
					if itemHeldOnCounterTop.itemName == "Uncut Onion":
						print("Test")
						var itemPos = itemHeldOnCounterTop.global_position
						itemHeldOnCounterTop.queue_free()
						var newItem = cut_onion.instantiate()
						newItem.position = itemPos
						
		pass


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Little Fella":
		body.counterTopsTouching -= 1
		if body.currentCounterTop == self:
			body.currentCounterTop = null# Replace with function body.
