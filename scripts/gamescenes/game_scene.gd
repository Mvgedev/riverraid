extends Node2D

# Container for Levels and Layouts
@onready var scroll_root: Node2D = $"Scroll Root"
@onready var level_factory: Node = $Level_Factory

# UI Control
@onready var bottom_ui: Control = $"CanvasLayer/Bottom UI"
@onready var level_number: Label = $"CanvasLayer/Level Number"
@onready var game_over_ui: Control = $"CanvasLayer/Game Over"
# Animation Player
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fuel_anim: AnimationPlayer = $Fuel_warning
@onready var ammo_warning: AnimationPlayer = $Ammo_warning
# Sounds FX
@onready var no_ammo: AudioStreamPlayer2D = $SFX/no_ammo

# Player 
@onready var player_jet: Player = $"Player Jet"

func _ready() -> void:
	level_factory.game_manager = self
	player_jet.fuel_cons = false # No fuel consumption before first gate
	player_jet.intangible = true
	animation_player.play("Game_Start")
	connect_player() # Connect player's signals to Game Scene for proper GUI update
	ScoreSystem.connect("update_score", update_score)
	ScoreSystem.new_game()
	gui_forced_update()
	level_factory.generate_first_level(scroll_root)
	pass

func _process(delta: float) -> void:
	for child in scroll_root.get_children():
		child.position.y += player_jet.acceleration * delta

# Scroll Management
func _on_level_recycler_area_entered(area: Area2D) -> void:
	print("Level Scrolled")
	# TODO: Add a level count that allow the Game_Scene to know/understand when the game should create the next level
	area.get_parent().queue_free()

func _on_full_level_detection_area_entered(area: Area2D) -> void:
	var has_gate := false
	for child in area.get_parent().borders.get_children():
		if child is Gate:
			has_gate = true
			break
	if has_gate:
		level_factory.call_deferred("generate_next_level", scroll_root)
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


# Signal Management
## Player signals connection
func connect_player():
	player_jet.connect("fuel_update", update_fuel)
	player_jet.connect("ammo_update", update_ammo)
	player_jet.connect("health_update", update_health)
	player_jet.connect("jet_explode", game_over)
	player_jet.connect("no_ammo", out_of_ammo)
	player_jet.connect("fuel_warning", fuel_warning)
## Update GUI
func update_ammo(val):
	var ammo_val = float(val) / float(player_jet.max_ammo) * 100.0
	bottom_ui.ammo_update(ammo_val)
func update_fuel(val):
	bottom_ui.fuel_update(val)
func update_health(val):
	var health_val = float(val) / float(player_jet.max_health) * 100.0
	bottom_ui.health_update(health_val)
func update_score():
	bottom_ui.score_update(ScoreSystem.cur_score)
func gui_forced_update():
	update_health(player_jet.cur_health)
	update_ammo(player_jet.cur_ammo)
	update_fuel(player_jet.cur_fuel)
	update_score()
## Events
func fuel_warning(val):
	if val:
		fuel_anim.play("low_fuel")
	else:
		fuel_anim.stop()
	pass
func out_of_ammo():
	ammo_warning.play("out_of_ammo")
	no_ammo.play()
func next_level():
	if player_jet.fuel_cons == false:
		player_jet.fuel_cons = true
	level_factory.current_level += 1
	level_number.text = "Level: " + str(level_factory.current_level)
	animation_player.play("Next Level")
func game_over():
	ScoreSystem.game_over()
	player_jet.fuel_cons = false
	player_jet.intangible = true
	var reason = GameOverUI.CRASH_REASON.CRASH
	if player_jet.cur_fuel < 1:
		reason = GameOverUI.CRASH_REASON.FUEL
	game_over_ui.set_reason(reason)
	game_over_ui.update_score()
	animation_player.play("Game_Over")
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Game_Start":
		player_jet.intangible = false
