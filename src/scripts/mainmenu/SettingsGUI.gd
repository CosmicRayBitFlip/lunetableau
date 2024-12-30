extends VBoxContainer

const VERSION:int = 2

var settings = File.new()
onready var gfx_switch      = $GFXSwitch
onready var autofire_switch = $AutofireSwitch
onready var fps_switch      = $FpsSwitch
onready var debug_switch    = $DebugSwitch

func _load():
	settings.open("user://settings.dat", File.READ)
	if settings.file_exists("user://settings.dat"):
		if settings.get_32() <= VERSION:
			gfx_switch.pressed      = bool(settings.get_8())
			autofire_switch.pressed = bool(settings.get_8())
			fps_switch.pressed      = bool(settings.get_8())
			debug_switch.pressed    = bool(settings.get_8())
		else:
			print("SETTINGS FILE IS FROM A NEWER VERSION OF THE GAME.")
			get_tree().quit(1)
	settings.close()

func _save():
	settings.open("user://settings.dat", File.WRITE)
	settings.store_32(VERSION)
	settings.store_8(int(gfx_switch.pressed))
	settings.store_8(int(autofire_switch.pressed))
	settings.store_8(int(fps_switch.pressed))
	settings.store_8(int(debug_switch.pressed))
	settings.close()

func _ready():
	_load()

func _on_BackButton_pressed():
	_save()
