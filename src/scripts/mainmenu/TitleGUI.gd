extends VBoxContainer

onready var config_menus = get_tree().get_nodes_in_group("configmenu")

func _on_StartButton_pressed():
	for menu in config_menus:
		menu._save()
	
	var game_scene = load("res://src/scenes/Main.tscn")
	get_tree().change_scene_to(game_scene)
