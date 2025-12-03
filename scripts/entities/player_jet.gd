extends CharacterBody2D


@onready var left_cannon: Area2D = $"Left Cannon"
@onready var right_cannon: Area2D = $"Right Cannon"

@onready var bullet = preload("res://scenes/entities/bullet.tscn")
@onready var bullets: Node = $Bullets

@onready var cannon_cooldown: Timer = $"Cannon Cooldown"

var cooldown = false
var cd_time = 1.0

const LATERAL_SPEED = 300.0

const accel_modifier = 3
var acceleration = 90
var min_accel = 60
var max_accel = 200

func _physics_process(_delta: float) -> void:
	
	# Shoot
	if Input.is_action_just_pressed("Shoot") and cooldown == false:
		cooldown = true
		shoot()
	# Movement
	if Input.is_action_pressed("Accelerate"):
		acceleration = min(acceleration + accel_modifier, max_accel)
	elif Input.is_action_pressed("Decelerate"):
		acceleration = max(acceleration - accel_modifier, min_accel)
	var direction := Input.get_axis("Move Left", "Move Right")
	if direction:
		velocity.x = direction * LATERAL_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, LATERAL_SPEED)
	move_and_slide()

func shoot():
	var left_missile = bullet.instantiate()
	var right_missile = bullet.instantiate()
	bullets.add_child(left_missile)
	bullets.add_child(right_missile)
	left_missile.global_position = left_cannon.global_position
	right_missile.global_position = right_cannon.global_position
	cannon_cooldown.start(cd_time)
	pass


func _on_cannon_cooldown_timeout() -> void:
	cooldown = false
	print("Can fire again")
