extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const GAME_SCENE := preload("res://scenes/gamescenes/game_scene.tscn")

func _on_settings_button_pressed() -> void:
	animation_player.play("To_Settings")

# Settings Page

func _on_back_button_pressed() -> void:
	animation_player.play_backwards("To_Settings")


func _on_story_button_pressed() -> void:
	pass # Replace with function body.


func _on_endless_button_pressed() -> void:
	animation_player.play("To_Game_Screen")
	pass # Replace with function body.


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "To_Game_Screen":
		get_tree().change_scene_to_packed(GAME_SCENE)
