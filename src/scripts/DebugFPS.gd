extends Label

onready var scene_root = $"../.."

func _process(delta):
	text = str(Engine.get_frames_per_second())
 
