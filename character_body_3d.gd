extends CharacterBody3D
# How fast the player moves in meters per second.
@export var speed = 10
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75
@export var rotation_speed = 10
var last_direction = Vector3.FORWARD
var target_velocity = Vector3.ZERO
var dash_speed = 20
var direction=Vector3.ZERO






func inpuut(event):
	if !$AnimationTree.get("parameters/conditions/roll"):
		if $dash_window.is_stopped():
			$dash_window.start()
		if !$roll_window.is_stopped():
				velocity = direction * dash_speed 
				$dash_window.stop()
				$AnimationTree.set("parameters/conditions/roll", true)
				
				$dash_window.start()
func _physics_process(delta):
	var directional_input = Input.get_vector("left", "right", "forward", "back",)
	#if !$dash_window.is_stopped():
	#	speed=20
	#else:
	#	speed =10
	speed = 10
	direction = (transform.basis * Vector3(directional_input.x, 0, directional_input.y)).normalized()
	
	if direction:
		last_direction = direction
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		
	
	
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	
	
	$ChefTest1.rotation.y = lerp_angle($ChefTest1.rotation.y, atan2(-last_direction.x, -last_direction.z), delta * rotation_speed)
	
	#dash that doesnt work it registers the input but just tposes
	#if Input.is_action_pressed("dash"):
		#anim_state.travel("parameters/moving/roll/blend_position")

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$pivot.basis = Basis.looking_at(direction)
		

	if Input.is_action_just_pressed("dash"):
		if $dash_window.is_stopped():
			$dash_window.start()
	if Input.is_action_just_released("dash"):
		if !$dash_window.is_stopped():
			velocity=direction*dash_speed
			$dash_window.stop()
			



	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	velocity = target_velocity
	move_and_slide()
