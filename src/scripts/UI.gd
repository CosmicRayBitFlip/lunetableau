extends Control

onready var scene_root = get_parent()
onready var round_counter = $"TopBar/RoundCounter"
onready var score_counter = $"TopBar/ScoreCounter"
onready var cash_counter = $"TopBar/Cash"

func _process(delta):
	round_counter.text = "Round " + str(scene_root.current_round)
	score_counter.text = str(scene_root.score)
	cash_counter.text = "$" + str(scene_root.cash)
	
	if round_counter.text == "Round 0":
		round_counter.hide()
		$"TopBar/VSeparator".hide()
	else:
		round_counter.show()
		$"TopBar/VSeparator".show()
