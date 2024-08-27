extends AnimatableBody2D

@export var DISTANCE: Vector2 = Vector2(100, 0)
@export var SPEED: float = 50

var animation_time: float
var start_pos: Vector2
var target_pos: Vector2
var tween: Tween


func _ready():
	setup_animation()
	start_animation()


func setup_animation():
	# Get animation time
	animation_time = get_animation_time()
	# - start_pos: The initial position of the platform
	start_pos = global_position
	# - target_pos: The position the platform will move towards
	target_pos = start_pos + DISTANCE
	# - tween: The Tween node used for smooth movement
	tween = create_tween().set_loops()


func get_animation_time():
	# Calculated time for the animation based on the length
	return DISTANCE.length() / SPEED


func start_animation():
	# Platform's position tweenes from the start position to the target position over the specified animation time. AND back
	tween.tween_property(self, "position", target_pos, animation_time)
	tween.tween_property(self, "position", start_pos, animation_time)
