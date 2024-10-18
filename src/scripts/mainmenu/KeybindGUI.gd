extends VBoxContainer

enum {KEY, MOUSE_BUTTON}

func _ready():
	_load()
	for node in get_children():
		if node is KeybindButton:
			connect("ready", node, "_on_inputs_loaded")

func _load():
		var keybinds_file = File.new()
		if keybinds_file.file_exists("user://keybinds.dat"):
			keybinds_file.open("user://keybinds.dat", File.READ)
			
			while true:
				var action = keybinds_file.get_pascal_string()
				if keybinds_file.eof_reached():
					break
				else:
					var input
					InputMap.action_erase_events(action) # discard default inputs
					match keybinds_file.get_8():
						KEY:
							input = InputEventKey.new()
							input.scancode = keybinds_file.get_32()
						MOUSE_BUTTON:
							input = InputEventMouseButton.new()
							input.button_index = keybinds_file.get_8()
					InputMap.action_add_event(action, input)
			
			keybinds_file.close()

func _save():
	var keybinds_file = File.new()
	keybinds_file.open("user://keybinds.dat", File.WRITE)
	var actions = InputMap.get_actions()
	
	for action in actions:
		if not action.begins_with("ui_"):
			keybinds_file.store_pascal_string(action)
			var input = InputMap.get_action_list(action)[0] # only want one input per action
			if input is InputEventKey:
				keybinds_file.store_8(KEY)
				keybinds_file.store_32(input.scancode)
			elif input is InputEventMouseButton:
				keybinds_file.store_8(MOUSE_BUTTON)
				keybinds_file.store_8(input.button_index)
	
	keybinds_file.close()


func _on_BackButton_pressed():
	_save()

func _on_ResetKeybinds_pressed():
	InputMap.load_from_globals()
	for node in get_children():
		if node is KeybindButton:
			node._on_inputs_loaded()
