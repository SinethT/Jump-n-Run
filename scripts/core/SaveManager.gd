extends Node

const SAVE_PATH = "res://Saves/"
const SAVE_NAME = "save1.tres"

var save_data = SaveData.new()


# Loads the game data from the saved file
func load_game():
	save_data = ResourceLoader.load(SAVE_PATH + SAVE_NAME).duplicate(true)
	LevelData.level_dic = save_data.level_dic


func save_game():
	# Updating the level dictionary with latest data
	save_data.level_dic = LevelData.level_dic
	ResourceSaver.save(save_data, SAVE_PATH + SAVE_NAME)
