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
var acceleration = 75
var min_accel = 45
var max_accel = 150
# Horizontal speed and accel/brake
const LATERAL_SPEED = 200.0
var lat_accel = 1600.0
var lat_brake = 1200.0

var cur_direction = 0

# Fuel management
var max_fuel = 100
var cur_fuel = 100
var base_fuel_rate = 1
var base_refill = 30
var on_depot = false

# Ammunitions
var max_ammo = 6
var cur_ammo = 6

# Health
var max_health = 4
var cur_health = 4

signal fuel_update(val)
signal health_update(val)
signal jet_explode()
signal ammo_update(val)
signal no_ammo()

func _physics_process(delta: float) -> void:
	
	# Shoot
	if Input.is_action_just_pressed("Shoot") and cooldown == false:
		if cur_ammo > 0:
			cooldown = true
			shoot()
		else:
			print("No ammo")
			emit_signal("no_ammo")
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
	if on_depot == false:
		var speed_factor = acceleration / max_accel
		var consumption = base_fuel_rate * (1.0 + speed_factor) * delta
		fuel_consumption(clamp(consumption, 0.0, max_fuel))
	else:
		var refill = base_refill * delta
		fuel_refill(refill)

func fuel_consumption(value):
	cur_fuel = max(cur_fuel - value, 0)
	emit_signal("fuel_update", cur_fuel)
	if cur_fuel < 1:
		emit_signal("jet_explode")
		print("Out of fuel")

func fuel_refill(value):
	cur_fuel = min(cur_fuel + value, max_fuel)
	emit_signal("fuel_update", cur_fuel)

func hurt(value := 1):
	cur_health -= value
	cur_health = max(cur_health, 0)
	emit_signal("health_update", cur_health)
	if cur_health > 0:
		pass # TMP INVULN
	else:
		emit_signal("jet_explode")
		print("Should die and game over")
	

func shoot():
	if cur_ammo > 0:
		var left_missile = bullet.instantiate()
		var right_missile = bullet.instantiate()
		left_missile.global_position = left_cannon.global_position
		right_missile.global_position = right_cannon.global_position
		bullets.add_child(left_missile)
		bullets.add_child(right_missile)
		cannon_cooldown.start(cd_time)
		cur_ammo -= 1
		emit_signal("ammo_update", cur_ammo)
	else:
		print("No ammo")
		emit_signal("no_ammo")

func ammo_refill():
	cur_ammo = min(cur_ammo + 3, max_ammo)
	emit_signal("ammo_update", cur_ammo)

func _on_cannon_cooldown_timeout() -> void:
	cooldown = false
	print("Can fire again")
