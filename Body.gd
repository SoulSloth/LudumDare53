extends RigidBody2D

#@onready var debug_menu = $"../Debug Menu/VBoxContainer"
@onready var planets = get_tree().get_nodes_in_group("planet");
@onready var camera_2d = $Camera2D;
@onready var shrapnel = $CPUParticles2D
@onready var delivery_timer = $deliveryTimer

const zoom_increment : Vector2 = Vector2(0.25,0.25);
const zoom_max : Vector2 = Vector2(20,20);
const zoom_min : Vector2 = Vector2(0.05,0.05);

var collided : bool = false;
var accel : Vector2 = Vector2.ZERO;
var gunRef;

func _process(_delta):
	if(contact_monitor and !get_colliding_bodies().is_empty()):
		var colliding_body := get_colliding_bodies()[0];
		Statuses.package_delivered(colliding_body.name);
		contact_monitor = false;
		shrapnel.direction = ( global_position- colliding_body.global_position).normalized();
		shrapnel.emitting=true;
		freeze = true;
		delivery_timer.connect("timeout",_on_delivery_complete);
		delivery_timer.start();

func _input(event: InputEvent):
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
	
func _integrate_forces(_delta):
	if(!collided):
		accel = enumerate_planet_pulls();
#		debug_menu.find_child("Label").text = "Acceleration: %.5f,%.5f" %[accel.x, accel.y];
		apply_force(accel);

func _on_delivery_complete():
	camera_2d.enabled = false;
	gunRef.get_node("Camera2D").enabled = true;
	gunRef.ready_to_fire = true;
	queue_free();
	Statuses.check_game_over();

func enumerate_planet_pulls() -> Vector2:
	""""
	F=MA
	#(G*massOfPlant*Mass of body) / distance between their centers squared = g
	"""
	var integrated_forces: Vector2 = Vector2.ZERO;
	for planet in planets:
		var distance_between_squared = (global_position - planet.get_global_position()).length()**2;
		var gravatational_constant = 10000000;
		var mass_of_planet = planet.mass;
		var accel_magnitude = (gravatational_constant*mass_of_planet)/distance_between_squared;
		var planet_accel: Vector2 = accel_magnitude * (planet.global_position-global_position).normalized();
		integrated_forces += planet_accel;
		
	return integrated_forces;

