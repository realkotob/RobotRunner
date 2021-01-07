extends BlockBase
class_name IceBlock

var floating_line : float = INF setget set_floating_line, get_floating_line
var floating_force : float = 1000.0

onready var base_gravity_scale = get_gravity_scale()

#### ACCESSORS ####

func is_class(value: String): return value == "IceBlock" or .is_class(value)
func get_class() -> String: return "IceBlock"

func set_floating_line(value: float):
	floating_line = value
	if floating_line != INF:
		awake()

func get_floating_line() -> float: return floating_line

### BUILT-IN ###

func _ready():
	set_physics_process(false)


func _physics_process(_delta):
	if is_sleeping():
		return
	
	if floating_line != INF:
		apply_floating(global_position.y > floating_line)

#### LOGIC ####


func apply_floating(value: bool):
	var force_dir := Vector2.UP if value else Vector2.DOWN
	var force = get_applied_force()
	
	if force != floating_force * force_dir:
		add_central_force(floating_force * force_dir)
