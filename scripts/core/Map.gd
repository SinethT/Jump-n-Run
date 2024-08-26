extends Node2D

const STAT_DISPLAY = "StatDisplay"
const SCENE_PATH = "res://scenes/world_scenes/"
const SCENE_EXTENSION = ".tscn"
const LEVEL_ICON = "LevelIcon"

var levels = []
var lerp_speed = 0.5
var lerp_progress = 0.0
var completed_movement = true
var lerp_threshold = 0.1

@onready var level_holder = $LevelHolder
@onready var player = $Player
@onready var current_level = $LevelHolder/Level1


func _ready():
	SaveManager.load_game()
	player.get_node("AnimationPlayer").play("idle")
	levels = level_holder.get_children()
	update_levels()

	#var coins : int
	#for level in SaveManager.save_data.level_dic:
	#coins += SaveManager.save_data.level_dic[level]["coins"]
	#print(coins)


func update_levels():
	for level in levels:
		if level.name in LevelData.level_dic:
			var sprite = level.get_node(LEVEL_ICON)
			if LevelData.level_dic[level.name]["unlocked"] == true:
				sprite.texture = load("res://circle1.png")
				if LevelData.level_dic[level.name]["beaten"] == true:
					sprite.texture = load("res://Star1.png")
					sprite.scale = Vector2(2, 2)
			else:
				sprite.texture = load("res://circle3.png")


func _process(delta):
	var target_level: Node2D

	if Input.is_action_just_pressed("go_up"):
		if current_level.up:
			target_level = current_level.up
	if Input.is_action_just_pressed("go_down"):
		if current_level.down:
			target_level = current_level.down
	if Input.is_action_just_pressed("go_left"):
		if current_level.left:
			target_level = current_level.left
	if Input.is_action_just_pressed("go_right"):
		if current_level.right:
			target_level = current_level.right

	if Input.is_action_just_pressed("shoot"):
		player.get_node("AnimationPlayer").play("select")
		await get_tree().create_timer(0.4).timeout
		get_tree().change_scene_to_file(SCENE_PATH + current_level.name + SCENE_EXTENSION)

	if (
		target_level
		and target_level.name in LevelData.level_dic
		and LevelData.level_dic[target_level.name]["unlocked"]
		and completed_movement
	):
		completed_movement = false
		player.get_node("AnimationPlayer").play("run")
		lerp_progress = 0
		while lerp_progress < 1.0:
			lerp_progress += lerp_speed + delta
			lerp_progress = clamp(lerp_progress, 0.0, 1.0)
			player.position = player.position.lerp(target_level.global_position, lerp_progress)

			if player.position.distance_to(target_level.global_position) < lerp_threshold:
				break

			await get_tree().create_timer(delta).timeout
		player.position = target_level.global_position
		show_stats(target_level)
		current_level = target_level
		player.get_node("AnimationPlayer").play("idle")
		completed_movement = true


func show_stats(target_level):
	if LevelData.level_dic[target_level.name]["unlocked"]:
		target_level.get_node(STAT_DISPLAY).visible = true
		target_level.get_node(STAT_DISPLAY).get_node("AnimationPlayer").play("show")
	current_level.get_node(STAT_DISPLAY).get_node("AnimationPlayer").play("show", 0, -1.0, true)

	if (
		(
			LevelData.level_dic[target_level.name]["coins"]
			> LevelData.level_dic[target_level.name]["max_coins"] * 80 / 100
		)
		and LevelData.level_dic[target_level.name]["score"] > 0
	):
		target_level.get_node(STAT_DISPLAY).get_node("CoinSprite").visible = true
	else:
		target_level.get_node(STAT_DISPLAY).get_node("CoinSprite").visible = false

	if (
		(
			LevelData.level_dic[target_level.name]["enemies_beaten"]
			== LevelData.level_dic[target_level.name]["max_enemies_beaten"]
		)
		and LevelData.level_dic[target_level.name]["score"] > 0
	):
		target_level.get_node(STAT_DISPLAY).get_node("SkullSprite").visible = true
	else:
		target_level.get_node(STAT_DISPLAY).get_node("SkullSprite").visible = false

	if (
		LevelData.level_dic[target_level.name]["damage_taken"] == 0
		and LevelData.level_dic[target_level.name]["score"] > 0
	):
		target_level.get_node(STAT_DISPLAY).get_node("HealthSprite").visible = true
	else:
		target_level.get_node(STAT_DISPLAY).get_node("HealthSprite").visible = false
