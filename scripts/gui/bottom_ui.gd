extends Control

# Resources
@onready var fuel_gauge: TextureProgressBar = $"Control/Mid Box/Fuel/Fuel Gauge"
@onready var ammo_gauge: TextureProgressBar = $Control/Ammo_gauge
@onready var health_bar: TextureProgressBar = $"Control/Mid Box/Structure/Health_bar"

# Score
@onready var score_label: Label = $Control/Score/ScoreLabel


func fuel_update(value):
	fuel_gauge.value = value

func ammo_update(value):
	ammo_gauge.value = value

func health_update(value):
	health_bar.value = value

func score_update(value):
	score_label.text = format_number(value)

func format_number(n: int) -> String:
	if n >= 1_000_000:
		return str(round(n / 1_000_0.0) / 100.0) + "M"  # ex: 1 530 000 → 1.53M
	elif n >= 1_000:
		return str(round(n / 10.0) / 100.0) + "K"       # ex: 153 000 → 153K
	else:
		return str(n)
