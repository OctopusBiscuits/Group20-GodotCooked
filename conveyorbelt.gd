extends Node3D
class_name ConveyorBelt

@export var returnTime: float = 3.0  # Time in seconds before item returns
@export var itemName: String = "Conveyor Belt"


var itemOnCountertop := false  # Match variable name with Countertop class
var held_item: Node = null
var is_currently_processing := false
var player: Node = null
var original_position: Vector3

func _ready():
	add_to_group("Countertops")  # Add to same group as other countertops if needed
	player = get_tree().get_nodes_in_group("Player1")[0]
	
	# Create a timer if it doesn't exist in the scene
	if !has_node("Timer"):
		var timer = Timer.new()
		timer.name = "Timer"
		timer.wait_time = returnTime
		timer.one_shot = true
		add_child(timer)
	
	# Connect the signal
	$Timer.connect("timeout", Callable(self, "_on_timer_timeout"))

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Little Fella":
		if body.counterTopsTouching == 0:
			body.currentCounterTop = self
		body.counterTopsTouching += 1

func _on_area_3d_body_exited(body):
	if body.name == "Little Fella":
		body.counterTopsTouching -= 1
		if body.currentCounterTop == self:
			body.currentCounterTop = null

func _physics_process(_delta: float):
	if is_currently_processing:
		# You could add visual effects here like flashing or animation
		pass
	
	# If we have an item but not processing, make sure it's at the right position
	if held_item and !is_currently_processing and itemOnCountertop:
		held_item.global_position = global_position + Vector3(0, 0.6, 0)

# Match method signature with Countertop class
func _changeItemOnCounterTop() -> void:
	if itemOnCountertop == true:
		itemOnCountertop = false
	else:
		itemOnCountertop = true

func _setItemOnCounterTop(item: Node) -> void:
	held_item = item
	itemOnCountertop = true
	original_position = item.global_position
	
	# Increment score when an item is placed on conveyor belt


func _remove_item() -> void:
	held_item = null
	itemOnCountertop = false

func _getItemOnCounterTop() -> bool:
	return itemOnCountertop

func start_processing():
	if not held_item or is_currently_processing:
		return false
		
	is_currently_processing = true
	
	# Hide the item during processing
	held_item.visible = false
	
	# Start the timer
	$Timer.start()
	return true

func _on_timer_timeout():
	is_currently_processing = false
	
	# Show the item again
	if held_item and itemOnCountertop:
		held_item.visible = true
		held_item.global_position = global_position + Vector3(0, 0.6, 0)

# Additional methods for conveyor-specific functionality
func has_item() -> bool:
	return itemOnCountertop

func is_conveyor_processing() -> bool:
	return is_currently_processing

func get_item() -> Node:
	if held_item:
		return held_item
	return null
