extends Node
#This generates the list of the recipes that need to be completed
@export var level  : int
var winCondition = false
var recipeCard = load("res://SamHUI/Scenes/UI/Game UI/RecipeCard.tscn")

var onionSoup = "res://SamHUI/Assets/Textures/soup icon.png"
var pizza = "res://SamHUI/Assets/Textures/pizza with sauce.png"
var pizzaCheese = "res://SamHUI/Assets/Textures/pizza.png"
var recipeCardList = []
var recipesList = [
	[["Onion Soup", onionSoup, 90], ["Onion Soup", onionSoup, 180], ["Onion Soup", onionSoup, 240], ["Onion Soup", onionSoup, 270], ["Onion Soup", onionSoup, 300]],
	[["pizzaCheese", pizzaCheese, 300], ["pizzaCheese", pizzaCheese, 300], ["pizzaCheese", pizzaCheese, 300], ["pizzaCheese", pizzaCheese, 300], ["pizzaCheese", pizzaCheese, 300], ["pizzaCheese", pizzaCheese, 300]],
	[["Onion Soup", onionSoup, 300], ["Onion Soup", onionSoup, 300], ["pizzaCheese", pizzaCheese, 300], ["pizza", pizzaCheese, 300], ["pizzaCheese", pizzaCheese, 300], ["pizza", pizzaCheese, 300]]
	]
var levelOneRecipe = [["Onion Soup", onionSoup, 300], ["Onion Soup", onionSoup, 300], ["Onion Soup", onionSoup, 300], ["Onion Soup", onionSoup, 300], ["Onion Soup", onionSoup, 300]]
var levelTwoRecipe = [["pizzaCheese", pizza, 300], ["pizza", pizzaCheese, 300], ["pizzaCheese", pizza, 300], ["pizza", pizzaCheese, 300], ["pizzaCheese", pizza, 300], ["pizza", pizzaCheese, 300]]
var levelThreeRecipe = [["pizzaCheese", pizza, 300], ["pizza", pizzaCheese, 300], ["pizzaCheese", pizza, 300], ["pizza", pizzaCheese, 300], ["pizzaCheese", pizza, 300], ["pizza", pizzaCheese, 300]]
func _ready() -> void:
	for recipes in recipesList[level]:
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
		winCondition = true
