extends Node2D

@onready var current_scene = get_tree().current_scene;

func changeScene(path: String) -> void:
	call_deferred("_deferred_goto_scene",path);

func _deferred_goto_scene(path: String) -> void:
	if(path == "res://MainGameScene.tscn"):
		Statuses.current_bonus = 0;
		Statuses.packagesToDeliver = 3;
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_scene;
