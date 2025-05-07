extends CheckBox

func _ready() -> void:
	if DisplayServer.window_get_vsync_mode() != 0:
		self.button_pressed = true

func _on_toggled(toggled_on: bool) -> void:
	if (toggled_on == true):
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
