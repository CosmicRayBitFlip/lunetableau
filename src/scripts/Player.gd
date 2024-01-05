extends KinematicBody2D

const speed = 100
# direction and animation constats
const PA_NULL = 0
const PA_X = -1
const PA_Y = 1
const UP = -1; const RIGHT = -1
const DOWN = 1; const LEFT = 1

var input_vector:Vector3 = Vector3.ZERO # z component uses one of the primary axis constants above
var velocity:Vector2 = Vector2.ZERO

func _ready():
	pass

func _input(event):
	if event is InputEventKey:
		input_vector.x = Input.get_axis("left", "right")
		input_vector.y = Input.get_axis("up", "down")
		if not input_vector.z:
			input_vector.z = PA_X * abs(input_vector.x) # primary axis is x if left or right is pressed
			input_vector.z += PA_Y * abs(input_vector.y) # primary axis is y if up or down is pressed
		if not Vector2(input_vector.x, input_vector.y):
			input_vector.z = PA_NULL

func _process(delta):
	update_animation(input_vector.x, input_vector.y, input_vector.z)
	velocity = process_movement(Vector2(input_vector.x, input_vector.y), delta)
	move_and_collide(velocity)

func process_movement(input_vec, delta):
	if input_vec:
		return input_vec * speed * delta
	else:
		return Vector2.ZERO

func update_animation(x_dir, y_dir, primary_axis): # finish when animation is completed
	if primary_axis == PA_X or primary_axis == PA_Y:
		if true:
			$AnimationPlayer.play("Walk")
	else:
		$AnimationPlayer.play("Idle")
