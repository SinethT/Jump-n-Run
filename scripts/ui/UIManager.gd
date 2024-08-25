extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.pause_menu = $PauseMenu
	GameManager.win_screen = $WinScreen
	GameManager.score_label = $WinScreen/Label
	GameManager.gained_coins.connect(update_coin_display)


func _process(_delta):
	if Input.is_action_just_pressed("esc"):
		get_tree().paused = GameManager.paused
		GameManager.pause_play()


func update_coin_display(_gained_coins):
	$CoinDisplay.text = str(GameManager.coins)


func _on_resume_pressed():
	GameManager.resume()


func _on_restart_pressed():
	GameManager.restart()


func _on_map_pressed():
	GameManager.map()


func _on_quit_pressed():
	GameManager.quit()


func _on_finish_level_pressed():
	GameManager.map()


func _on_start_pressed():
	print("Start pressed")


func _on_options_pressed():
	print("Options pressed")


func _on_exit_pressed():
	print("exit pressed")
