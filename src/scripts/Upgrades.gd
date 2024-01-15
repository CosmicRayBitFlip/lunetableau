extends Control

onready var scene_root = get_parent()
onready var player = scene_root.get_node("Player")

func _process(delta):
	if scene_root.enemies_left == 0:
		show()
	else:
		hide()


func _on_DamageUpgrade_button_down():
	if scene_root.cash <= 10:
		player.damage_modifier += 1
		scene_root.cash -= 10

func _on_PierceUpgrade_button_down():
	if scene_root.cash <= 10:
		player.pierce_modifier += 1
		scene_root.cash -= 10

func _on_HPUpgrade_button_down():
	if scene_root.cash <= 10:
		player.hp_modifier += 1
		scene_root.cash -= 10
