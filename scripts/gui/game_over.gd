extends Control
class_name GameOverUI
# Label to edit
@onready var reason: Label = $TextureRect/Control/VBoxContainer/Reason
@onready var score_val: Label = $TextureRect/Control/VBoxContainer/Score_Val
@onready var hs_val: Label = $TextureRect/Control/VBoxContainer/HS_Val

enum CRASH_REASON {CRASH, FUEL}

func set_reason(val : CRASH_REASON = CRASH_REASON.CRASH):
	match val:
		CRASH_REASON.CRASH:
			reason.text = "You crashed"
		CRASH_REASON.FUEL:
			reason.text = "You ran out of fuel"

func update_score():
	score_val.text = str(ScoreSystem.cur_score)
	hs_val.text = str(ScoreSystem.high_score)

# Buttons signals
func _on_play_again_pressed() -> void:
	get_tree().reload_current_scene()

func _on_back_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/gamescenes/main_menu.tscn")
