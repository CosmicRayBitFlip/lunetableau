extends Node

func _ready():
	var success = ProjectSettings.load_resource_pack("lunetableau.pck")
	if not success:
		get_tree().quit(3)
