extends Node3D
@export var objectType = "onion"
@export var count = 10

@export var uncut_onion : Node
@export var cut_onion : Node
#Add more cut items here when we know what they are


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"): #Left click is called attack
		count = count - 1
		#print(count)
	if count == 0:
		handle_object(uncut_onion)
func handle_object(input_object: Node) -> Node:
	# This is where we decide which object to delete at runtime.
	var object_to_cut = input_object 
	var object_to_return  
	if objectType == "Onion":
		object_to_return = cut_onion
	# Remove the object from the scene and delete it
	if object_to_cut:
		object_to_cut.queue_free() #delete uncut object 
		
   
	if object_to_return:
		var cut_object = object_to_return.instance()
		add_child(cut_object)  # Add the new object to the scene tree
		return cut_object
	return null
