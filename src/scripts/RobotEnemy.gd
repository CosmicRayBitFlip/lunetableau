extends Enemy

onready var path_follow:PathFollow2D = get_parent()
onready var path:Path2D              = path_follow.get_parent()
onready var path_curve:Curve2D       = path.curve

var spawn_idx:int

func _convert_spawn_idx_to_vertex_idx(idx):
	return 4 - idx - 1

func spawn(spawn_pos:Vector2):
	if get_node_or_null('Hitbox'):
		$Hitbox.connect("body_entered", $".", "_on_collision_with_laser")
	var converted_idx = _convert_spawn_idx_to_vertex_idx(spawn_idx)
	var closest_path_offset = path_curve.get_closest_offset(path_curve.interpolate(converted_idx, 0.5))
	
	path_follow.offset = closest_path_offset
	global_position = spawn_pos
	hp       = 10 + scene_root.current_round - 1
	speed    = 50 * (scene_root.current_round / 10 + 1)
	spawned  = true
	

func _think_movement(delta):
	if position != Vector2.ZERO:
		position = position.move_toward(Vector2.ZERO, speed * delta)
	else:
		path_follow.offset += speed * delta

func _update_animation(delta):
	var dir_to_next_movement = global_position.direction_to(player.global_position)
	if abs(dir_to_next_movement.x) > abs(dir_to_next_movement.y):
		if dir_to_next_movement.x < 0:
			$AnimationPlayer.play("LeftWalk")
		else:
			$AnimationPlayer.play("RightWalk")
	else:
		if dir_to_next_movement.y < 0:
			$AnimationPlayer.play("BackWalk")
		else:
			$AnimationPlayer.play("FrontWalk")

func _think_shoot(): # refactor this later
	if time_since_last_shoot > shoot_fatigue and player.hp > 0:
		var angle_to_player = rad2deg(get_angle_to(player.global_position))
		var lasers = []

		lasers.append(
			Laser.new(
				path_follow.position + position + Vector2(15, 0).rotated(deg2rad(angle_to_player)), 
				angle_to_player, 
				Color(1,1,1,1), 
				2, 
				0b1, 
				750
			)
		)
		for i in lasers:
			scene_root.add_child(i)
		time_since_last_shoot = 0
