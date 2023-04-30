extends StaticBody2D
@export_range(0.1,100.0) var mass: float = 1.0;
@export_range(0.1,1000.0) var plant_speed: float = 500.0;
@onready var camera_2d = $"Camera2D"
@onready var the_gun = $TheGun
const packageResoruce : Resource = preload("res://package.tscn");
const zoom_increment : Vector2 = Vector2(0.25,0.25);
const zoom_max : Vector2 = Vector2(20,20);
const zoom_min : Vector2 = Vector2(0.05,0.05);

var _smoothed_mouse_pos: Vector2;
var orbit_path: PathFollow2D;
var ready_to_fire: bool = true;

func _ready():
	orbit_path = get_node_or_null("../%sPath/PathFollow2D" % name);

func _process(delta):
	if(orbit_path != null):
		orbit_path.progress += delta*plant_speed;
		position = orbit_path.position;
#	the_gun.look_at(get_global_mouse_position())
#	the_gun.rotate(PI/2)
	_smoothed_mouse_pos = lerp(_smoothed_mouse_pos,get_global_mouse_position(), 0.15)
	the_gun.look_at(_smoothed_mouse_pos)
#	the_gun.rotate(PI/2)

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed() and ready_to_fire:
		var package = packageResoruce.instantiate();
		var direction: Vector2 = Vector2.from_angle(the_gun.rotation);
		$"../..".add_child(package);
		package.position = global_position + direction * 100;
		package.apply_impulse(direction * 750);
		package.gunRef = self;
		ready_to_fire = false;
		package.get_node("Camera2D").enabled = true;
		camera_2d.enabled = false;
		
	##
	## Handle zooming in
	if event is InputEventMouseButton and event.is_pressed() and (event.button_index == MOUSE_BUTTON_WHEEL_DOWN or event.button_index == MOUSE_BUTTON_WHEEL_UP):
		match(event.button_index):
			MOUSE_BUTTON_WHEEL_UP:
				if (camera_2d.zoom + zoom_increment).length() < zoom_max.length():
					camera_2d.zoom += zoom_increment;
				else:
					camera_2d.zoom = zoom_max;
			MOUSE_BUTTON_WHEEL_DOWN:
				if (camera_2d.zoom - zoom_increment).length() > zoom_min.length() and (camera_2d.zoom - zoom_increment).x > 0:
					camera_2d.zoom -= zoom_increment;
				else:
					camera_2d.zoom = zoom_min;
