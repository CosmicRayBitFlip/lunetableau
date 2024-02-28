extends KinematicBody2D

onready var scene_root = $'..'

const speed = 100
# direction constants
const FRONT = 90.0
const BACK = -90.0
const LEFT = 180.0
const RIGHT = 0.0

const RED_LASER = Color(1, 0.8, 0.8, 1)
const GREEN_LASER = Color(0.8, 1, 0.8, 1)
const BLUE_LASER = Color(0.8, 0.8, 1, 1)
const YELLOW_LASER = Color(1, 1, 0.8, 1)

var hp = 5

var input_vector:Vector2 = Vector2.ZERO
var velocity:Vector2 = Vector2.ZERO
var mouse_pos:Vector2; var angle_to_mouse:float
var glasses_type:int = GLASSES1
enum {GLASSES1, GLASSES2, GLASSES3, GLASSES4}

var attack_modifier = 0
var pierce_modifier = 0
var hp_modifier = 5

func _input(event):
	if event is InputEventKey or event is InputEventMouseButton:
		input_vector.x = Input.get_axis("left", "right")
		input_vector.y = Input.get_axis("up", "down")
		
		if Input.is_action_just_pressed("debug_shoot"):
			if scene_root.enemies_left != 0 and hp > 0:
				shoot()
		if Input.is_action_just_pressed("glasses1"):
			glasses_type = GLASSES1
		if Input.is_action_just_pressed("glasses2"):
			glasses_type = GLASSES2
	if event is InputEventMouseMotion:
		mouse_pos = get_viewport().canvas_transform.affine_inverse().xform(event.position) # beautiful spaghetti right here
	angle_to_mouse = rad2deg(get_angle_to(mouse_pos))

func shoot():
	var lasers = []
	match glasses_type:
		GLASSES1: 
			lasers.append(Laser.new(position, angle_to_mouse, RED_LASER, 2 + pierce_modifier))
			lasers.append(Laser.new(position, angle_to_mouse - 15, RED_LASER, 2 + pierce_modifier))
			lasers.append(Laser.new(position, angle_to_mouse + 15, RED_LASER, 2 + pierce_modifier))
		GLASSES2:
			lasers.append(Laser.new(position, angle_to_mouse, GREEN_LASER, 1))
			lasers.append(Laser.new(position - Vector2(15, 30).rotated(deg2rad(angle_to_mouse)), angle_to_mouse, GREEN_LASER, 1 + pierce_modifier))
			lasers.append(Laser.new(position + Vector2(-15, 30).rotated(deg2rad(angle_to_mouse)), angle_to_mouse, GREEN_LASER, 1 + pierce_modifier))
	for i in lasers:
		scene_root.add_child(i)

func _process(delta):
	if scene_root.enemies_left == 0:
		hp += hp_modifier - hp
	update_animation(round(angle_to_mouse / 90) * 90)
	velocity = process_movement(Vector2(input_vector.x, input_vector.y), delta)
	move_and_collide(velocity)

func process_movement(input_vec, delta):
	if input_vec:
		return input_vec * speed * delta
	else:
		return Vector2.ZERO

func update_animation(rounded_mouse_angle):
	var anim_type:String
	match rounded_mouse_angle:
		RIGHT: 
			anim_type = "Right"
		LEFT, -180.0: # godot doesn't like when i do LEFT, -LEFT so i have to use the actual number i guess
			anim_type = "Left"
		BACK:
			anim_type = "Back"
		FRONT:
			anim_type = "Front"
	if input_vector:
		$AnimationPlayer.play(anim_type + "Walk")
	else:
		$AnimationPlayer.play(anim_type + "Idle")

func damage():
	hp -= 1
	if hp <= 0:
		hide()


func _on_collision_with_laser(body):
	if body is Laser:
		damage()
