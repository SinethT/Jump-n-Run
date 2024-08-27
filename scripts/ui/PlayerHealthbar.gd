extends ProgressBar

var health = 0:
	set = _set_health

@onready var timer = $Timer
@onready var damage_bar = $DamageBar


# Initializes the health of the player's health bar
func init_health(_health):
	health = _health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health


# Sets the health of the player.
# - `new_health`: The new health value to set.
func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health

	if health <= 0:
		queue_free()

	if health < prev_health:
		timer.start()
	else:
		damage_bar.value = health


# Called when the timer times out.
# Updates the value of the damage bar to match the current health value
func _on_timer_timeout():
	damage_bar.value = health
