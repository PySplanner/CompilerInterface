extends Node
class_name robotCommand

# Command name + up to 7 optional attributes
var command: String
var attribute1: String
var attribute2: String
var attribute3: String
var attribute4: String
var attribute5: String
var attribute6: String
var attribute7: String

func _init(command := "", a1 := "", a2 := "", a3 := "", a4 := "", a5 := "", a6 := "", a7 := ""):
	self.command = command
	self.attribute1 = a1
	self.attribute2 = a2
	self.attribute3 = a3
	self.attribute4 = a4
	self.attribute5 = a5
	self.attribute6 = a6
	self.attribute7 = a7

# Convert command to display text (including special case for comments)
func get_text() -> String:
	if command.begins_with("//"):
		return "// " + attribute1.strip_edges()

	var attributes = [
		attribute1, attribute2, attribute3, attribute4,
		attribute5, attribute6, attribute7
	]
	var non_empty = []
	for attr in attributes:
		if attr.strip_edges() != "":
			non_empty.append(attr)

	return "%s(%s)" % [command, ", ".join(non_empty)]

# Parse from a string like "curve(90, 10)" or "// something"
static func from_text(text: String) -> robotCommand:
	var line = text.strip_edges()

	# Handle comments starting with //
	if line.begins_with("//"):
		var comment_text = line.substr(2).strip_edges()
		return robotCommand.new("//commentary", comment_text)

	# Match function-style commands: command(arg1, arg2, ...)
	var pattern = r"^(\w+)\((.*?)\)$"
	var regex = RegEx.new()
	var result = regex.compile(pattern)
	if result != OK:
		push_error("Invalid regex!")
		return robotCommand.new()

	var match = regex.search(line)
	if not match:
		# Not a valid command format
		return robotCommand.new()

	var cmd_name = match.get_string(1)
	var args_string = match.get_string(2)
	var args = args_string.split(",", false)
	for i in range(args.size()):
		args[i] = args[i].strip_edges()

	while args.size() < 7:
		args.append("")  # pad to match attribute count

	return robotCommand.new(cmd_name, args[0], args[1], args[2], args[3], args[4], args[5], args[6])
