extends VBoxContainer

func _on_StartButton_pressed():
	var game_scene = load("res://src/scenes/Main.tscn")
	get_tree().change_scene_to(game_scene)
