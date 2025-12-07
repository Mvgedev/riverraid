extends Control

@onready var progress_bar: ProgressBar = $ProgressBar


func fuel_update(value):
	progress_bar.value = value
