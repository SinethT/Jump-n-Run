extends CharacterBody2D
class_name Player

const SPEED = 250.0
const JUMP_VELOCITY = -400.0
const MAX_HEALTH = 20
const IMMUNE_TIME = 1.0

@export var attacking = false
@export var hit = false

var health = 0
var can_take_damage = true
var facing_right = true
var shoot_cooldown = 0.5  # Cooldown time between shots in seconds
var shoot_timer = 0
var bullet_scene = load("res://scenes/interactable/bullet.tscn")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var player_healthbar = $PlayerHealthbar
@onready var gunshot_sfx = $GunshotSFX
@onready var shootingpoint = $shootingpoint
#@onready var flash = $flash


func _ready():
	GameManager.damage_taken = 0
	health = MAX_HEALTH
	GameManager.player = self
	#flash.visible = false
	player_healthbar.init_health(health)


func _process(_delta):
	if Input.is_action_just_pressed("shoot") && !hit:
		#attack()
		shoot()


func _physics_process(delta):
	if Input.is_action_pressed("go_left"):
		facing_right = false
		sprite.scale.x = abs(sprite.scale.x) * -1
		$Area2D.scale.x = abs($Area2D.scale.x) * -1
		$AttackArea.scale.x = abs($AttackArea.scale.x) * -1
		shootingpoint.position.x = -abs(shootingpoint.position.x)
		#flash.scale.x = abs(flash.scale.x) * -1
	if Input.is_action_pressed("go_right"):
		facing_right = true
		sprite.scale.x = abs(sprite.scale.x)
		$Area2D.scale.x = abs($Area2D.scale.x)
		$AttackArea.scale.x = abs($AttackArea.scale.x)
		shootingpoint.position.x = abs(shootingpoint.position.x)
		#flash.scale.x = abs(flash.scale.x)

	# Add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump
	if Input.is_action_just_pressed("go_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration
	var direction = Input.get_axis("go_left", "go_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	update_animation()
	move_and_slide()

	if position.y >= 600:
		die()


func update_animation():
	# Handling animation according to the pkayer's status
	if !attacking and !hit:
		if velocity.x != 0:
			animation.play("run")
		else:
			animation.play("idle")

		if velocity.y < 0:
			animation.play("jump")
		if velocity.y > 0:
			animation.play("fall")


func take_damage(damage_amount: int):
	if can_take_damage:
		# Prevents taking damage constantly
		immune_frames()
		hit = true
		attacking = false
		animation.play("hit")
		# Update game stats
		GameManager.damage_taken += 1
		# Decrease the health 
		health -= damage_amount

	if health <= 0:
		# Reinitialize health before respawning 
		health = MAX_HEALTH
		die()

	# Updates the healthbar
	player_healthbar.health = health


func immune_frames():
	# Prevent taking damage within this timer
	can_take_damage = false
	await get_tree().create_timer(IMMUNE_TIME).timeout
	can_take_damage = true


# Allows falling through the platform
func _input(event):
	if event.is_action_pressed("go_down") && is_on_floor():
		position.y += 5


func die():
	# Respawning the player 
	GameManager.respawn_player()


# For future ref; if player uses a melee weapon
func attack():
	var overlapping_objects = $AttackArea.get_overlapping_areas()

	for area in overlapping_objects:
		if area.get_parent().is_in_group("enemies"):
			area.get_parent().take_damage(1)

	attacking = true
	animation.play("attack")


func shoot():
	#flash.position = shootingpoint.position + Vector2(abs(2), abs(0.5))
	#flash.visible = true

	# Instantiates a bullet and sets its position & rotation based on the shooting point
	var bullet = bullet_scene.instantiate()
	bullet.position = shootingpoint.global_position
	bullet.rotation_degrees = shootingpoint.global_rotation_degrees

	if not facing_right:
		# Flip the bullet direction if facing left
		bullet.rotation_degrees += 180
	get_tree().root.add_child(bullet)

	# Play gunshot sound
	gunshot_sfx.play()

	#await get_tree().create_timer(0.2).timeout
	#flash.visible = false
