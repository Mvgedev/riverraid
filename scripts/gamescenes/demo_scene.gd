extends Node2D

@onready var player_jet: CharacterBody2D = $"Player Jet"

@onready var levels: Node = $Levels

const SAMPLE_1 = preload("res://scenes/entities/levels/sample_level.tscn")
const SAMPLE_2 = preload("res://scenes/entities/levels/sample_level_2.tscn")
const SAMPLE_3 = preload("res://scenes/entities/levels/sample_level_3.tscn")


func _ready() -> void:
	generate_next_chunk()
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


func generate_next_chunk():
	var random = randi_range(0, 2)
	var chunk: Level
	if random == 0:
		chunk = SAMPLE_1.instantiate()
	elif random == 1:
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
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	print("Level scrolled")
	area.get_parent().queue_free()
	call_deferred("generate_next_chunk")


func _on_bullet_limit_body_entered(body: Node2D) -> void:
	if body is Bullet:
		body.queue_free()
		print("Bullet reached end")
