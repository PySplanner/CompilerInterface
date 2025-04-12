extends MenuButton

@onready var SaveManager = %save_manager
@onready var PathManager = %PathManager

func _ready():
	var popup = get_popup()

	# Add menu items
	popup.add_item("new")
	popup.add_separator()
	popup.add_item("open")
	popup.add_separator()
	popup.add_item("save")
	popup.add_item("save as")

	# Connect the signal (once!)
	if not popup.id_pressed.is_connected(_on_menu_item_selected):
		popup.id_pressed.connect(_on_menu_item_selected)

func _on_menu_item_selected(id: int):
	var label = get_popup().get_item_text(id)

	match label:
		"new":
			PathManager.clear()

		"open":
			SaveManager.load()

		"save":
			SaveManager.save()

		"save as":
			SaveManager.save_as()

		_:
			print("❓ Unknown menu option:", label)
