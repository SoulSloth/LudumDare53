extends CanvasLayer

func _ready():
	visible = false;

func _input(event):
	if event is InputEvent and not event.is_echo() and event.is_action_pressed("ui_escape"):
		if(visible == true):
			resume()
		else:
			pause()

func resume():
	get_tree().paused = false;
	visible = false;

func pause():
	get_tree().paused = true;
	visible = true;

func _on_resume_pressed():
	resume();

func _on_restart_pressed():
	SceneChanger.changeScene("res://level.tscn");
	resume();

func _on_main_menu_pressed():
	SceneChanger.changeScene("res://MainMenu.tscn");
	resume();

