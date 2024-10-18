tool
extends ToolButton

class_name KeybindButton

export var action:String
export var user_interface_name:String setget set_ui_name

const default_text = "Configure this button in the Inspector."

var current_input:InputEvent
var value:String 

func _init():
	if Engine.editor_hint:
		text = default_text
	toggle_mode = true
	
	

func _ready():
	if not Engine.editor_hint:
		assert(action and user_interface_name, "Button is not properly configured.")
		

func _input(event):
	if not Engine.editor_hint and pressed:
		if event is InputEventKey or event is InputEventMouseButton:
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, event)
			current_input = InputMap.get_action_list(action)[0]
			value = get_input_repr(current_input)
			redraw()
			pressed = false
			get_tree().set_input_as_handled()
		if event is InputEventMouseMotion:
			get_tree().set_input_as_handled()

func redraw():
	if user_interface_name:
		if Engine.editor_hint:
			text = user_interface_name + ": (value)" 
		else: # guh i hope this works
			current_input = InputMap.get_action_list(action)[0]
			value = get_input_repr(current_input)
			text = user_interface_name + ": " + value
	else:
		text = default_text

func set_ui_name(new_name):
	user_interface_name = new_name
	redraw()

static func get_input_repr(event):
	if event is InputEventKey:
		return OS.get_scancode_string(event.scancode)
	elif event is InputEventMouseButton:
		match event.button_index:
			BUTTON_LEFT:
				return "Left Click"
			BUTTON_RIGHT:
				return "Right Click"
			BUTTON_MIDDLE:
				return "Middle Click"
			BUTTON_WHEEL_UP:
				return "Mouse Wheel Up"
			BUTTON_WHEEL_DOWN:
				return "Mouse Wheel Down"
			BUTTON_WHEEL_LEFT:
				return "Mouse Wheel Left"
			BUTTON_WHEEL_RIGHT:
				return "Mouse Wheel Right"
			_:
				return "Mouse" + str(event.button_index - 4) # Mouse 4, etc (Mouse 4 is index 8)

func _on_inputs_loaded():
	redraw()
