extends Node2D

const DAMAGE_VALUE = 2


func _on_area_2d_area_entered(area):
	# Player takes damage when entered the area
	if area.get_parent() is Player:
		area.get_parent().take_damage(DAMAGE_VALUE)
