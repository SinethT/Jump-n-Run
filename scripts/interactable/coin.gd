extends Node2D
class_name Coin

@export var score = 10
@export var coins = 1

@onready var coin_collection_sfx = $CoinCollectionSFX


func _ready():
	$AnimationPlayer.play("idle")


func _on_area_2d_area_entered(_area):
	self.hide()
	GameManager.gain_coins(coins)
	GameManager.score += score
	coin_collection_sfx.play()
	await coin_collection_sfx.finished
	queue_free()
