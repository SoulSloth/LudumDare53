extends Control
@onready var bodies = $MarginContainer/HBoxContainer/bodies

func _ready():
	if(Statuses.deliveredTo.size() < 5):
		$MarginContainer/HBoxContainer/Title.text = "[center][shake rate=5.0 level=20]Mission Failed";
		$MarginContainer/HBoxContainer/Title.add_theme_color_override("font_shadow_color", Color.DARK_RED);
	for body in bodies.get_children():
		if !Statuses.deliveredTo.has(body.name):
			body.modulate = Color(0.2,0.2,0.1,1);

func _on_main_menu_pressed():
	SceneChanger.changeScene("res://main_menu.tscn")

func _on_play_again_pressed():
	SceneChanger.changeScene("res://MainGameScene.tscn")
