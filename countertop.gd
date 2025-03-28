extends Node3D
class_name Countertop
var itemOnCounterTop : bool = false
var itemHeldOnCounterTop : Node
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
		print("Something is on me")


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Little Fella":
		body.counterTopsTouching -= 1
		if body.currentCounterTop == self:
			body.currentCounterTop = null# Replace with function body.
