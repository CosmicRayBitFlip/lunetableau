extends Enemy

onready var path_follow:PathFollow2D = get_parent()
onready var path:Curve2D = path_follow.get_parent().curve

func spawn(spawn_pos:Vector2, dir:Vector2 = Vector2.DOWN):
	if get_node_or_null('Hitbox'):
		$Hitbox.connect("body_entered", $".", "_on_collision_with_laser")
	position = get_parent().to_local(spawn_pos)
	direction = dir
	hp = 10 + scene_root.current_round - 1
	speed = 50
	spawned = true
	
	var closest_point =	path.get_closest_point(position.move_toward(direction, 1))

func _think_movement(delta):
	if position != Vector2.ZERO:
		position = position.move_toward(Vector2.ZERO, speed * delta)
	else:
		path_follow.offset += speed * delta * (scene_root.current_round / 10 + 1)
