extends VBoxContainer

func _on_ResumeButton_pressed():
	get_tree().paused = false
	hide()

func _on_RestartButton_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_HomeButton_pressed():
	get_tree().paused = false
	var menu_scene = load("res://src/scenes/MainMenu.tscn")
	get_tree().change_scene_to(menu_scene)

