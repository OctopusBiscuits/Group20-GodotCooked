extends Node3D
@export var mealsSent : Array[String] = []
@export var levelTimer : float = 300
@export var platesOut : int = 0
@export var plateWarmer : Node
func _process(delta: float) -> void:
	levelTimer -= delta
	print(plateWarmer.platesCurrentlyOut)
	
func _addMeal(plateSent : Node) -> void:
	mealsSent.append(plateSent.heldObjects[0].itemName)
	platesOut += 1
	print(mealsSent)
	
