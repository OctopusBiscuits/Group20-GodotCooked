extends BaseCharacter
class_name Character2


func _init():
	speed = 10
	dash_speed = 20
	# Character 1 specific initialization

# Override any methods you want to customize
func _physics_process(delta):
	super._physics_process(delta)
	# Add any additional Character1 specific processing
