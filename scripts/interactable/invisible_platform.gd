extends StaticBody2D

var showing = false


func _on_area_2d_area_entered(area):
	# If player entered the area, make it visible
	if area.get_parent() is Player && !showing:
		showing = true
		$AnimationPlayer.play("fade_in")
