extends Node3D
@export var mealsSent : Array[String] = []
@export var levelTimer : float = 300

func _process(delta: float) -> void:
	levelTimer -= delta
	
func _addMeal(plateSent : Node) -> void:
	mealsSent.append(plateSent.heldObjects[0].itemName)
	print(mealsSent)
	
