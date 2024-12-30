extends WorldEnvironment

const blur_amt:float = 0.1

func anim_property(property:NodePath, fade_in:bool, time:float, begin_val, end_val):
	$Tween.interpolate_property(
		environment, 
		property, 
		begin_val if fade_in else end_val, 
		end_val if fade_in else begin_val,
		time,
		Tween.TRANS_QUAD,
		Tween.EASE_OUT
	)
	$Tween.start()

func blur(fade_in:bool, time:float):
	anim_property(
		"dof_blur_near_amount", 
		fade_in,
		time,
		0.0, 
		0.1
	)
