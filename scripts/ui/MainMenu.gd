extends Control

const LOGIN_MENU = "res://scenes/ui/LoginMenu.tscn"
const OPTIONS = "res://scenes/ui/options.tscn"
const MAIN_MENU = "res://scenes/ui/MainMenu.tscn"


func _on_start_pressed():
	get_tree().change_scene_to_file(LOGIN_MENU)


func _on_options_pressed():
	get_tree().change_scene_to_file(OPTIONS)


func _on_exit_pressed():
	get_tree().quit()


func _on_back_to_mainmenu_pressed():
	get_tree().change_scene_to_file(MAIN_MENU)
