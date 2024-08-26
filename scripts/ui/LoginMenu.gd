extends Control

const LEVEL1 = "res://scenes/world_scenes/Level1.tscn"
const MAIN_MENU = "res://scenes/ui/MainMenu.tscn"

var player_name = ""
var birth_year = 0
var greeting = "Hi %s ^_^\nWe're Almost there…"

@onready var name_holder = $VBoxContainer/Name
@onready var year_holder = $VBoxContainer/BirthYear
@onready var loading_bar = $LoadingBar
@onready var greeter = $Greeter
@onready var age_label = $AgeLabel
@onready var input_error = $InputError
@onready var name_box = $VBoxContainer/Name
@onready var birth_year_box = $VBoxContainer/BirthYear
@onready var continue_button = $HBoxContainer/Continue


func _ready():
	loading_bar.visible = false
	greeter.visible = false
	age_label.visible = false
	input_error.visible = false
	name_box.grab_focus()
	
func _input(event):
	if name_box.has_focus():
		if event.is_action_pressed("enter") or event.is_action_pressed("tab"):
				accept_event()
				birth_year_box.grab_focus()
	elif birth_year_box.has_focus():
		if event.is_action_pressed("enter"):
				accept_event()
				continue_button.emit_signal("pressed")

func _on_continue_pressed():
	if name_holder.text.length() <= 15:
		player_name = name_holder.text.capitalize()
		greeter.text = greeting % player_name
		if year_holder.text.is_valid_int():
			birth_year = int(year_holder.text)
			if check_age(birth_year):
				loading_bar.visible = true
				loading_bar.play()
				greeter.visible = true
				await loading_bar.animation_finished
				get_tree().change_scene_to_file(LEVEL1)
			else:
				input_error.visible = false
				age_label.visible = true
		else:
			age_label.visible = false
			input_error.visible = true
	else:
		input_error.visible = true


func check_age(year):
	var current_year = Time.get_date_dict_from_system()["year"]
	if current_year - year > 7 and current_year - year < 100:
		return true


func _on_back_pressed():
	get_tree().change_scene_to_file(MAIN_MENU)
