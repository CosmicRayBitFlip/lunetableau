extends Node2D

onready var main_screen     = $"../TitleScreenBoundary"
onready var settings_screen = $"../SettingsScreenBoundary"
onready var keybind_screen  = $"../KeybindScreenBoundary"

enum {MAIN, SETTINGS, KEYBIND}

func _on_SettingsButton_pressed():
	position = settings_screen.rect_position

func _on_KeybindButton_pressed():
	position = keybind_screen.rect_position

func _on_BackButton_pressed(current_screen):
	match current_screen:
		MAIN:
			get_tree().quit(0) # close game
		SETTINGS:
			position = main_screen.rect_position
		KEYBIND:
			position = settings_screen.rect_position
