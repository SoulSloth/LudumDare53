extends CanvasLayer
@onready var score_value = %ScoreValue;
@onready var packages = %Packages;
const openedPackage: Texture2D = preload("res://assets/ui/OpenedPackage.png");


# Called when the node enters the scene tree for the first time.
func _ready():
	Statuses.salaryUpdated.connect(_on_salary_update)
	Statuses.packageDelivered.connect(_on_package_delivered)
	
func _on_salary_update(newSalary: int):
	score_value.text = "$%d" % newSalary;

func _on_package_delivered(packageIndex: int):
	packages.get_node(str(packageIndex)).texture = openedPackage;
