extends "res://tools.gd"

func _process(delta):

	if Input.is_key_pressed(KEY_T):
		print("meow")
		PathManager.add_point(get_mouse_pos_map_space())
