extends Node2D

@onready var player_jet: CharacterBody2D = $"Player Jet"

@onready var bottom_ui: Control = $"CanvasLayer/Bottom UI"

@onready var levels: Node = $Levels

const SAMPLE_1 = preload("res://scenes/entities/levels/sample_level.tscn")
const SAMPLE_2 = preload("res://scenes/entities/levels/sample_level_2.tscn")
const SAMPLE_3 = preload("res://scenes/entities/levels/sample_level_3.tscn")


func _ready() -> void:
	player_jet.connect("fuel_update", update_fuel)
	update_fuel(player_jet.cur_fuel)
	generate_next_chunk(0)
	# TMP to set 1st chunk post to above UI
	levels.get_child(0).position.y = -110
	levels.get_child(0).define_y(-110)
	generate_next_chunk()
	generate_next_chunk()
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	for child in levels.get_children():
		var speed = player_jet.acceleration * delta
		child.position.y += player_jet.acceleration * delta
		child.scroll_level(speed)


func generate_next_chunk(val := -1):
	var id = 0
	if val >= 0 and val <= 2:
		id = val
	else:
		id = randi_range(0, 2)
	var chunk: Level
	if id == 0:
		chunk = SAMPLE_1.instantiate()
	elif id == 1:
		chunk = SAMPLE_2.instantiate()
	else:
		chunk = SAMPLE_3.instantiate()
	if levels.get_child_count() > 0:
		var posy = levels.get_child(levels.get_child_count() - 1).position.y - 576
		chunk.position.y = posy
	levels.add_child(chunk)
	populate_next_chunk(chunk)
	

func populate_next_chunk(chunk: Level):
	var max_count = 2
	var current = 0
	while current < max_count:
		if chunk.enemy_spawns.get_child_count() < 1:
			current = max_count 
		else:
			var enemies_copy = chunk.enemy_spawns.get_children().duplicate()
			for enemy in enemies_copy:
				var rand = randi_range(0,1) as bool
				enemy.enable(rand)
				current += rand as int
	

func update_fuel(val):
	bottom_ui.fuel_update(val)

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
