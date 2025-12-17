extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_settings_button_pressed() -> void:
	animation_player.play("To_Settings")

# Settings Page

func _on_back_button_pressed() -> void:
	animation_player.play_backwards("To_Settings")


func _on_story_button_pressed() -> void:
	pass # Replace with function body.
