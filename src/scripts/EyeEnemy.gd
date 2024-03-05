extends Enemy

enum { # direction constants for animation, angle between eye and player
	ANGLE_0, 
	ANGLE_45, 
	ANGLE_60, 
	ANGLE_70, 
	ANGLE_80, 
	ANGLE_90, 
	ANGLE_100, 
	ANGLE_BEHIND
}

func _ready():
	hp = 10 + scene_root.current_round
	speed = 15

func _update_animation(delta):
	var angle_to_player = rad2deg(get_angle_to(player.position))
	var converted_angle = convert_angle(angle_to_player)
	
	if converted_angle != abs(converted_angle):
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
	
	match int(abs(converted_angle)):
		0:
			$Sprite.frame = ANGLE_0
		45:
			$Sprite.frame = ANGLE_45
		60:
			$Sprite.frame = ANGLE_60
		70:
			$Sprite.frame = ANGLE_70
		80:
			$Sprite.frame = ANGLE_80
		90:
			$Sprite.frame = ANGLE_90
		100:
			$Sprite.frame = ANGLE_100
		180:
			$Sprite.frame = ANGLE_BEHIND

func convert_angle(angle):
	angle -= 90
	var angle_magnitude:int = abs(angle)
	if 0 < angle_magnitude and angle_magnitude < 45:
		return round(angle / 45) * 45
	elif 45 < angle_magnitude and angle_magnitude < 60:
		return round(angle / 15) * 15
	elif 60 < angle_magnitude and angle_magnitude < 100:
		return round(angle / 10) * 10
	else:
		return 180
