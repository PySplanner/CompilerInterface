extends Node

@export var pixel_to_cm: float = 20.0  # 1 cm = 10 pixels

# Get the Camera2D node
func get_camera() -> Camera2D:
	return $MapViewCamera

# Get mouse position in world/map space (pixels)
func get_mouse_pos_map_space() -> Vector2:
	var camera = get_camera()
	return camera.get_global_mouse_position()

# Get mouse position in map space (centimeters)
func get_mouse_pos_map_space_cm() -> Vector2:
	return pixels_to_cm(get_mouse_pos_map_space())

# Convert pixel position to centimeters
func pixels_to_cm(pos: Vector2) -> Vector2:
	return pos / pixel_to_cm

# Convert centimeters to pixel position
func cm_to_pixels(pos_cm: Vector2) -> Vector2:
	return pos_cm * pixel_to_cm

func pixels_to_cm_float(pos: float) -> float:
	return pos / pixel_to_cm

# Convert centimeters to pixel position
func cm_to_pixels_float(pos_cm: float) -> float:
	return pos_cm * pixel_to_cm
