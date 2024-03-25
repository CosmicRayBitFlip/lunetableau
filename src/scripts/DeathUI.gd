extends VBoxContainer

func _on_RestartButton_pressed():
	var game_scene = load("res://src/scenes/Main.tscn")
	get_tree().change_scene_to(game_scene)

func _on_HomeButton_pressed():
	var menu_scene = load("res://src/scenes/MainMenu.tscn")
	get_tree().change_scene_to(menu_scene)
