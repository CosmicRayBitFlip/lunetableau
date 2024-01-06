extends KinematicBody2D

const speed = 100
# direction constants
const UP = Vector2(0,-1)
const RIGHT = Vector2(-1, 0)
const DOWN = Vector2(0, 1)
const LEFT = Vector2(1, 0)
const NULL_DIR = Vector2.ZERO

var input_vector:Vector2 = Vector2.ZERO
var velocity:Vector2 = Vector2.ZERO

func _ready():
	pass

func _input(event):
	if event is InputEventKey:
		input_vector.x = Input.get_axis("left", "right")
		input_vector.y = Input.get_axis("up", "down")

func _process(delta):
	update_animation(input_vector)
	velocity = process_movement(Vector2(input_vector.x, input_vector.y), delta)
	move_and_collide(velocity)

func process_movement(input_vec, delta):
	if input_vec:
		return input_vec * speed * delta
	else:
		return Vector2.ZERO

func update_animation(input_vec): # doesn't really matter if it's buggy right now, it's gonna be changed
	if input_vec:
		match input_vec:
			LEFT: 
				$AnimationPlayer.play("SideWalk") 
				$Sprite.flip_h = true
			RIGHT: 
				$AnimationPlayer.play("SideWalk")
				$Sprite.flip_h = false
			UP:
				$AnimationPlayer.play("BackWalk")
				$Sprite.flip_h = false
			DOWN:
				$AnimationPlayer.play("FrontWalk")
				$Sprite.flip_h = false
	else:
		match $AnimationPlayer.assigned_animation:
			"SideWalk":
				$AnimationPlayer.play("SideIdle")
			"FrontWalk":
				$AnimationPlayer.play("FrontIdle")
			"BackWalk":
				$AnimationPlayer.play("BackIdle")
