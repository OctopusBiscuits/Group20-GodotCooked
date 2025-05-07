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
	#print(mealsSent)
func _addMeal(plateSent : Node) -> void:
	print("Trying to add")
	print(plateSent.heldObjects[0])
	
	print(plateSent.heldObjects[0].name)
	if (not plateSent.heldObjects[0].name.begins_with("Onio")):
		
		mealsSent.append(plateSent.heldObjects[0].itemName)
	else:
		
		mealsSent.append("Onion Soup")
	platesOut += 1
	#print(mealsSent)
	if (_checkMeal()):
		score += 1
		if (levelNode.level == 0):
			levelNode.recipeCardList[0].queue_free()
	
func _checkMeal() -> bool:
	var index = 0
	 
	for meal in mealsNeeded:# loop through each meal needed. If last meal sent is, remove it from mealsNeeded. 
		
		if meal == mealsSent[-1]:
			
			mealsNeeded.pop_at(index)
			print(levelNode.recipesList)
			return true
		index += 1
	return false
	
func _getScore() -> int:
	return score
