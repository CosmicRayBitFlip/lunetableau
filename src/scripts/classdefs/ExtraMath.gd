extends Object

class_name ExtraMath

static func angle_to_vector(angle:float, is_degrees:bool = false) -> Vector2:
	var result = Vector2.ZERO
	
	if is_degrees:
		angle = deg2rad(angle)
		
	result.x = cos(angle)
	result.y = sin(angle)
	
	return result
