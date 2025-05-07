extends Node3D
@export var mealsSent : Array[String] = []
@export var levelTimer : float = 300
@export var platesOut : int = 0
@export var plateWarmer : Node
@export var score : int = 0
@export var mealsNeeded : Array[String] = []
@export var levelNode : Node
func _ready() -> void:
	
	print(mealsNeeded)
func _process(delta: float) -> void:
	levelTimer -= delta
	#print(plateWarmer.platesCurrentlyOut)
	#print(score, mealsNeeded)
	
func _addMeal(plateSent : Node) -> void:
	print(plateSent.heldObjects[0])
	print(plateSent.heldObjects[0].name)
	if (plateSent.heldObjects[0].name != "Onion Soup"):
		
		mealsSent.append(plateSent.heldObjects[0].itemName)
	else:
		print("ONION SOUP YUM YUM")
		mealsSent.append("Onion Soup")
	platesOut += 1
	#print(mealsSent)
	if (_checkMeal()):
		score += 1
	
func _checkMeal() -> bool:
	var index = 0
	 
	for meal in mealsNeeded:# loop through each meal needed. If last meal sent is, remove it from mealsNeeded. 
		
		if meal == mealsSent[-1]:
			
			mealsNeeded.pop_at(index)
			return true
		index += 1
	return false
	
func _getScore() -> int:
	return score
