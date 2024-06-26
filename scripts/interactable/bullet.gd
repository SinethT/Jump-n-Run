extends Node2D

var direction
var speed = 200.0
var lifetime = 0.5
var hit = false

func _ready():
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta):
	position += Vector2(cos(rotation), sin(rotation)) * speed * delta


func _on_area_2d_area_entered(area):
	queue_free()
	if area.get_parent().is_in_group("enemies"):
		area.get_parent().take_damage(1)
