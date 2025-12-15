extends Node

# Current Level: 0 as the level 0 will spawn the introduction
var current_level = 0

# Const for maximum number of each spawn location for a LEVEL (multiple layouts)
const max_enemy = 4
const max_fuel = 5
const max_ammo = 6
# Guideline is to reduce fuel/ammo by 1 each level, until there is only 1 possible fuel and ammo per level
# For enemies, we want to raise the amount by 1 each level, until we simply reach the critical mass of enemy per layout
