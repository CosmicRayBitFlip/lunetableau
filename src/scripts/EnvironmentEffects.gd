extends WorldEnvironment

enum {
	FADE_IN,
	FADE_OUT
}

var effects_lock:bool = false
var blurred:bool = false

func blur(fade_in_or_out:int, time:float):
	if not effects_lock:
		blurred = not fade_in_or_out
		effects_lock = true
		var sigma = 0.0
		var desired_value
		
		match fade_in_or_out:
			FADE_IN:
				desired_value = 0.1
			FADE_OUT:
				desired_value = 0.0
		
		while sigma < time:
			var delta = get_process_delta_time()
			environment.dof_blur_near_amount = desired_value * (sigma / time)
			sigma += delta
		
		effects_lock = false
