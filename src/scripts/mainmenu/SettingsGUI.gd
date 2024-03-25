extends VBoxContainer

var settings = File.new()
onready var gfx_switch = $GFXSwitch
onready var autofire_switch = $AutofireSwitch

func _ready():
	settings.open("user://settings.dat", File.READ)
	if settings.file_exists("user://settings.dat"):
		gfx_switch.pressed      = bool(settings.get_8())
		autofire_switch.pressed = bool(settings.get_8())
	settings.close()


func _on_BackButton_pressed():
	settings.open("user://settings.dat", File.WRITE)
	settings.store_8(int(gfx_switch.pressed))
	settings.store_8(int(autofire_switch.pressed))
	settings.close()
