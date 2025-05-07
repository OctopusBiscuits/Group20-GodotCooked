extends Node
#This generates the list of the recipes that need to be completed
@export var level  : int

var recipeCard = load("res://SamHUI/Scenes/UI/Game UI/RecipeCard.tscn")

var onionSoup = "res://SamHUI/Assets/Textures/soup icon.png"
var pizza = "res://SamHUI/Assets/Textures/pizza with sauce.png"
var pizzaCheese = "res://SamHUI/Assets/Textures/pizza.png"

var recipesList = [
	[["Onion Soup", onionSoup, 75], ["Onion Soup", onionSoup, 90], ["Onion Soup", onionSoup, 110], ["Onion Soup", onionSoup, 125], ["Onion Soup", onionSoup, 150]],
	[["pizzaCheese", pizza, 50], ["pizza", pizzaCheese, 70], ["pizzaCheese", pizza, 75], ["pizza", pizzaCheese, 95], ["pizzaCheese", pizza, 100], ["pizza", pizzaCheese, 110]],
	[["pizzaCheese", pizza, 50], ["pizza", pizzaCheese, 70], ["pizzaCheese", pizza, 75], ["pizza", pizzaCheese, 95], ["pizzaCheese", pizza, 100], ["pizza", pizzaCheese, 110]]
	]

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
	
