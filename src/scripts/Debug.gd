extends Control

onready var command_history     = $CommandHistoryPanel/Scrollbar/CommandHistory
onready var scrollbar_container = $CommandHistoryPanel/Scrollbar
onready var history_scrollbar   = scrollbar_container.get_v_scrollbar()
onready var entry_box           = $CommandEntryPanel/CommandEntryBox

onready var scene_root = $"/root/Game"
onready var player = scene_root.get_node("Player")

const prefix = "> "

var clear_queued = false

func _ready():
	command_history.text = ""

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_ENTER and event.pressed and not event.echo:
			if entry_box.has_focus() and entry_box.text != "":
				submit_command(entry_box.text)
				entry_box.text = ""

func submit_command(cmd:String):
	command_history.text += prefix + cmd + "\n" + parse_command(cmd) + "\n"
	if clear_queued:
		command_history.text = ""
		clear_queued = false

func parse_command(cmd) -> String:
	var argv = Array(cmd.split(" ", false))
	match argv[0]:
		"`help`":
			return "I meant without the backticks..."
		"help":
			return help(argv[1] if argv.size() == 2 else "")
		"echo":
			var input_str = cmd.trim_prefix("echo ")
			return echo(input_str)
		"clear":
			clear_queued = true
			return ""
		"set":
			if   argv.size() >= 3:
				return set(argv[1], argv[2])
			elif argv.size() == 2:
				return "ERROR: No value specified for `{0}`.".format([argv[1]])
			else:
				return "ERROR: No variable to set."
		"god":
			return god()
		_:
			return "`{0}` is not a valid command. Type `help` to see available commands".format([cmd])

func help(arg:String = ""):
	match arg:
		"":
			return get_help_text()
		"set":
			return get_help_set()
		_:
			return "No help available for this command"

func get_help_text():
	return (
	"help: shows this help text\n (available help subpages: set)\n" +
	"echo: prints its input to the console\n" +
	"set (var) (value): sets the corresponding variable to that value\n" +
	"god: toggles god mode\n" +
	""
)

func echo(input:String):
	return input
	# when problems overwhelm us and sadness smothers us,
	# where do we find the will and the courage to continue?
	# well, the answer may come in the caring voice of a friend,
	# a chance encounter with a book,
	# or from a personal faith.
	# for janet, help came from her faith,
	# but it also came from a squirrel.
	# shortly after her divorce, janet lost her father.
	# then she lost her job.
	# she had mounting money problems.
	# but janet not only survived, 
	# she worked her way out of despondency and now she says
	"LIFE IS GOOD AGAIN!"
	# how could this happen?
	# she told me that late, one autumn day,
	# when she was at her lowest,
	# she watched a squirrel storing up nuts for the winter.
	# one at a time, he would take them to the nest.
	# and she thought
	"If that squirrel can take care of himself with the harsh winter coming on, "
	"so can I."
	"Once I broke my problems into small pieces,"
	"I was able to carry them, just like those akerns,"
	"ONE AT A TIME."

func set(name:String, value:String):
	match name:
		"hp":
			if value.is_valid_integer(): player.hp = int(value)
		"minhp":
			if value.is_valid_integer(): player.default_hp = int(value)
		"damagelvl":
			if value.is_valid_integer(): player.damage_modifier = int(value)
		"piercelvl":
			if value.is_valid_integer(): player.pierce_modifier = int(value)
		"hplvl":
			if value.is_valid_integer(): player.hp_modifier = int(value)
		"speed":
			if value.is_valid_integer(): player.speed = int(value)
		"cooldown":
			if value.is_valid_integer(): player.weapon_cooldown = int(value)
		"autofire":
			if value.is_valid_integer(): player.autofire = bool(int(value))
		"round":
			if value.is_valid_integer(): scene_root.current_round = int(value)
		_:
			return "ERROR: {0} is not a valid variable.".format([name])
	return "Set `{0}` to value `{1}`.".format([name, value])

func get_help_set():
	return (
		"hp (int): player's current hp\n" +
		"minhp (int): the default hp of the player before upgrades\n" +
		"damagelvl (int): the level of the damage stat\n" +
		"piercelvl (int): the level of the pierce stat\n" +
		"hplevel (int): the level of the max hp stat\n" +
		"speed (int): the speed of the player in px/s\n" +
		"cooldown (int): the player's weapon fire cooldown\n" +
		"autofire (bit): whether the player automatically fires again if holding the shoot button\n" +
		"round (int): the current round\n" +
		""
	)

onready var autofire_setting = false
func god():
	if not player.is_god:
		player.is_god = true
		autofire_setting = player.autofire
		player.autofire = true
		return "YOU ARE NOW INCINVICBLE!!!"
	else:
		player.is_god = false
		player.autofire = autofire_setting
		return "You are now Normal."
