extends Node2D

@export var force = -500


func _on_area_2d_area_entered(area):
	# Gives a high force through y axis, when player stepped on
	if area.get_parent() is Player:
		area.get_parent().velocity.y = force
