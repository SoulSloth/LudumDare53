extends CanvasLayer
@onready var packages = %Packages;
@onready var ammo = $MarginContainer/VBoxContainer/HBoxContainer/Ammo
@onready var mac_gun = %macGun

const openedPackage: Texture2D = preload("res://assets/ui/OpenedPackage.png");

# Called when the node enters the scene tree for the first time.
func _ready():
	mac_gun.packageFired.connect(_on_package_fired)
	Statuses.packageDelivered.connect(_on_package_delivered)

func _on_package_delivered(_packageIndex: String):
	packages.get_node(str(Statuses.deliveredTo.size())).texture = openedPackage;

func _on_package_fired():
	ammo.get_node(str(Statuses.ammo)).modulate = Color(0.5,0.5,0.5,1);
	Statuses.ammo -= 1;
