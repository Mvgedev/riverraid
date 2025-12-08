extends Node

var cur_score = 0
var high_score = 0

signal update_score()

func _ready() -> void:
	pass

func save_score():
	pass

func load_score():
	pass

func gain_score(val):
	cur_score += val
	emit_signal("update_score")
