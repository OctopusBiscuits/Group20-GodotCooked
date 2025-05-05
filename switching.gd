extends Node3D

# Array to store all playable characters
var characters = []
var characteri = 0

func _ready():
	# Find and store all character instances
	for child in get_children():
		if child is CharacterBody3D:
			characters.append(child)
			# Disable all characters except the first one
			child.set_process(false)
			child.set_physics_process(false)
			
	
	# Enable the first character
	if characters.size() > 0:
		enable_character(0)

func _input(event):
	if Input.is_action_just_pressed("switch_character"):
		switch_to_next_character()

func switch_to_next_character():
	if characters.size() <= 1:
		return
		
	# Disable current character
	disable_character(characteri)
	
	# Switch to next character
	characteri= (characteri + 1) % characters.size()
	
	# Enable new current character
	enable_character(characteri)

func enable_character(i):
	var character = characters[i]
	character.set_process(true)
	character.set_physics_process(true)
	

func disable_character(i):
	var character = characters[i]
	character.set_process(false)
	character.set_physics_process(false)
	
