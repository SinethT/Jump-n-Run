extends CharacterBody2D
class_name Sabertooth

const DAMAGE_VALUE = 5
const MAX_HEALTH = 5
const IMMUNE_TIME = 0.5

@export var score = 50

var speed = -60.0
# Get default gravity setting in the project from Godot
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_right = false
var dead = false
var health = 0
var can_take_damage = true
var current_speed = 0.0
var hit = false
var can_attack = true


func _ready():
	health = MAX_HEALTH
	$AnimationPlayer.play("run")


func _physics_process(delta):
	if not is_on_floor():
		# Updates the vertical velocity of the enemy based on gravity and delta time.
		#   - delta: The time elapsed since the last frame.
		velocity.y += gravity * delta

	# If RayCast is not colliding, flip enemy's direction
	if !$RayCast2D.is_colliding() && is_on_floor():
		flip()

	velocity.x = speed
	move_and_slide()


func flip():
	# Keep track of the direction using a bool
	facing_right = !facing_right

	# Changes the x and speed to flip the enemy
	scale.x = abs(scale.x) * -1
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1

# Player takes damage if he entered enemy's area
func _on_hitbox_area_entered(area):
	if area.get_parent() is Player and !dead and can_attack:
		area.get_parent().take_damage(DAMAGE_VALUE)


func take_damage(damage_amount: int):
	if !dead:
		if can_take_damage:
			# Immune frames prevent taking damage constantly
			immune_frames()
			# Decrease the health
			health -= damage_amount
			$AnimationPlayer.play("hit")
			# Updates the healthbar
			get_node("healthbar").update_healthbar(health, MAX_HEALTH)

		if health <= 0:
			die()


func get_hit():
	hit = !hit

	# If hit make it stop for a movement
	if hit:
		current_speed = speed
		speed = 0
		can_attack = false
	else:
		speed = current_speed
		can_attack = true
		$AnimationPlayer.play("run")


func immune_frames():
	# Prevent taking damage within this timer
	can_take_damage = false
	await get_tree().create_timer(IMMUNE_TIME).timeout
	can_take_damage = true


func die():
	# Update game stats
	GameManager.enemies_beaten += 1
	GameManager.score += score
	dead = true
	speed = 0
	# queue_free() called in Animation Player
	$AnimationPlayer.play("die")
