extends StaticBody2D
@export_range(100.0,1000.0,0.2) var radius: float;
@onready var collision_shape_2d = $CollisionShape2D

func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(-1000,0), 10)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
