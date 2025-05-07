extends Node
#This script is used to spawn a recipe card

@export var timer: Node
@export var progressBar: ProgressBar
# Used to calculate amount of the bar that needs to be filled to represent the time
var completePercentage: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float):
	update_completePercentage()
	set_progress_bar()

func update_completePercentage():
	completePercentage = timer.time_left / timer.get_wait_time()

func set_progress_bar():
	progressBar.value = completePercentage
	

# Changes the texture 2D on the recipe card
func setFood(filePath) -> void:
	var texture = load(filePath)
	get_node("HBoxContainer/Recipe Card/VBoxContainer/FoodIcon").texture = texture
	pass

func setTimer(seconds) -> void:
	timer.wait_time = seconds

# Adds specified ingredients to recipe card Unused
"""func addIngredient(ingredientPath, processPath) -> void:
	var scene = load("res://scenes/ui/Ingredient.tscn")
	
	var instance = scene.instantiate()
	
	instance.setIngredient(ingredientPath)
	instance.setProcess(processPath)
	
	get_node("HBoxContainer/Recipe Card/VBoxContainer").add_child(instance)
	pass"""
