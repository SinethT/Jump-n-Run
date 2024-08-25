extends Control

var fill_amount: float

@onready var fill_max = $ColorRect.size.x


func update_healthbar(health, max_health):
	fill_amount = (float(health) / max_health) * fill_max
	$ColorRect.size.x = fill_amount
