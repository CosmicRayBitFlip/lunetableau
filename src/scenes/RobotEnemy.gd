extends Enemy

func spawn(robot_team:int, spawn_pos:Vector2, direction:Vector2 = Vector2.DOWN):
	team = robot_team
	position = spawn_pos
	dir = direction
	hp = 10
	speed = 1

func _process(delta):
	think_movement()

func think_movement():
	pass
