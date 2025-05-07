extends Node2D

@export var timer: Node

# Used to calculate the angle of the arc, to show how much of the clock timer has been completed
var completePercentage: float = 0

# All variables needed to draw the base circle and the arc on top
var center: Vector2 = Vector2(125,125)
var width: float = 125
var antialiased: bool = true

# Called when the node enters the scene tree for the first time.
func _draw():
	draw_circle(center, width, Color.WHITE, antialiased)
	draw_arc(center, width / 2, deg_to_rad(-90), deg_to_rad((360 * completePercentage) - 90), 50, Color.RED, width, antialiased)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	update_completePercentage()
	queue_redraw()

func update_completePercentage():
	completePercentage = 1 - timer.time_left / timer.get_wait_time()
