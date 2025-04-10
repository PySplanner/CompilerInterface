extends TextEdit

@onready var PathManager = $"../../../../../map_view/PathManager"

func _process(delta):
	refresh_command_list()


# Displays all commands in the text editor
func refresh_command_list():
	clear()
	var newText = ""

	for cmd in PathManager.get_all_commands():
		newText = newText + cmd.get_text() + '\n'
	
	text = newText
	
