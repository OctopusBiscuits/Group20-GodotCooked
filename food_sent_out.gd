extends Node3D
@export var mealsSent : Array[String] = []

func _addMeal(plateSent : Node) -> void:
	mealsSent.append(plateSent.heldObjects[0].itemName)
	print(mealsSent)
	
