extends Node
signal packageDelivered(bodyDeliveredTo:String);

var ammo: int = 5;
var deliveredTo: Array[String] = [];

func package_delivered(targetHit: String):
	if(!deliveredTo.has(targetHit)):
		deliveredTo.append(targetHit);
		emit_signal("packageDelivered",targetHit);

func reset_game():
	ammo = 5;
	deliveredTo = [];
