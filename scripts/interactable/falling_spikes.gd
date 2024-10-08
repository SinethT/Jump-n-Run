extends Node2D

const DAMAGE_VALUE = 3

@export var speed = 160.0

var current_speed = 0.0

@onready var spawn_pos = global_position


func _physics_process(delta):
	position.y += current_speed * delta


func _on_hitbox_area_entered(area):
	# Player takes damage if he gets hit
	if area.get_parent() is Player:
		area.get_parent().take_damage(DAMAGE_VALUE)
		queue_free()


func _on_player_detect_area_entered(area):
	if area.get_parent() is Player:
		$AnimationPlayer.play("shake")


func fall():
	# Fall down until the timeout
	current_speed = speed
	await get_tree().create_timer(2.5).timeout
	position = spawn_pos
	current_speed = 0.0
