extends StaticBody2D
signal packageFired;
@export_range(0.1,100.0) var mass: float = 1.0;
@export_range(0.1,1000.0) var plant_speed: float = 500.0;
@onready var camera_2d = $"Camera2D"
@onready var targetZoom: Vector2 = camera_2d.zoom;
@onready var the_gun = $TheGun
@onready var photoid = $Photoid
@onready var ending_timer = $EndingTimer

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
	camera_2d.zoom = lerp(camera_2d.zoom, targetZoom, 0.2);
	if(orbit_path != null):
		orbit_path.progress += delta*plant_speed;
		position = orbit_path.position;
#	the_gun.look_at(get_global_mouse_position())
#	the_gun.rotate(PI/2)
	_smoothed_mouse_pos = lerp(_smoothed_mouse_pos,get_global_mouse_position(), 0.15)
	the_gun.look_at(_smoothed_mouse_pos)
	$CPUParticles2D.direction = _smoothed_mouse_pos - global_position;
	$CPUParticles2D.position = $TheGun.position
#	the_gun.rotate(PI/2)

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed() and ready_to_fire:
		emit_signal("packageFired");
		var package = packageResoruce.instantiate();
		var direction: Vector2 = Vector2.from_angle(the_gun.rotation);
		$"../".add_child(package);
		package.position = global_position + direction * 100;
		package.apply_impulse(direction * 750);
		package.gunRef = self;
		ready_to_fire = false;
		package.get_node("Camera2D").enabled = true;
		camera_2d.enabled = false;
		$Shoot.play()
		$CPUParticles2D.emitting = true;
		
	##
	## Handle zooming in
	if event is InputEventMouseButton and event.is_pressed() and (event.button_index == MOUSE_BUTTON_WHEEL_DOWN or event.button_index == MOUSE_BUTTON_WHEEL_UP):
		match(event.button_index):
			MOUSE_BUTTON_WHEEL_UP:
				if (targetZoom + zoom_increment).length() < zoom_max.length():
					targetZoom += zoom_increment;
				else:
					targetZoom = zoom_max;
			MOUSE_BUTTON_WHEEL_DOWN:
				if (targetZoom - zoom_increment).length() > zoom_min.length() and (targetZoom - zoom_increment).x > 0:
					targetZoom -= zoom_increment;
				else:
					targetZoom = zoom_min;


func reEnable():
	if(Statuses.ammo == 0):
		trigger_ending_sequence()
	else:
		ready_to_fire = true;
	$Ominous.play();

func trigger_ending_sequence():
	var tween = get_tree().create_tween()
	tween.tween_property(photoid, "position", Vector2(0,0),4).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN);
	tween.tween_callback(_begin_ending);

func _begin_ending():
	$MacGunDeath.play();
	$TheGun.hide();
	$Platform.hide();
	$CPUParticles2D2.emitting = true;
	$CPUParticles2D3.emitting = true;
	$Photoid.hide();
	ending_timer.connect("timeout",_to_game_over)
	ending_timer.start()

func _to_game_over():
	if(Statuses.deliveredTo.size() == 5):
		SceneChanger.changeScene("res://ending.tscn");
	else:
		SceneChanger.changeScene("res://game_over.tscn");
