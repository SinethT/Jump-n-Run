extends Node2D
class_name Checkpoint

@export var spawnpoint = false
@export var win_condition = false

var activated = false


func _ready():
	if spawnpoint:
		activate()


func activate():
	# If win checkpoint, opens win screen
	if win_condition:
		GameManager.win()

	GameManager.current_checkpoint = self
	activated = true
	# Play waving animation 
	$AnimationPlayer.play("activated")


func _on_area_2d_area_entered(area):
	# Gets activated if it player enters the area
	if area.get_parent() is Player && !activated:
		activate()
