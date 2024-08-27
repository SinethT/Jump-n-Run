extends Node

signal gained_coins
signal level_beaten

const MAP = "res://scenes/world_scenes/map.tscn"

var coins: int = 0
var score: int = 0
var current_checkpoint: Checkpoint
var pause_menu
var win_screen
var score_label
var player: Player
var damage_taken = 0
var enemies_beaten = 0
var paused = false


func respawn_player():
	# Check id there is a checkpoint (safety measures)
	if current_checkpoint != null:
		# Make player's position = checkpoint's position for respawning
		player.position = current_checkpoint.global_position


func gain_coins(coins_gained: int):
	# Updating coins variable: coins = coins + gained coins
	coins += coins_gained
	# Emits a signal, it catches by the UI Manager to update CoinDisplay
	emit_signal("gained_coins", coins_gained)

	#print(coins)


func win():
	# Emits a signal when level is beaten,
	# it catches by RunTimeLevel and unlocks the next level
	emit_signal("level_beaten")
	# Make win screen visible
	win_screen.visible = true
	# Updates the score in win screen
	score_label.text = "score: " + str(score)


func pause_play():
	# Acts as a bool to determine whether to show pause menu
	paused = !paused
	# Display the pause menu according to the above value
	pause_menu.visible = paused


func resume():
	# Resumes game when pressed the resume button in pause menu 
	get_tree().paused = false
	pause_play()


func restart():
	# Make all the values to their initial value to restart 
	coins = 0
	score = 0
	current_checkpoint = null
	get_tree().reload_current_scene()


func map():
	# Hides pause menu, or it'll show when player enters the level from map
	get_tree().paused = false
	# Opens map 
	get_tree().change_scene_to_file(MAP)


func quit():
	# Exits the game 
	get_tree().quit()
