extends Control

# why is this code separate from the rest of the ui code

onready var scene_root = get_tree().get_current_scene()
onready var player = scene_root.get_node("Player")
onready var damage_level = $UpgradesList/Damage/Level
onready var pierce_level = $UpgradesList/Pierce/Level
onready var hp_level = $UpgradesList/HP/Level
onready var damage_price_ui = $UpgradesList/Damage/Price
onready var pierce_price_ui = $UpgradesList/Pierce/Price
onready var hp_price_ui = $UpgradesList/HP/Price

class UpgradeCount:
	enum {DAMAGE, PIERCE, HP}
var upgrade_count = [0, 0, 0]

func _process(delta):
	if scene_root.enemies_left == 0:
		show()
	else:
		hide()
	
	damage_level.text    = "Lv. " + str(player.attack_modifier)
	pierce_level.text    = "Lv. " + str(player.pierce_modifier)
	hp_level.text        = "Lv. " + str(player.hp_modifier -5)
	
	damage_price_ui.text = "$" + str(10 * (upgrade_count[UpgradeCount.DAMAGE] + 1))
	pierce_price_ui.text = "$" + str(10 * (upgrade_count[UpgradeCount.PIERCE] + 1))
	hp_price_ui.text     = "$" + str(10 * (upgrade_count[UpgradeCount.HP] + 1))

func _on_DamageUpgrade_button_down():
	if scene_root.cash >= 10 * (upgrade_count[UpgradeCount.DAMAGE] + 1):
		player.attack_modifier += 1
		scene_root.cash -= 10 * (upgrade_count[UpgradeCount.DAMAGE] + 1)
		upgrade_count[UpgradeCount.DAMAGE] += 1

func _on_PierceUpgrade_button_down():
	if scene_root.cash >= 10 * (upgrade_count[UpgradeCount.PIERCE] + 1):
		player.pierce_modifier += 1
		scene_root.cash -= 10 * (upgrade_count[UpgradeCount.PIERCE] + 1)
		upgrade_count[UpgradeCount.PIERCE] += 1

func _on_HPUpgrade_button_down():
	if scene_root.cash >= 10 * (upgrade_count[UpgradeCount.HP] + 1):
		player.hp_modifier += 1
		scene_root.cash -= 10 * (upgrade_count[UpgradeCount.HP] + 1)
		upgrade_count[UpgradeCount.HP] += 1
