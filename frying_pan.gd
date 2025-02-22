extends Node3D

#This needs to work in tangent with stove
#
@export var objectInPan : Node
var isFryingPanOnStove = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isFryingPanOnStove:
		objectInPan.timer -= delta
