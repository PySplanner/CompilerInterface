extends Node
signal custom_mouse_input(mouse_event,index)


var n_of_handles = 0

func _input(event):
	for i in range(4):
		emit_signal("custom_mouse_input",event, i)
	n_of_handles = 0

func add_to_handle(n):
	n_of_handles += n

func set_to_handle(n):
	n_of_handles = n

func is_handled(n) -> bool:
	return n >= n_of_handles
