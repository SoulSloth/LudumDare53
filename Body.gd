extends RigidBody2D

var accel : Vector2 = Vector2.ZERO;
@onready var accel_readout = $"../Control/VBoxContainer/Label"
@onready var planets = get_tree().get_nodes_in_group("planet");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _integrate_forces(delta):
	# F=MA
	#(G*massOfPlant*Mass of body) / distance between their centers squared = g
	var accel = enumerate_planet_pulls();
	accel_readout.text = "Acceleration: %.5f,%.5f" %[accel.x, accel.y];
	apply_force(accel);


func enumerate_planet_pulls() -> Vector2:
	var integrated_forces: Vector2 = Vector2.ZERO;
	for planet in planets:
		var distance_between_squared = (global_position - planet.get_global_position()).length()**2;
		var gravatational_constant = 10000000;
		var mass_of_planet = 1.0;
		var accel_magnitude = (gravatational_constant*mass_of_planet)/distance_between_squared;
		var accel: Vector2 = accel_magnitude * (planet.global_position-global_position).normalized();
		integrated_forces += accel;
		
	return integrated_forces;
