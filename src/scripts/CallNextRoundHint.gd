extends Label

func _ready():
	var input = InputMap.get_action_list("call_next_round")[0]
	text = KeybindButton.get_input_repr(input) + " to call next round"
