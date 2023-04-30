extends CanvasLayer
@onready var mac_gun = %macGun

# Called when the node enters the scene tree for the first time.
func _ready():
	mac_gun.ready_to_fire = false;

func _input(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		var tween = get_tree().create_tween()
		tween.tween_property($Sprite2D2, "position", Vector2(0,1000), 1).set_trans(Tween.TRANS_SINE)
		tween.tween_callback(_tutorial_over)

func _tutorial_over():
	mac_gun.ready_to_fire = true;
	queue_free();
