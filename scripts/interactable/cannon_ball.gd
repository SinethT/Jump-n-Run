extends Node2D

const DAMAGE_VALUE = 5

var direction
var speed = 200.0
var lifetime = 1.0
var hit = false


func _ready():
	# Flies for timer's amount
	await get_tree().create_timer(lifetime).timeout
	die()


func _physics_process(delta):
	position.x += abs(speed * delta) * direction


func die():
	hit = true
	speed = 0
	# queue_free called in the AnimationPlayer
	$AnimationPlayer.play("hit")


func _on_area_2d_area_entered(area):
	# Player takes damage if it gets hit
	if area.get_parent() is Player && !hit:
		area.get_parent().take_damage(DAMAGE_VALUE)
		# Cannon ball disappear
		die()
