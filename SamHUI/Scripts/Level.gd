extends Node
#This generates the list of the recipes that need to be completed
@export var level  : int
var winCondition = false
var recipeCard = load("res://SamHUI/Scenes/UI/Game UI/RecipeCard.tscn")
var winScreen = load("res://win screen.tscn")
var onionSoup = "res://SamHUI/Assets/Textures/soup icon.png"
var pizza = "res://SamHUI/Assets/Textures/pizza with sauce.png"
var pizzaCheese = "res://SamHUI/Assets/Textures/pizza.png"
var recipeCardList = []
var theList = []
var recipesList = [
	[["Onion Soup", onionSoup, 90], ["Onion Soup", onionSoup, 110], ["Onion Soup", onionSoup, 130], ["Onion Soup", onionSoup, 150], ["Onion Soup", onionSoup, 150]],
	[["pizzaCheese", pizzaCheese, 300], ["pizzaCheese", pizzaCheese, 300], ["pizzaCheese", pizzaCheese, 300], ["pizzaCheese", pizzaCheese, 300], ["pizzaCheese", pizzaCheese, 300], ["pizzaCheese", pizzaCheese, 300]],
	[["Onion Soup", onionSoup, 300], ["Onion Soup", onionSoup, 300], ["pizzaCheese", pizzaCheese, 300], ["pizzaCheese", pizzaCheese, 300], ["pizzaCheese", pizzaCheese, 300], ["pizzaCheese", pizzaCheese, 300]]
	]
var levelOneRecipe = [["Onion Soup", onionSoup, 90], ["Onion Soup", onionSoup, 110], ["Onion Soup", onionSoup, 130], ["Onion Soup", onionSoup, 150], ["Onion Soup", onionSoup, 150]]
var levelTwoRecipe = [["pizzaCheese", pizzaCheese, 300], ["pizza", pizzaCheese, 300], ["pizzaCheese", pizzaCheese, 300], ["pizza", pizzaCheese, 300]]
var levelThreeRecipe = [["Onion Soup", onionSoup, 300], ["Onion Soup", onionSoup, 300], ["pizzaCheese", pizzaCheese, 300], ["pizzaCheese", pizzaCheese, 300]]
func _ready() -> void:
	var theList = []
	if level == 0:
		theList = levelOneRecipe
	elif level == 1:
		theList = levelTwoRecipe
	else:
		theList = levelThreeRecipe
	for recipes in theList:
		print("recipe")
		create_recipe_card(recipes[0], recipes[1], recipes[2])
		pass

func create_recipe_card(name, icon, seconds) -> void:
	var instance = recipeCard.instantiate()
	instance.setFood(icon)
	instance.setTimer(seconds)
	get_node("/root/Layout/UI/Game UI/HBoxContainer/Recipes Bar").add_child(instance)
	recipeCardList.append(instance)
	
func _process(delta: float) -> void:
	if (recipeCardList.size() == 0):
		#print("WINWINWINWINWINWIJ")
		winCondition = true
		var instance = winScreen.instantiate()
		instance.get_node("PanelContainer/VBoxContainer/Score").text = "High Score: " + str(get_node("/root/Layout/Game/Node3D/Timer + Food Sent")._getScore())
		get_node("/root/Layout/UI").add_child(instance)
		get_tree().paused = true
	
		#print("no win yet")
