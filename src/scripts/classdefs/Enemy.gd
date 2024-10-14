extends KinematicBody2D

class_name Enemy

onready var scene_root             = get_tree().get_current_scene()
onready var player:KinematicBody2D = scene_root.get_node("Player")

var hp:int
var speed:float
var spawned:bool = false

enum {WHITE, RED, BLUE, YELLOW} # teams

var shoot_fatigue               = 2.0
var time_since_last_shoot:float = shoot_fatigue

func spawn(spawn_pos:Vector2):
	if get_node_or_null('Hitbox'):
		$Hitbox.connect("body_entered", $".", "_on_collision_with_laser")
	position = spawn_pos
	spawned = true

func _process(delta):
	if spawned:
		time_since_last_shoot += delta
		_think_movement(delta)
		_update_animation(delta)
		_think_shoot()

func _think_movement(delta):
	position = position.move_toward(player.position, speed * delta)

func _update_animation(delta):
	pass

func _think_shoot():
	if time_since_last_shoot > shoot_fatigue and player.hp > 0:
		var angle_to_player = rad2deg(get_angle_to(player.position))
		var lasers = []

		lasers.append(
			Laser.new(
				position + Vector2(15, 0).rotated(deg2rad(angle_to_player)), 
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

func damage(damage_amt):
	hp -= damage_amt
	if hp <= 0:
		hp = 1 << 63
		scene_root.score        += 50 + scene_root.current_round - 1
		scene_root.cash         += 10
		scene_root.enemies_left -= 1
		queue_free()

func _on_collision_with_laser(body):
	if body is Laser:
		if body.hasnt_collided_with($'.'):
			damage(5 + player.damage_modifier)

func create_laser():
	pass
 
