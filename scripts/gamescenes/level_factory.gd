extends Node

# Manager
var game_manager: Node2D

# Layouts preload
const GATE_LEVEL = preload("res://scenes/levels/layouts/gate_level.tscn")
const LAYOUT_1 = preload("res://scenes/levels/layouts/layout_1.tscn")
const LAYOUT_2 = preload("res://scenes/levels/layouts/layout_2.tscn")
const LAYOUT_3 = preload("res://scenes/levels/layouts/layout_3.tscn")
const LAYOUT_4 = preload("res://scenes/levels/layouts/layout_4.tscn")
const LAYOUT_5 = preload("res://scenes/levels/layouts/layout_5.tscn")
const LAYOUT_6 = preload("res://scenes/levels/layouts/layout_6.tscn")
# Array of Layouts
const LAYOUTS = [LAYOUT_1, LAYOUT_2, LAYOUT_3, LAYOUT_4, LAYOUT_5, LAYOUT_6]
const LAYOUT_SIZE = 607
const BASE_OFFSET = -180
# Current Level: 0 as the level 0 will spawn the introduction
var current_level = 0
const end_level = 8
# Base level size, increased with number of level completed
const level_size = 4
# Const for maximum number of each spawn location for a LEVEL (multiple layouts)
const max_enemy = 6 # 6 Enemy Spawns per Layout
const max_fuel = 6 # 2 Fuel Spawns per Layout
const max_ammo = 7 # 3 Ammo Spawns per Layout
# Guideline is to reduce fuel/ammo by 1 each level, until there is only 1 possible fuel and ammo per current level (so for level 6, there are 6 minimum)
# For enemies, we want to raise the amount by 1 each level, until we simply reach the critical mass of enemy per layout

func generate_next_level(handler):
	# Proper max elements and size
	var l_size = level_size + current_level
	var m_enemy = max_enemy + current_level
	var m_fuel = max(current_level, max_fuel - current_level)
	var m_ammo = max(current_level, max_ammo - current_level)
	# Slots for each layout
	var level_enemies := distribute(m_enemy, l_size, 6, 1)
	print("Number of Enemies for whole level: " + str(level_enemies))
	var level_fuel := distribute(m_fuel, l_size, 2)
	print("Number of fuel: " + str(level_fuel))
	var level_ammo := distribute(m_ammo, l_size, 3)
	print("Number of ammo: " + str(level_ammo))
	# Generate Level in this loop
	for c in range(l_size):
		var n_layout = instantiate_layout(define_layout())
		if handler.get_child_count() > 0:
			var posy = handler.get_child(handler.get_child_count() - 1).position.y - LAYOUT_SIZE
			n_layout.position.y = posy
		else:
			n_layout.position.y = BASE_OFFSET
		handler.add_child(n_layout)
		generate_next_layout(n_layout,level_enemies[c],level_fuel[c],level_ammo[c])
	# Append Gate Layout
	var gate_layout = instantiate_layout(GATE_LEVEL)
	var g_posy = handler.get_child(handler.get_child_count() - 1).position.y - LAYOUT_SIZE
	gate_layout.position.y = g_posy
	handler.add_child(gate_layout)
	connect_gate(gate_layout)

# Dedicated function to generate the first level of either endless or story mode
func generate_first_level(handler, story := false):
	if story:
		pass
	else:
		var gate_layout = instantiate_layout(GATE_LEVEL)
		var g_posy = BASE_OFFSET
		gate_layout.position.y = g_posy
		handler.add_child(gate_layout)
		connect_gate(gate_layout)

func generate_story_intro(handler):
	# Generate few LAYOUT_6 to cover the whole intro sequence
	pass

func define_layout(gate := false) -> Resource:
	var ret = null
	if gate == true:
		ret = GATE_LEVEL
	else:
		ret = LAYOUTS[randi_range(0, LAYOUTS.size() - 1)]
	return ret

func instantiate_layout(layout) -> Level:
	var ret = layout.instantiate()
	return ret

func generate_next_layout(layout, layout_enemies, layout_fuel, layout_ammo):
	clean_spawns(layout.enemy_spawns.get_children(), layout_enemies)
	clean_spawns(layout.fuel_spawns.get_children(), layout_fuel)
	clean_spawns(layout.supply_spawns.get_children(), layout_ammo)

func distribute(total: int, parts: int, cap: int, min_part := 0) -> Array:
	var result := []
	# Add min_part if any to each element
	for i in parts:
		result.append(min_part)
	# Calculate the remaining total
	var remaining := total - parts * min_part
	# While loop to distribute remaining to each part while not overcapping
	# If all part are capped, remaining will be lost as we break from the while()
	while remaining > 0:
		var valid := []
		for i in parts:
			if result[i] < cap:
				valid.append(i)
		if valid.is_empty():
			break
		var idx : int = valid[randi() % valid.size()]
		result[idx] += 1
		remaining -= 1
	return result

func clean_spawns(to_clean, quota):
	for i in to_clean.size():
		if i < quota:
			continue
		to_clean[i].queue_free()

func connect_gate(gate_layout):
	for child in gate_layout.borders.get_children():
			if child is Gate:
				child.connect("next_level", game_manager.next_level)
				break
