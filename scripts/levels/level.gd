extends Node2D

class_name Level

@onready var borders: Node2D = $Borders

@onready var enemy_spawns: Node2D = $EnemySpawns
@onready var fuel_spawns: Node2D = $FuelSpawns
@onready var supply_spawns: Node2D = $SupplySpawns

func _ready() -> void:
	#define_y(position.y)
	pass

func launch_jet():
	for child in enemy_spawns.get_children():
		if child is JetFighter:
			child.launch_jet(true)

func define_y(pos):
	if borders != null:
		for child in borders.get_children():
			child.position.y = pos
	if enemy_spawns != null:
		for child in enemy_spawns.get_children():
			child.position.y = child.global_position.y + pos
	if fuel_spawns != null:
		for child in fuel_spawns.get_children():
			child.position.y = child.global_position.y + pos
	if supply_spawns != null:
		for child in supply_spawns.get_children():
			child.position.y = child.global_position.y + pos

func scroll_level(distance):
	for child in borders.get_children():
		child.position.y += distance
	for child in enemy_spawns.get_children():
		child.position.y += distance
	for child in fuel_spawns.get_children():
		child.position.y += distance
	for child in supply_spawns.get_children():
		child.position.y += distance
