extends Node

var cur_score = 0
var high_score = 0

enum SCORE_VAL {GATE, BOAT, HELICOPTER, JETFIGHTER, AMMO, FUEL}
const SCORE_AMOUNT = [500, 100, 150, 200, 250, 300]
signal update_score()

func _ready() -> void:
	pass

func save_score():
	pass

func load_score():
	pass

func gain_score(val):
	cur_score += SCORE_AMOUNT[val]
	emit_signal("update_score")
