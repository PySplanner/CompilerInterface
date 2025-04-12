extends Button

@onready var inputHandler = %custom_input_handler
@onready var tools = %tools

func _ready():
	inputHandler.connect("custom_mouse_input", Callable(self, "_custom_mouse_input"))

func _custom_mouse_input(mouse_event, index):
	if mouse_event is InputEventMouseButton and mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT and index == 0:
		var local_mouse = get_local_mouse_position()
		if Rect2(Vector2.ZERO, size).has_point(local_mouse):
			inputHandler.add_to_handle(1)
			tools.set_tool(name)
