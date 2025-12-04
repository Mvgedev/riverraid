extends Node2D

class_name Level

@onready var borders: Node = $Borders

@onready var enemy_spawns: Node = $EnemySpawns
@onready var fuel_spawns: Node = $FuelSpawns
@onready var supply_spawns: Node = $SupplySpawns


func _ready() -> void:
	define_y(position.y)
	


func define_y(pos):
	if borders != null:
		for child in borders.get_children():
			child.position.y = pos
	if enemy_spawns != null:
		for child in enemy_spawns.get_children():
			child.position.y = child.global_position.y + pos

func scroll_level(distance):
	for child in borders.get_children():
		child.position.y += distance
	for child in enemy_spawns.get_children():
		child.position.y += distance
