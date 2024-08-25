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
	animation_time = get_animation_time()
	start_pos = global_position
	target_pos = start_pos + DISTANCE
	tween = create_tween().set_loops()


func get_animation_time():
	return DISTANCE.length() / SPEED


func start_animation():
	tween.tween_property(self, "position", target_pos, animation_time)
	tween.tween_property(self, "position", start_pos, animation_time)
