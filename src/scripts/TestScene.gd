extends Node2D

onready var pathmgr = $PathManager
onready var paths = [ # when accessing use `Enemy` team name constants
	$PathManager/WhitePath, 
	$PathManager/RedPath, 
	$PathManager/BluePath, 
	$PathManager/YellowPath
]
var RobotEnemy = preload("res://src/scenes/RobotEnemy.tscn")

var robot_enemies = [[],[]]
var r_pathfollows = robot_enemies[0]; var r_instances = robot_enemies[1]
var eye_enemies = []

func _input(event):
	if Input.is_action_just_pressed("debug_spawn_enemy"):
		spawn_normal_robot(Enemy.WHITE, Vector2.ZERO, Vector2.DOWN)

func idk_imma_leave_this_here(event):
	if Input.is_key_pressed(KEY_P):
		var bot1 = RobotEnemy.instance()
		bot1.spawn( # i don't even know what's happening here
			Enemy.WHITE, 
			$ArrowTilemap.get_arrow_dict(Enemy.WHITE), 
			$ArrowTilemap.get_spawn_positions()[Enemy.WHITE], 
			Vector2.DOWN
		)
		add_child(bot1)

func spawn_normal_robot(team:int, spawn_pos:Vector2, direction:Vector2): 
	r_pathfollows.append(PathFollow2D.new())
	paths[team].add_child(r_pathfollows[-1])
	r_instances.append(RobotEnemy.instance())
	r_pathfollows[-1].add_child(r_instances[-1])
	r_pathfollows[-1].rotate = false
	r_instances[-1].spawn(spawn_pos, direction)
