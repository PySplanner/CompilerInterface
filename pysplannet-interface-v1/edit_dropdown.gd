extends MenuButton

@onready var SaveManager = %save_manager
@onready var PathManager = %PathManager
var config_window: Window

func _ready():
	var popup = get_popup()
#================[ menu itens }=====================
	popup.add_item("undo")
	popup.add_item("redo")
	popup.add_separator()
	popup.add_item("project settings")

	# Connect the signal (once!)
	if not popup.id_pressed.is_connected(_on_menu_item_selected):
		popup.id_pressed.connect(_on_menu_item_selected)


#================[ config window setup }=====================
	var packed_scene = preload("res://project_config.tscn")
	config_window = packed_scene.instantiate()

	# Defer adding to the tree so it happens after this node is fully ready
	call_deferred("_add_config_window_to_tree")




func _on_menu_item_selected(id: int):
	var label = get_popup().get_item_text(id)

	match label:
		"project settings":
			config_window.popup_centered()  # Opens it centered on screen
			config_window.show()

		_:
			print("❓ Unknown menu option:", label)




func _add_config_window_to_tree():
	get_tree().root.add_child(config_window)
	config_window.hide()  # op
