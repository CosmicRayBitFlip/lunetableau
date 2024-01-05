extends Label

func _init():
	if not OS.is_debug_build():
		queue_free()
func _process(delta):
	text = str(Engine.get_frames_per_second())
