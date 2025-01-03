extends Node2D

onready var pathmgr = $PathManager
onready var paths   = [ # when accessing use `Enemy` team name constants
	$PathManager/WhitePath, 
	$PathManager/RedPath, 
	$PathManager/BluePath, 
	$PathManager/YellowPath
]
onready var player        = $Player
onready var env           = $WorldEnvironment
onready var debug_menu    = $UILayer/DebugManager
onready var cmd_entry_box = $UILayer/DebugManager/CommandEntryPanel/CommandEntryBox
onready var fps_counter   = $UILayer/FPS

var spawn_points        = PoolVector2Array([
	Vector2(0, -375),
	Vector2(650, 0),
	Vector2(0, 375),
	Vector2(-650, 0)
])
var spawn_point_ptr:int = 0

var RobotEnemy    = preload("res://src/scenes/RobotEnemy.tscn")
var EyeEnemy      = preload("res://src/scenes/EyeEnemy.tscn")

var robot_enemies = [[],[]]
var r_pathfollows = robot_enemies[0]; var r_instances = robot_enemies[1]
var eye_enemies   = []

var gfx      = true
var show_fps = false
var debug    = false

var blurred   = true
var blur_time = 0.5 

var current_round         = 0
var spawn_queue           = 0
var enemies_left          = 0
var time_between_spawns   = 1.0
var time_since_last_spawn = time_between_spawns

var score = 0
var cash  = 0


func _ready():
	var settings_file = File.new()
	settings_file.open("user://settings.dat", File.READ)
	settings_file.get_32() # save file version number
	gfx      = bool(settings_file.get_8())
	settings_file.get_8() # autofire setting
	show_fps = bool(settings_file.get_8())
	debug    = bool(settings_file.get_8())
	settings_file.close()
	
	if gfx == false: 
		env.environment = preload("res://src/res/NoEffectsEnvironment.tres") # TODO: investigate performance issue
	else:
		env.environment.dof_blur_near_amount = env.blur_amt
	
	if show_fps == false:
		fps_counter.queue_free()
	
func _input(event):
	if Input.is_action_just_pressed("debug_open_console") and debug:
		debug_menu.visible = not debug_menu.visible
		if debug_menu.visible: cmd_entry_box.grab_focus()
		get_tree().set_input_as_handled()
	if not debug_menu.is_visible_in_tree():
		if event is InputEventKey:
			if Input.is_action_just_pressed("debug_spawn_enemy") and debug:
				if event.shift:
					spawn_eye_robot(spawn_points[spawn_point_ptr])
					pass
				else:
					spawn_normal_robot(rand_range(Enemy.WHITE, Enemy.YELLOW), spawn_points[spawn_point_ptr], spawn_point_ptr)
				enemies_left += 1
				spawn_point_ptr = (spawn_point_ptr + 1) % spawn_points.size()
			if Input.is_action_just_pressed("call_next_round"):
				if enemies_left == 0:
					player.healed = false
					call_next_round()

func _process(delta):
	time_since_last_spawn += delta
	if spawn_queue and time_since_last_spawn > time_between_spawns:
		if current_round % 2 == 1:
			spawn_normal_robot(rand_range(Enemy.WHITE, Enemy.YELLOW), spawn_points[spawn_point_ptr], spawn_point_ptr)
		else:
			spawn_eye_robot(spawn_points[spawn_point_ptr])
		spawn_queue -= 1
		spawn_point_ptr = (spawn_point_ptr + 1) % spawn_points.size()
		time_since_last_spawn = 0.0
	if gfx == true:
		if enemies_left == 0 and not blurred:
			env.blur(true, blur_time)
			blurred = true
		elif enemies_left != 0 and blurred:
			env.blur(false, blur_time)
			blurred = false

func call_next_round():
	var amt_of_robots = rand_range(10.0, 50.0) * (current_round * 0.1)
	amt_of_robots = int(clamp(amt_of_robots, 5.0, 100.0))
	time_between_spawns = 1.0/(1.0 + (amt_of_robots / 10))
	print(time_between_spawns)
	spawn_queue = amt_of_robots
	enemies_left = spawn_queue
	
	current_round += 1

func spawn_normal_robot(team:int, spawn_pos:Vector2, idx:int): 
	# init PathFollow2D
	r_pathfollows.append(PathFollow2D.new())
	r_pathfollows[-1].rotate = false
	r_pathfollows[-1].loop = true
	paths[team].add_child(r_pathfollows[-1])
	
	# init RobotEnemy
	r_instances.append(RobotEnemy.instance())
	r_pathfollows[-1].add_child(r_instances[-1])
	r_instances[-1].spawn_idx = spawn_point_ptr
	r_instances[-1].spawn(spawn_pos)

func spawn_eye_robot(spawn_pos:Vector2):
	eye_enemies.append(EyeEnemy.instance())
	add_child(eye_enemies[-1])
	eye_enemies[-1].spawn(spawn_pos)

# ignore this function please nothing calls it
# i just like preservation
func idk_imma_leave_this_here(event): # old code from a bygone era
	if Input.is_key_pressed(KEY_P):
		var bot1 = RobotEnemy.instance()
		bot1.spawn( # i don't even know what's happening here
			Enemy.WHITE, 
			$ArrowTilemap.get_arrow_dict(Enemy.WHITE), 
			$ArrowTilemap.get_spawn_positions()[Enemy.WHITE], 
			Vector2.DOWN
		)
		add_child(bot1)
