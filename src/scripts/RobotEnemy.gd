extends Enemy

onready var path_follow:PathFollow2D = get_parent()
onready var path:Path2D              = path_follow.get_parent()
onready var path_curve:Curve2D       = path.curve

func spawn(spawn_pos:Vector2):
	if get_node_or_null('Hitbox'):
		$Hitbox.connect("body_entered", $".", "_on_collision_with_laser")
	var closest_path_offset = path_curve.get_closest_offset(path.to_local(to_global(position)))
	path_follow.offset = closest_path_offset
	position = get_parent().to_local(spawn_pos)
	hp       = 10 + scene_root.current_round - 1
	speed    = 50
	spawned  = true
	

func _think_movement(delta):
	if position != Vector2.ZERO:
		position = position.move_toward(Vector2.ZERO, speed * delta)
	else:
		path_follow.offset += speed * delta * (scene_root.current_round / 10 + 1)

func _update_animation(delta):
	var dummy = PathFollow2D.new()
	dummy.offset = path_follow.offset + speed * delta * (scene_root.current_round / 10 + 1)
	path.add_child(dummy)
	
	var dir_to_next_movement = dummy.position - path_follow.position
	if dir_to_next_movement.x < dir_to_next_movement.y:
		if dir_to_next_movement.x < 0:
			$AnimationPlayer.play("LeftWalk")
		else:
			$AnimationPlayer.play("RightWalk")
	else:
		if dir_to_next_movement.y < 0:
			$AnimationPlayer.play("FrontWalk")
		else:
			$AnimationPlayer.play("BackWalk")

func _think_shoot(): # refactor this later
	if time_since_last_shoot > shoot_fatigue and player.hp > 0:
		var angle_to_player = rad2deg(get_angle_to(player.position))
		var lasers = []

		lasers.append(
			Laser.new(
				path_follow.position + position + Vector2(15, 0).rotated(deg2rad(angle_to_player)), 
				angle_to_player, 
				Color(1,1,1,1), 
				2, 
				0b1, 
				300
			)
		)
		for i in lasers:
			scene_root.add_child(i)
		time_since_last_shoot = 0
