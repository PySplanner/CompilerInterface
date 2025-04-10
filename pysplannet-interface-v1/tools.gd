extends Node

var time = 0.0
@onready var PathManager = $"../PathManager"
@onready var MapView = $".."

var selectedTool = "add_points"
var was_left_mouse_pressed = false

func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and !was_left_mouse_pressed:
		was_left_mouse_pressed = true
		if selectedTool == "add_points":
			add_point_left_click()
		elif selectedTool == "other":
			print("meow")

	else:
		was_left_mouse_pressed = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)

func add_point_left_click():
	print("meow")
	PathManager.add_point(MapView.get_mouse_pos_map_space())
