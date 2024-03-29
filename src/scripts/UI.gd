extends Control

onready var scene_root = get_tree().get_current_scene()
onready var player = scene_root.get_node("Player")
onready var round_counter = $"TopBar/RoundCounter"
onready var score_counter = $"TopBar/ScoreCounter"
onready var cash_counter = $"TopBar/Cash"
onready var hp_counter = $HP
onready var enemy_counter = $EnemiesLeft

func _process(delta):
	round_counter.text = "Round " + str(scene_root.current_round)
	score_counter.text = str(scene_root.score)
	cash_counter.text = "$" + str(scene_root.cash)
	hp_counter.text = str(player.hp) + "/" + str(player.hp_modifier) + "HP"
	
	if round_counter.text == "Round 0":
		round_counter.hide()
		$"TopBar/VSeparator".hide()
	else:
		round_counter.show()
		$"TopBar/VSeparator".show()
	
	if scene_root.enemies_left > 0:
		enemy_counter.show()
		enemy_counter.text = "Enemies Left: " + str(scene_root.enemies_left)
	else:
		enemy_counter.hide()
