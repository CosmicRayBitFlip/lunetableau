extends Node2D

onready var pathmgr = $PathManager
onready var paths = [ # when accessing use `Enemy` team name constants
	$PathManager/WhitePath, 
	$PathManager/RedPath, 
	$PathManager/BluePath, 
	$PathManager/YellowPath
]
const spawn_points = PoolVector2Array([
	Vector2(0, -90),
	Vector2(180, 0),
	Vector2(0, 90),
	Vector2(-180, 0)
])
var spawn_point_ptr:int = 0
var RobotEnemy = preload("res://src/scenes/RobotEnemy.tscn")
var EyeEnemy = preload("res://src/scenes/EyeEnemy.tscn")

var robot_enemies = [[],[]]
var r_pathfollows = robot_enemies[0]; var r_instances = robot_enemies[1]
var eye_enemies = []

var current_round = 0
var spawn_queue = 0
var enemies_left = 0
var time_between_spawns = 1.0
var time_since_last_spawn = time_between_spawns

var score = 0
var cash = 0

func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("debug_spawn_enemy"):
			if event.shift:
				spawn_eye_robot(spawn_points[spawn_point_ptr])
			else:
				spawn_normal_robot(rand_range(Enemy.WHITE, Enemy.YELLOW), spawn_points[spawn_point_ptr], Vector2.DOWN)
			enemies_left += 1
			spawn_point_ptr = (spawn_point_ptr + 1) % spawn_points.size()
		if Input.is_action_just_pressed("call_next_round"):
			if enemies_left == 0:
				call_next_round()

func _process(delta):
	time_since_last_spawn += delta
	if spawn_queue and time_since_last_spawn > 1.0:
		spawn_normal_robot(rand_range(Enemy.WHITE, Enemy.YELLOW), spawn_points[spawn_point_ptr], Vector2.DOWN)
		spawn_queue -= 1
		spawn_point_ptr = (spawn_point_ptr + 1) % spawn_points.size()
		time_since_last_spawn = 0.0

func call_next_round():
	var amt_of_robots = rand_range(10.0, 50.0) * (current_round * 0.1)
	amt_of_robots = int(clamp(amt_of_robots, 5.0, 100.0))
	spawn_queue = amt_of_robots
	enemies_left = spawn_queue
	
	current_round += 1

func spawn_normal_robot(team:int, spawn_pos:Vector2, direction:Vector2): 
	# init PathFollow2D
	r_pathfollows.append(PathFollow2D.new())
	r_pathfollows[-1].rotate = false
	r_pathfollows[-1].loop = true
	paths[team].add_child(r_pathfollows[-1])
	
	# init RobotEnemy
	r_instances.append(RobotEnemy.instance())
	r_pathfollows[-1].add_child(r_instances[-1])
	r_instances[-1].spawn(spawn_pos, direction)

func spawn_eye_robot(spawn_pos:Vector2):
	eye_enemies.append(EyeEnemy.instance())
	add_child(eye_enemies[-1])
	eye_enemies[-1].spawn(spawn_pos)

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
