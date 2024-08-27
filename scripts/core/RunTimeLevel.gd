extends Node
class_name RunTimeLevel

var max_score = 0
var max_coins = 0
var max_enemies = 0

@onready var level = name

func _ready():

	# Initializes the GameManager variables for coins, score, damage taken, and enemies beaten.
	GameManager.coins = 0
	GameManager.score = 0
	GameManager.damage_taken = 0
	GameManager.enemies_beaten = 0
	# Connects the `level_beaten` signal to the `beat_level` method.
	GameManager.level_beaten.connect(beat_level)
	# Calls the `set_values` method to set initial values.
	set_values()


func set_values():

	# Calculating most enemies, coins and score the player can gain within that level
	for node in get_children():
		if node is Coin:
			max_score += node.score
			max_coins += node.coins
		if node is Sabertooth or node is Cannon:
			max_score += node.score
			max_enemies += 1


func beat_level():
	# Unlocks the next level
	LevelData.generate_level(LevelData.level_dic[level]["unlocks"])
	LevelData.level_dic[LevelData.level_dic[level]["unlocks"]]["unlocked"] = true

	# Updates the level data for the stat screen & data mesh (for saving)
	LevelData.update_level(
		level,
		GameManager.score,
		max_score,
		GameManager.coins,
		max_coins,
		GameManager.enemies_beaten,
		max_enemies,
		GameManager.damage_taken,
		true
	)
	SaveManager.save_game()
