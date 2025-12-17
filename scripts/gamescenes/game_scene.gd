extends Node2D

# Container for Levels and Layouts
@onready var scroll_root: Node2D = $"Scroll Root"
@onready var level_factory: Node = $Level_Factory

# UI Control
@onready var bottom_ui: Control = $"CanvasLayer/Bottom UI"
# Animation Player
@onready var animation_player: AnimationPlayer = $AnimationPlayer
# Player 
@onready var player_jet: Player = $"Player Jet"

# Scroll Management
func _on_level_recycler_area_entered(area: Area2D) -> void:
	print("Level Scrolled")
	# TODO: Add a level count that allow the Game_Scene to know/understand when the game should create the next level
	area.get_parent().queue_free()

func _on_full_level_detection_area_entered(area: Area2D) -> void:
	area.get_parent().launch_jet()

# Bullet Limit
func _on_bullet_limit_body_entered(body: Node2D) -> void:
	if body is Bullet:
		body.queue_free()
		print("Bullet reach end screen")

# Jet Exit
func _on_left_jet_exit_body_entered(body: Node2D) -> void:
	body.get_parent().queue_free()
func _on_right_jet_exit_body_entered(body: Node2D) -> void:
	body.get_parent().queue_free()
