extends CharacterBody2D
class_name Sabertooth

const DAMAGE_VALUE = 5

var speed = -60.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var facing_right = false
var dead = false
const max_health = 5
var health = 0
var can_take_damage = true
var current_speed = 0.0
var hit = false
var can_attack = true

@export var score = 50

func _ready():
	health = max_health
	$AnimationPlayer.play("run")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if !$RayCast2D.is_colliding() && is_on_floor():
		flip()
	
	velocity.x = speed
	move_and_slide()

func flip():
	facing_right = !facing_right
	
	scale.x = abs(scale.x) * -1
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1
		



func _on_hitbox_area_entered(area):
	if area.get_parent() is Player && !dead && can_attack:
		area.get_parent().take_damage(DAMAGE_VALUE)

func take_damage(damage_amount : int):
	if !dead:
		if can_take_damage: 
			immune_frames()
			health -= damage_amount
			$AnimationPlayer.play("hit")
			get_node("healthbar").update_healthbar(health, max_health)
		
		if health <= 0:
			die()

func get_hit():
	hit = !hit
	
	if hit:
		current_speed = speed
		speed = 0
		can_attack = false
	else:
		speed = current_speed
		can_attack = true
		$AnimationPlayer.play("run")

func immune_frames():
	can_take_damage = false
	await get_tree().create_timer(0.5).timeout
	can_take_damage = true

func die():
	GameManager.enemies_beaten += 1
	GameManager.score += score
	dead = true
	speed = 0
	# queue_free() called in Animation Player
	$AnimationPlayer.play("die")
