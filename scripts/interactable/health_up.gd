extends Node2D

@onready var health_up_sfx = $HealthUpSFX


const HEALTH_UP = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("idle")

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		if area.get_parent().health < area.get_parent().MAX_HEALTH:
			#print(area.get_parent().health)
			area.get_parent().health += HEALTH_UP
			#print(area.get_parent().health)
			area.get_parent().player_healthbar.health = area.get_parent().health
		self.hide()
		health_up_sfx.play()
		await health_up_sfx.finished
		queue_free()
	
