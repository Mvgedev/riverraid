extends CharacterBody2D
class_name Player

@onready var left_cannon: Area2D = $"Left Cannon"
@onready var right_cannon: Area2D = $"Right Cannon"

@onready var bullet = preload("res://scenes/entities/bullet.tscn")
@onready var bullets: Node = $Bullets

@onready var cannon_cooldown: Timer = $"Cannon Cooldown"

var cooldown = false
var cd_time = 0.5


# Vertical speed
const accel_modifier = 3
var acceleration = 90
var min_accel = 60
var max_accel = 200
# Horizontal speed and accel/brake
const LATERAL_SPEED = 300.0
var lat_accel = 1600.0
var lat_brake = 1500.0

var cur_direction = 0

# Fuel management
var max_fuel = 100
var cur_fuel = 100
var base_fuel_rate = 2

signal fuel_update(val)

func _physics_process(delta: float) -> void:
	
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
		if cur_direction != direction:
			velocity.x *= 0.2
		cur_direction = direction
		var target_speed = direction * LATERAL_SPEED
		velocity.x = move_toward(velocity.x, target_speed, lat_accel * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, lat_brake * delta)
	move_and_slide()
	
	#Fuel management
	var speed_factor = acceleration / max_accel
	var consumption = base_fuel_rate * (1.0 + speed_factor) * delta
	fuel_consumption(clamp(consumption, 0.0, max_fuel))

func fuel_consumption(value):
	cur_fuel -= value
	emit_signal("fuel_update", cur_fuel)
	if cur_fuel < 1:
		print("Out of fuel")

func fuel_refill(value):
	cur_fuel = min(cur_fuel + value, max_fuel)
	emit_signal("fuel_update", cur_fuel)
	if cur_fuel == max_fuel:
		print("Fuel is at 100% capacity!")

func shoot():
	var left_missile = bullet.instantiate()
	var right_missile = bullet.instantiate()
	left_missile.global_position = left_cannon.global_position
	right_missile.global_position = right_cannon.global_position
	bullets.add_child(left_missile)
	bullets.add_child(right_missile)
	cannon_cooldown.start(cd_time)
	pass


func _on_cannon_cooldown_timeout() -> void:
	cooldown = false
	print("Can fire again")
