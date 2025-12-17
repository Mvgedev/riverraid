extends Node2D

@onready var player_jet: CharacterBody2D = $"Player Jet"

@onready var bottom_ui: Control = $"CanvasLayer/Bottom UI"
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var levels: Node = $Levels
@onready var level_number: Label = $"CanvasLayer/Level Number"
var current_level = 0

const GATE_LEVEL = preload("res://scenes/levels/layouts/gate_level.tscn")
const SAMPLE_1 = preload("res://scenes/levels/layouts/layout_1.tscn")
const SAMPLE_2 = preload("res://scenes/levels/layouts/layout_2.tscn")
const SAMPLE_3 = preload("res://scenes/levels/layouts/layout_3.tscn")
const SAMPLE_4 = preload("res://scenes/levels/layouts/layout_4.tscn")
const SAMPLE_5 = preload("res://scenes/levels/layouts/layout_5.tscn")
const SAMPLE_6 = preload("res://scenes/levels/layouts/layout_6.tscn")
const chunk_size = 607 # Magic number for level size

func _ready() -> void:
	player_jet.connect("fuel_update", update_fuel)
	player_jet.connect("ammo_update", update_ammo)
	player_jet.connect("health_update", update_health)
	player_jet.connect("jet_explode", game_over)
	player_jet.connect("no_ammo", out_of_ammo)
	ScoreSystem.connect("update_score", update_score)
	update_health(player_jet.cur_health)
	update_ammo(player_jet.cur_ammo)
	update_fuel(player_jet.cur_fuel)
	update_score()
	generate_next_chunk(6)
	# TMP to set 1st chunk post to above UI
	levels.get_child(0).position.y = -64
	#levels.get_child(0).define_y(-64)
	generate_next_chunk()
	generate_next_chunk()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for child in levels.get_children():
		#var speed = player_jet.acceleration * delta
		child.position.y += player_jet.acceleration * delta
		#child.scroll_level(speed)


func generate_next_chunk(val := -1):
	var id
	if val >= 0 and val <= 6:
		id = val
	else:
		id = randi_range(0, 5)
	var chunk: Level
	if id == 0:
		chunk = SAMPLE_1.instantiate()
	elif id == 1:
		chunk = SAMPLE_2.instantiate()
	elif id == 2:
		chunk = SAMPLE_3.instantiate()
	elif id == 3:
		chunk = SAMPLE_4.instantiate()
	elif id == 4:
		chunk = SAMPLE_5.instantiate()
	elif id == 5:
		chunk = SAMPLE_6.instantiate()
	elif id == 6:
		chunk = GATE_LEVEL.instantiate()
	if levels.get_child_count() > 0:
		var posy = levels.get_child(levels.get_child_count() - 1).position.y - chunk_size
		chunk.position.y = posy
	levels.add_child(chunk)
	if id == 6:
		for child in chunk.borders.get_children():
			if child is Gate:
				child.connect("next_level", next_level)
	populate_next_chunk(chunk)
	

func populate_next_chunk(chunk: Level):
	var max_enemy = 2 + current_level
	var current = 0
	while current < max_enemy:
		if chunk.enemy_spawns.get_child_count() < 1:
			current = max_enemy 
		else:
			var enemies_copy = chunk.enemy_spawns.get_children().duplicate()
			for enemy in enemies_copy:
				var rand = randi_range(0,1) as bool
				enemy.enable(rand)
				current += rand as int
	

func update_score():
	bottom_ui.score_update(ScoreSystem.cur_score)

func update_fuel(val):
	bottom_ui.fuel_update(val)

func update_health(val):
	var health_val = float(val) / float(player_jet.max_health) * 100.0
	bottom_ui.health_update(health_val)

func game_over():
	print("Game over")
	pass

func next_level():
	current_level += 1
	level_number.text = "Level: " + str(current_level)
	animation_player.play("Next Level")

func update_ammo(val):
	print("Cur ammo: ", val)
	var ammo_val = float(val) / float(player_jet.max_ammo) * 100.0
	print("Value: ", ammo_val)
	bottom_ui.ammo_update(ammo_val)

func out_of_ammo():
	animation_player.play("out_of_ammo")

func _on_area_2d_area_entered(area: Area2D) -> void:
	print("Level scrolled")
	area.get_parent().queue_free()
	call_deferred("generate_next_chunk")

func _on_bullet_limit_body_entered(body: Node2D) -> void:
	if body is Bullet:
		body.queue_free()
		print("Bullet reached end")


func _on_left_jet_exit_body_entered(body: Node2D) -> void:
	print("Left exit")
	body.get_parent().queue_free()


func _on_right_jet_exit_body_entered(body: Node2D) -> void:
	print("Right exit")
	body.get_parent().queue_free()


func _on_full_level_detection_area_entered(area: Area2D) -> void:
	print("Should launch")
	area.get_parent().launch_jet()
