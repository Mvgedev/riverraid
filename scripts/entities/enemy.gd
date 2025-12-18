extends Node2D
class_name Enemy

@export var score_value : ScoreSystem.SCORE_VAL

func _ready() -> void:
	pass

func enable(val):
	if val == true:
		pass
	else:
		queue_free()
