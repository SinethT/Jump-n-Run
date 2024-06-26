extends StaticBody2D
class_name Cannon

var cannon_ball = load("res://scenes/interactable/cannon_ball.tscn")
var debris = load("res://scenes/interactable/cannon_debris.tscn")

@export var shooting : bool
var firerate = 2

@export var score = 100

@onready var animation_player = $AnimationPlayer
@onready var firepoint = $firepoint

var max_health = 5
var health
var can_take_damage = true

func _ready():
	health = max_health
	shooting = true
	shoot()

func shoot():
	while shooting:
		animation_player.play("fire")
		await get_tree().create_timer(firerate).timeout

func fire():
	var spawned_ball = cannon_ball.instantiate()
	spawned_ball.direction = firepoint.scale.x
	spawned_ball.global_position = firepoint.position
	add_child(spawned_ball)

func take_damage(damage_amount):
	if can_take_damage:
		immune_frames()
		health -= damage_amount
		get_node("healthbar").update_healthbar(health, max_health)
		animation_player.play("hit")

	if health <= 0:
		die()
		
func immune_frames():
	can_take_damage = false
	await get_tree().create_timer(0.5).timeout
	can_take_damage = true
		
func die():
	GameManager.enemies_beaten += 1
	GameManager.score += score
	var spawned_debris = debris.instantiate()
	spawned_debris.global_position = position
	spawned_debris.scale.x = scale.x
	spawned_debris.get_child(1).play("crumble")
	get_tree().get_root().get_child(3).add_child(spawned_debris)
	queue_free()
