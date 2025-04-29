extends Node3D

# Array to store all playable characters
var chefs = []
var chefi = 0

func _ready():
	# Find and store all character instances
	for child in get_children():
		if child is CharacterBody3D:
			chefs.append(child)
			# Disable all characters except the first one
			child.set_process(false)
			child.set_physics_process(false)
			
	
	# Enable the first character
	if chefs.size() > 0:
		enable_character(0)

func _input(event):
	if Input.is_action_just_pressed("switch_character"):
		switch_to_next_character()

func switch_to_next_character():
	if chefs.size() <= 1:
		return
		
	# Disable current character
	disable_character(chefi)
	
	# Switch to next character
	chefi= (chefi + 1) % chefs.size()
	
	# Enable new current character
	enable_character(chefi)

func enable_character(i):
	var chef = chefs[i]
	chef.set_process(true)
	chef.set_physics_process(true)
	

func disable_character(i):
	var chef = chefs[i]
	chef.set_process(false)
	chef.set_physics_process(false)
	
