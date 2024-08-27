extends Node2D

var direction
var speed = 200.0
var lifetime = 0.5
var hit = false


func _ready():
	# Flies for timer's amount
	await get_tree().create_timer(lifetime).timeout
	queue_free()


func _physics_process(delta):
	# Moves the bullet in the direction of its rotation based on its speed and delta time
	#   - delta: The time elapsed since the last frame.
	position += Vector2(cos(rotation), sin(rotation)) * speed * delta


func _on_area_2d_area_entered(area):
	# Bullet disappear 
	queue_free()
	# Enemy takes damage when it hit by the bullet 
	if area.get_parent().is_in_group("enemies"):
		area.get_parent().take_damage(1)
