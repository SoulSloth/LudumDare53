extends Node
signal salaryUpdated(newSalary:int)
signal packageDelivered(packageIndex:int)
var current_bonus: int = 0;
var packagesToDeliver: int = 3;

func package_delivered(targetHit: String):
	var compensation: int = 0;
	match(targetHit):
		"The Sun":
			compensation = 10;
		"Mercury":
			compensation = 20;
		"Venus":
			compensation = 20;
		"Earth":
			compensation = 20;
		"Moon":
			compensation = 20;
		_:
			push_warning("collided with unkonwn body: %s!", targetHit);
	current_bonus += compensation;
	emit_signal("salaryUpdated",current_bonus);
	
	emit_signal("packageDelivered",packagesToDeliver);
	packagesToDeliver -= 1;


func check_game_over():
	if packagesToDeliver == 0:
		SceneChanger.changeScene("res://game_over.tscn");
