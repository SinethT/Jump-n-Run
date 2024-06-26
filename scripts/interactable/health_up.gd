extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("idle")

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		if area.get_parent().health < area.get_parent().MAX_HEALTH:
			area.get_parent().health += 2
		queue_free()
