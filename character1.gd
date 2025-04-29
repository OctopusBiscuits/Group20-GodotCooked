extends BaseCharacter
class_name Character1

func _init():
	speed = 10
	dash_speed = 20
	# Character 1 specific initialization


func _physics_process(delta):
	super._physics_process(delta)
