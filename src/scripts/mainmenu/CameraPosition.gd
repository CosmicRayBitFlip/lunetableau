extends Node2D

onready var main_screen     = $"../TitleScreenBoundary"
onready var settings_screen = $"../SettingsScreenBoundary"

func _on_SettingsButton_pressed():
	position = settings_screen.rect_position

func _on_BackButton_pressed():
	position = main_screen.rect_position
