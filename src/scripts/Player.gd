extends KinematicBody2D

const speed = 100
# direction constants
const FRONT = 90.0
const BACK = -90.0
const LEFT = 180.0
const RIGHT = 0.0

var input_vector:Vector2 = Vector2.ZERO
var velocity:Vector2 = Vector2.ZERO
var mouse_pos:Vector2; var angle_to_mouse:float

func _ready():
	pass

func _input(event):
	if event is InputEventKey:
		input_vector.x = Input.get_axis("left", "right")
		input_vector.y = Input.get_axis("up", "down")
	if event is InputEventMouseMotion:
		mouse_pos = event.position - get_viewport_transform().origin # mouse coordinate is apparently based on viewport
	angle_to_mouse = rad2deg(get_angle_to(mouse_pos))

func _process(delta):
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
			anim_type = "Side"
			$Sprite.flip_h = true
		LEFT, -180.0: # godot doesn't like when i do LEFT, -LEFT so i have to use the actual number 
			anim_type = "Side"
			$Sprite.flip_h = false
		BACK:
			anim_type = "Back"
			$Sprite.flip_h = false
		FRONT:
			anim_type = "Front"
			$Sprite.flip_h = false
	if input_vector:
		$AnimationPlayer.play(anim_type + "Walk")
	else:
		$AnimationPlayer.play(anim_type + "Idle")
