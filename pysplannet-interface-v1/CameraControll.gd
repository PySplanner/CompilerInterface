extends Camera2D

@export var speed: float = 400.0
@export var zoom_speed: float = 0.3
@export var drag_button: MouseButton = MOUSE_BUTTON_MIDDLE
var transformed_zoom: float = 1.0
var dragging := false
var last_mouse_pos := Vector2.ZERO

func _process(delta: float) -> void:
	var direction = Vector2.ZERO
	var zoom_change := 0.0

	# Movement input (WASD + arrow keys)
	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		direction.x += 1
	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		direction.x -= 1
	if Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S):
		direction.y += 1
	if Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W):
		direction.y -= 1

	# Zoom input (Q = out, E = in)
	if Input.is_key_pressed(KEY_E):
		zoom_change -= 1.0
	if Input.is_key_pressed(KEY_Q):
		zoom_change += 1.0

	# Normalize movement
	if direction != Vector2.ZERO:
		direction = direction.normalized()

	# Move camera based on current zoom level
	global_position += direction * speed * delta / transformed_zoom

	# Update zoom
	transformed_zoom += pow(1 + transformed_zoom, 2) * zoom_speed * zoom_change * delta
	#clamp betwen 0.1 and 10
	transformed_zoom = max(min(transformed_zoom, 10),0.1)
	
	# Apply zoom to camera
	zoom = Vector2.ONE * transformed_zoom
	
	if dragging:
		var current_mouse_pos = get_viewport().get_mouse_position()
		var delta_mouse = (last_mouse_pos - current_mouse_pos)
		global_position += delta_mouse / zoom
		last_mouse_pos = current_mouse_pos
	
func _unhandled_input(event):
	var zoom_change = 0
	# Mouse wheel zoom
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			zoom_change += 0.1  # Zoom in
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			zoom_change -= 0.1  # Zoom out
			
		transformed_zoom += pow(1 + transformed_zoom, 2) * zoom_speed * zoom_change
		#clamp betwen 0.1 and 10
		transformed_zoom = max(min(transformed_zoom, 10),0.1)
		zoom = Vector2.ONE * transformed_zoom
			
		# Start/stop dragging
		if event.button_index == drag_button:
			dragging = event.pressed
			if dragging:
				last_mouse_pos = get_viewport().get_mouse_position()
