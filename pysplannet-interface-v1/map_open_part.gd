extends Container

@onready var target = %tools
@onready var inputHandler = %custom_input_handler

func _ready():
	inputHandler.connect("custom_mouse_input", Callable(self, "_custom_mouse_input"))

func _custom_mouse_input(mouse_event, index):
	if mouse_event is InputEventMouseButton and mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT and inputHandler.is_handled(0) and index == 1:
		var local_mouse = get_local_mouse_position()
		if Rect2(Vector2.ZERO, size).has_point(local_mouse):
			if target and target.has_method("on_grid_container_clicked"):
				target.on_grid_container_clicked()
