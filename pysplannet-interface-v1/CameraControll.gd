extends Camera2D

@export var speed: float = 400.0
@export var zoom_speed: float = 0.3
@onready var hybrid_text_coding = $"../../Map View UI/HSplitContainer/text preview/code_preview"
var transformed_zoom: float = 1.0
var dragging := false
var last_mouse_pos := Vector2.ZERO

func _process(delta: float) -> void:
	if (!hybrid_text_coding.is_editting()):
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
	if event is InputEventMouseButton and event.pressed:
		var delta := 0.0

		# Mouse wheel up/down = scroll event
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			delta = 1.0
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			delta = -1.0
		else:
			return  # Not a scroll, don't do anything else

		# Modifier keys
		var shift := Input.is_key_pressed(KEY_SHIFT)
		var alt := Input.is_key_pressed(KEY_ALT)

		if shift:
			# Move horizontally with wheel + shift
			global_position.x -= delta * 50 / transformed_zoom  # Adjust the 50 to control scroll sensitivity
		elif alt:
			# Move vertically with wheel + alt
			global_position.y -= delta * 50 / transformed_zoom
		else:
			# Zoom
			var zoom_change = delta * 0.1
			transformed_zoom += pow(1 + transformed_zoom, 2) * zoom_speed * zoom_change
			transformed_zoom = clamp(transformed_zoom, 0.1, 10)
			zoom = Vector2.ONE * transformed_zoom


func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MIDDLE:
		dragging = event.pressed
		if dragging:
			last_mouse_pos = get_viewport().get_mouse_position()
