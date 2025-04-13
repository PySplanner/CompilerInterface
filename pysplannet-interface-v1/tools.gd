extends Node

var time = 0.0
var draggind_point = false
var tools_enabled = false
@onready var PathManager = %PathManager
@onready var MapView = %map_view

var selectedTool = "add_points"

func set_tool(tool):
	selectedTool = tool

func set_tools_enabled(enabled: bool):
	tools_enabled = enabled

func on_grid_container_clicked():
	if (!tools_enabled):
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if selectedTool == "add_points":
				add_point_left_click()
			elif selectedTool == "other":
				print("Nyaaaaa~~~that tool does not exist u messed up azura your uselessss galllll")
			elif selectedTool == "move_points":
				move_point_left_click()
				print("moving")

func add_point_left_click():
	if PathManager.get_path_commands().size() == 0:
		PathManager.set_pos(MapView.get_mouse_pos_map_space_cm(),0)
	else:
		PathManager.add_point(MapView.get_mouse_pos_map_space_cm())

func move_point_left_click():
	var point = PathManager.get_intersecting_point(MapView.get_mouse_pos_map_space_cm(),2)
	print(point)
	draggind_point = true
