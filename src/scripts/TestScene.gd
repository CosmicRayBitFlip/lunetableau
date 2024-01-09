extends Node2D

var RobotEnemy = preload("res://src/scenes/RobotEnemy.tscn")

func _input(event):
	if event is InputEventScreenTouch: pass

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
