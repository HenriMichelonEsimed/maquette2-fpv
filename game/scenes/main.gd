extends Node3D

func _input(event):
	if (event is InputEventKey):
		if (event.physical_keycode == KEY_Z) and (Input.is_key_pressed(KEY_CTRL)):
			get_tree().quit()
