extends Control
@onready var score = $MarginContainer/HBoxContainer/Score

func _ready():
	score.text = "Your Bonus: [wave]$%s" % Statuses.current_bonus;

func _on_main_menu_pressed():
	SceneChanger.changeScene("res://main_menu.tscn")

func _on_play_again_pressed():
	SceneChanger.changeScene("res://MainGameScene.tscn")
