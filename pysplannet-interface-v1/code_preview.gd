extends TextEdit

@onready var PathManager = $"../../../../map_view/PathManager"

var was_inside := false  # Track if we were inside last frame

func _process(delta):
	var local_mouse = get_local_mouse_position()
	var is_inside = Rect2(Vector2.ZERO, size).has_point(local_mouse)

	# When entering: make editable
	if is_inside and not was_inside:
		editable = true

	# When exiting: apply text and lock
	if not is_inside and was_inside:
		editable = false
		apply_edited_commands()
	
	if not is_inside:
		refresh_command_list()

	# Update for next frame
	was_inside = is_inside

# Refresh the list when we lose focus (or manually)
func refresh_command_list():
	var newText := ""

	for cmd in PathManager.get_all_commands():
		newText += cmd.get_text() + "\n"

	text = newText

# Apply changes: parse text and rebuild command list
func apply_edited_commands():
	PathManager.commands.clear()

	for line in text.split("\n", false):
		var cleaned = line.strip_edges()
		if cleaned == "":
			continue

		var cmd = robotCommand.from_text(cleaned)

		# Check if the command was valid (basic check: not empty)
		if cmd.command == "":
			# Make a comment-style command
			cmd = robotCommand.new("//comentary", cleaned)

		PathManager.add_command(cmd)

	# Optional: refresh to reformat after apply
	refresh_command_list()
