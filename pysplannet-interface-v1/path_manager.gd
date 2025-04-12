extends Node
class_name CommandManager



# Stores all robot commands
var commands: Array[robotCommand] = []

# Starting direction (in degrees)
var startingDirection: float = 90.0

# Generate full command list as text
func get_command_text() -> String:
	var result := ""
	for cmd in get_all_commands():
		result += cmd.get_text() + "\n"
	return result

func clear():
	commands.clear()

# Parse full command text and replace command list
func parse_command_text(text: String) -> void:
	commands.clear()

	for line in text.split("\n", false):
		var cleaned = line.strip_edges()
		if cleaned == "":
			continue

		var cmd = robotCommand.from_text(cleaned)
		if cmd.command == "":
			cmd = robotCommand.new("//commentary", cleaned)

		add_command(cmd)


# Add a command to the queue
func add_command(cmd: robotCommand) -> void:
	commands.append(cmd)

# Get all commands (raw list)
func get_all_commands() -> Array[robotCommand]:
	return commands

# Get only the path-related commands (straight lines and curves)
func get_path_commands() -> Array[robotCommand]:
	return commands.filter(func(cmd): return cmd.command == "straight_line" or cmd.command == "curve"or cmd.command == "set_pos")

# Get the initial direction
func get_starting_direction() -> float:
	return 0

# Get the initial position
func get_starting_position() -> Vector2:
	return Vector2.DOWN

# Set the starting position
func set_pos(pos: Vector2, angle: float) -> void:
	add_command(robotCommand.new("set_pos",str(round_to_decimals(pos.x,2)),str(round_to_decimals(pos.y,2)),str(angle), "", "", ""))


# Create and add a straight line command
func add_straight_line(distance: float, speed: float, smoothing: float) -> void:
	add_command(robotCommand.new("straight_line", str(abs(distance)), str(speed * sign(distance)), str(smoothing), "", "", "", ""))

# Create and add a curve command
func add_curve(degrees: float, speed: float) -> void:
	add_command(robotCommand.new("curve", str(degrees), str(speed), "", "", "", "", ""))

# Remove a command by index
func remove_command(index: int) -> void:
	commands.remove_at(index)

# Remove the last command from the list
func remove_last_command() -> void:
	if commands.size() > 0:
		commands.remove_at(commands.size() - 1)

# Get the coordinate at a specific path point index
func get_path_point_coordinate(index: int) -> Vector2:
	var angle = get_starting_direction()
	var pos = get_starting_position()
	var pathCommands = get_path_commands()
	var i = 0

	for cmd in pathCommands:
		if i == index:
			return pos

		if cmd.command == "straight_line":
			pos += Vector2.from_angle(deg_to_rad(angle)) * cmd.attribute1.to_float() * sign(cmd.attribute2.to_float())
		elif cmd.command == "curve":
			angle += cmd.attribute1.to_float()
		elif cmd.command == "set_pos":
			pos = Vector2(cmd.attribute1.to_float(),cmd.attribute2.to_float())
			angle = cmd.attribute3.to_float()

		i += 1

	return pos

# Get the direction (angle) at a specific path point index
func get_path_point_direction(index: int) -> float:
	var angle = get_starting_direction()
	var pathCommands = get_path_commands()
	var i = 0

	for cmd in pathCommands:
		if i == index:
			return angle
		if cmd.command == "curve":
			angle += cmd.attribute1.to_float()
		elif cmd.command == "set_pos":
			angle = cmd.attribute3.to_float()
		i += 1

	return angle

# Get the final coordinate at the end of the path
func get_last_path_point_coordinate() -> Vector2:
	return get_path_point_coordinate(commands.size())

# Get the final direction at the end of the path
func get_last_path_point_direction() -> float:
	return get_path_point_direction(commands.size())

# Add a point to the path, computing the needed curve + line
func add_point(point: Vector2) -> void:
	var lastPos = get_last_path_point_coordinate()
	var lastDir = get_last_path_point_direction()

	var direction_to_point = (point - lastPos).angle()
	var delta_angle = rad_to_deg(direction_to_point - deg_to_rad(lastDir))

	add_curve(round_to_decimals(delta_angle,3), 10)
	add_straight_line(round_to_decimals(lastPos.distance_to(point),2), 40, 1)

func round_to_decimals(value: float, decimals: int) -> float:
	var factor = pow(10.0, decimals)
	return round(value * factor) / factor
