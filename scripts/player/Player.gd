extends CharacterBody2D
class_name Player

@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D

const SPEED = 250.0
const JUMP_VELOCITY = -400.0

@export var attacking = false

const MAX_HEALTH = 20
var health = 0
var can_take_damage = true
var facing_right = true
@export var hit = false

var shoot_cooldown = 0.5  # Cooldown time between shots in seconds
var shoot_timer = 0
#@onready var flash = $flash

@onready var shootingpoint = $shootingpoint
var bullet_scene = load("res://scenes/interactable/bullet.tscn")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	GameManager.damage_taken = 0
	health = MAX_HEALTH
	GameManager.player = self
	#flash.visible = false

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

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("go_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
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
	if !attacking && !hit:
		if velocity.x != 0:
			animation.play("run")
		else:
			animation.play("idle")
			
		if velocity.y < 0:
			animation.play("jump")
		if velocity.y > 0:
			animation.play("fall")

func take_damage(damage_amount : int):
	if can_take_damage:
		immune_frames()
		hit = true
		attacking = false
		animation.play("hit")
		GameManager.damage_taken += 1
		health -= damage_amount
	
	if health <= 0:
		die()

# Stop player taking damage infinitely
func immune_frames():
	can_take_damage = false
	await get_tree().create_timer(1).timeout
	can_take_damage = true
	
# Drop through the platform
func _input(event):
	if event.is_action_pressed("go_down") && is_on_floor():
		position.y += 5
	
func die():
	GameManager.respawn_player()
	
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
	
	var bullet = bullet_scene.instantiate()
	bullet.position = shootingpoint.global_position
	bullet.rotation_degrees = shootingpoint.global_rotation_degrees

	if not facing_right:
		bullet.rotation_degrees += 180  # Flip the bullet direction if facing left
	get_tree().root.add_child(bullet)
	
	#await get_tree().create_timer(0.2).timeout
	#flash.visible = false
	
