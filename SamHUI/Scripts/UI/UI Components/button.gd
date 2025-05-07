extends Button
#This script animated the button through tweening and changes its font color

func _on_mouse_entered() -> void:
	var tween = create_tween()
	var yellow = Color(1, 0.95, 0, 1)
	$Label.label_settings.font_color = yellow
	tween.tween_property($Label, "scale", Vector2(2,2), 0.1)
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	var tween = create_tween()
	var white = Color(1.0,1.0,1.0,1.0)
	$Label.label_settings.font_color = white
	tween.tween_property($Label, "scale", Vector2(1,1), 0.1)
	pass # Replace with function body.
