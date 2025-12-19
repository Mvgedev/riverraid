extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var animating = false
#Settings Sliders
@onready var bgm_slider: HSlider = $"CanvasLayer/Control/Settings/Music/BGM Slider"
@onready var sfx_slider: HSlider = $"CanvasLayer/Control/Settings/SFX/SFX Slider"

const GAME_SCENE := preload("res://scenes/gamescenes/game_scene.tscn")



func _ready() -> void:
	bgm_slider.value = BgmPlayer.bgm_volume
	sfx_slider.value = BgmPlayer.sfx_volume
	pass

func _on_settings_button_pressed() -> void:
	if animating == false:
		animating = true
		animation_player.play("To_Settings")
func _on_endless_button_pressed() -> void:
	if animating == false:
		animating = true
		animation_player.play("To_Game_Screen")
func _on_advices_button_pressed() -> void:
	if animating == false:
		animating = true
		animation_player.play("To Tips")
# Settings Page
func _on_back_button_pressed() -> void:
	if animating == false:
		animating = true
		animation_player.play_backwards("To_Settings")

# Tips popup
func _on_back_tips_pressed() -> void:
	if animating == false:
		animating = true
		animation_player.play_backwards("To Tips")

# Events
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animating = false
	if anim_name == "To_Game_Screen":
		get_tree().change_scene_to_packed(GAME_SCENE)

func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		BgmPlayer.update_sfx_vol(sfx_slider.value)

func _on_bgm_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		BgmPlayer.update_bgm_vol(bgm_slider.value)
