extends KinematicBody2D

class_name Laser

var sigma:float

var width = 5
var length = 10
var direction = Vector2.UP
var color:Color

var speed       = 2000
var pierce      = 2
var expire_time = 2.0
var bodies_already_collided_with = []

func _init(
	pos:Vector2, 
	dir:float, 
	laser_color = Color(1, 1, 1, 1), 
	laser_pierce:int = 2, 
	coll_layer:int = 0b10,
	spd:int = 2000
):
	rotation_degrees = dir - 90
	direction = dir
	position = pos
	color = laser_color
	pierce = laser_pierce
	collision_layer = coll_layer
	collision_mask = 0
	speed = spd

func _ready():
	var laser_line:Line2D    = Line2D.new()
	laser_line.default_color = color
	laser_line.width         = width
	laser_line.add_point(Vector2(0,-length)); laser_line.add_point(Vector2(0, length))
	add_child(laser_line)
	
	var collision_box           = CollisionShape2D.new()
	collision_box.shape         = RectangleShape2D.new()
	collision_box.shape.extents = Vector2(width / 2, length / 2)
	add_child(collision_box)

func _process(delta):
	sigma += delta
	var collision = move_and_collide(ExtraMath.angle_to_vector(direction, true) * speed * delta)
	if pierce == 0 or sigma > expire_time:
		queue_free()

func hasnt_collided_with(body:Object): 
	if not body in bodies_already_collided_with:
		bodies_already_collided_with.append(body)
		pierce -= 1
		return true
	return false
