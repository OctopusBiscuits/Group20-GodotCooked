extends Node3D
@export var mealsSent : Array[String] = []
@export var levelTimer : float = 300
@export var platesOut : int = 0
@export var plateWarmer : Node
@export var score : int = 0
@export var mealsNeeded : Array[String] = []
func _process(delta: float) -> void:
	levelTimer -= delta
	#print(plateWarmer.platesCurrentlyOut)
	
func _addMeal(plateSent : Node) -> void:
	mealsSent.append(plateSent.heldObjects[0].itemName)
	platesOut += 1
	print(mealsSent)
	if (_checkMeal()):
		score += 1
	
func _checkMeal() -> bool:
	var index = 0
	 
	for meal in mealsNeeded:# loop through each meal needed. If last meal sent is, remove it from mealsNeeded. 
		index += 1
		if meal == mealsSent[-1]:
			
			mealsNeeded.pop_at(index)
			return true
	return false
	
func _getScore() -> int:
	return score
