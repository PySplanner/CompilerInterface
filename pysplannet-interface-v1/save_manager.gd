extends Node
class_name SaveManager

@onready var path_manager = %PathManager
@onready var file_dialog = $FileDialog

var is_saving := false
var is_save_as := false
var last_save_path: String = ""

func _ready():
	# Connect FileDialog signal if not already connected
	if not file_dialog.file_selected.is_connected(_on_FileDialog_file_selected):
		file_dialog.file_selected.connect(_on_FileDialog_file_selected)


# 🔘 Public: Save (uses last path or falls back to Save As)
func save():
	if last_save_path != "":
		save_to_path(last_save_path)
	else:
		save_as()

# 🔘 Public: Save As (open file dialog)
func save_as():
	is_saving = true
	is_save_as = true
	file_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.clear_filters()
	file_dialog.add_filter("*.runcompiler; RunCompiler save file")
	file_dialog.set_current_file("my_path.runcompiler")
	file_dialog.popup_centered()

# 🔘 Public: Load (open file dialog)
func load():
	is_saving = false
	is_save_as = false
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.clear_filters()
	file_dialog.add_filter("*.runcompiler; RunCompiler save file")
	file_dialog.popup_centered()

# 📁 File selected via FileDialog
func _on_FileDialog_file_selected(path: String):
	if is_saving:
		save_to_path(path)
		last_save_path = path
	else:
		load_from_path(path)
		last_save_path = path

# 💾 Save as plain text
func save_to_path(path: String):
	var file = FileAccess.open(path, FileAccess.WRITE)
	if not file:
		push_error("Failed to open file for saving: " + path)
		return

	var command_text = path_manager.get_command_text()
	file.store_string(command_text)
	file.close()

	print("✅ Saved command text to:", path)

# 📥 Load and parse plain text
func load_from_path(path: String):
	if not FileAccess.file_exists(path):
		push_error("No file found at: " + path)
		return

	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("Failed to open file: " + path)
		return

	var content = file.get_as_text()
	file.close()

	path_manager.parse_command_text(content)

	print("📥 Loaded and parsed command text from:", path)
