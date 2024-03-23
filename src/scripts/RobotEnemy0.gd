# this is an unused script left over from a different attempt at programming enemy ai
extends Enemy

var arrows

func spawn(robot_team:int, arrow_dict:Dictionary, spawn_poses:Array, direction:Vector2 = Vector2.DOWN):
	team = robot_team
	speed = 1
	dir = direction
	hp = 10
	arrows = arrow_dict
	position = spawn_poses[rand_range(0, spawn_poses.size() - 1)]
	print(position)

func _process(delta):
	think_movement()

func think_movement():
	var current_tile_coord = (position / 32).floor()
	move_and_collide(dir * speed)
	
	if current_tile_coord in arrows:
		match arrows[current_tile_coord]:
			"Up":
				dir = Vector2.UP
			"Left":
				dir = Vector2.LEFT
			"Down":
				dir = Vector2.DOWN
			"Right":
				dir = Vector2.RIGHT
