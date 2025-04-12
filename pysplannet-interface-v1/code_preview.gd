extends TextEdit

@onready var PathManager = %PathManager

var was_inside = false  # Track if we were inside so it does not update every single frame :3
var is_editing = false

func is_editting() -> bool:
	return is_editing

func _process(delta):
	var local_mouse = get_local_mouse_position()
	var is_inside = Rect2(Vector2.ZERO, size).has_point(local_mouse)

	# When entering: make editable
	if is_inside and not was_inside:
		editable = true
		is_editing = true

	# When exiting: apply text and lock
	if not is_inside and was_inside:
		editable = false
		PathManager.parse_command_text(text)
		is_editing = false
	
	if not is_inside:
		text = PathManager.get_command_text()
		

	# Update for next frame
	was_inside = is_inside
