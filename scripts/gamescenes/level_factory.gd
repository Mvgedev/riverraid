extends Node

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
# Current Level: 0 as the level 0 will spawn the introduction
var current_level = 0
const end_level = 8
# Base level size, increased with number of level completed
const level_size = 4
# Const for maximum number of each spawn location for a LEVEL (multiple layouts)
const max_enemy = 4
const max_fuel = 5
const max_ammo = 6
# Guideline is to reduce fuel/ammo by 1 each level, until there is only 1 possible fuel and ammo per level
# For enemies, we want to raise the amount by 1 each level, until we simply reach the critical mass of enemy per layout

func generate_next_level() -> Node:
	# Proper max elements and size
	var l_size = level_size + current_level
	var m_enemy = max_enemy + current_level
	var m_fuel = max_fuel + current_level
	var m_ammo = max_ammo + current_level
	# Slots for each layout
	var level_enemies = []
	var level_fuel = []
	var level_ammo = []
	# Generate for each layout
	# Generate Level in this loop + Gate_Level
	for c in range(l_size):
		pass
		
	# Need to calculate enemies/fuel/ammo number per level
	# Then dispatch it within layouts
	# Then generate each layout with appropriate number of enemies/fuel/ammo
	return null # Must replace with a Node that contains all the levels

func define_layout(gate := false) -> Resource:
	var ret = null
	if gate == true:
		ret = GATE_LEVEL
	else:
		ret = LAYOUTS[randi_range(0, LAYOUTS.size() - 1)]
	return ret

func instantiate_layout(layout) -> Node2D:
	var ret = layout.instantiate()
	return ret

func generate_next_layout(layout, layout_enemies, layout_fuel, layout_ammo) -> Level:
	var ret = layout
	return ret
