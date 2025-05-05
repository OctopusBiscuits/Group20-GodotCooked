extends Node3D
@export var player1Node : Node
@export var player2Node : Node
var player1 = true # true for player 1, false for player 2
func _ready():
	player1Node = player1Node.get_child(2)
	player2Node = player2Node.get_child(2)
	
	player1Node._enableCharacter()
	player2Node._disableCharacter()
func _switch():
	if (player1):
		player1Node._disableCharacter()
		player2Node._enableCharacter()
		player1 = false
	else:
		player1Node._enableCharacter()
		player2Node._disableCharacter()
		player1 = true
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("Switch")):
		print("Switch trying")
		_switch()
