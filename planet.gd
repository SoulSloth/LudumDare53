extends StaticBody2D
@export_range(0.1,100.0) var mass: float = 1.0;
@export_range(0.1,1000.0) var plant_speed: float = 500.0;

var orbit_path: PathFollow2D;

func _ready():
	orbit_path = get_node_or_null("../%sPath/PathFollow2D" % name);
	if(orbit_path):
		orbit_path.progress_ratio = randf_range(0.0,1.0);

func _process(delta):
	if(orbit_path != null):
		orbit_path.progress += delta*plant_speed;
		position = orbit_path.position;
