extends Node3D
@export var mealsSent : Array[String] = []
@export var levelTimer : float = 300
@export var platesOut : int = 0
@export var plateWarmer : Node
@export var score : int = 0
@export var mealsNeeded : Array[String] = []
@export var levelNode : Node
@export var counter : int = 0
@export var l3Counter1 : int = 0
@export var l3Counter2 : int = 5
func _ready() -> void:
	
	print(mealsNeeded)
func _process(delta: float) -> void:
	levelTimer -= delta
	#print(plateWarmer.platesCurrentlyOut)
	#print(score, mealsNeeded)
	#print(mealsSent)
func _addMeal(plateSent : Node) -> void:
	print("Trying to add")
	#print(plateSent.heldObjects[0].itemName)
	
	print(plateSent.heldObjects[0].name)
	if (not plateSent.heldObjects[0].name.begins_with("Onio")):
		print("Appending")
		mealsSent.append(plateSent.heldObjects[0].itemName)
	else:
		
		mealsSent.append("Onion Soup")
	platesOut += 1
	#print(mealsSent)
	if (_checkMeal()):
		score += 1
		
		if (levelNode.level == 0 or levelNode.level == 1 or levelNode.level == 2):
			if levelNode.recipeCardList != null:
				
				levelNode.recipeCardList[0].queue_free()
				levelNode.recipeCardList.remove_at(0)
				print("this is recipelist",levelNode.recipeCardList)
				counter += 1
		else:
			if mealsSent[-1] == "Onion Soup":
				levelNode.recipeCardList[0].queue_free()
				l3Counter1 += 1
				levelNode.recipeCardList.remove_at(0)
			else:
				print("one las tpizza")
				levelNode.recipeCardList[0].queue_free()
				l3Counter2 -= 1
				levelNode.recipeCardList.remove_at(levelNode.recipeCardList.size() -1)
				
	
func _checkMeal() -> bool:
	var index = 0
	
	print(mealsSent[-1])
	for meal in mealsNeeded:# loop through each meal needed. If last meal sent is, remove it from mealsNeeded. 
		print(meal)
		if meal == mealsSent[-1]:
			
			mealsNeeded.pop_at(index)
			
			return true
		index += 1
	return false
	
func _getScore() -> int:
	return score
