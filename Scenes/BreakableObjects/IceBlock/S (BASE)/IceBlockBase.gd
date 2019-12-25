extends RigidBody2D

var floating_line_y : float
var floating_speed : int = 50
var is_floating : bool = false

func _physics_process(delta):
	if is_floating :
		floating(delta)

func _ready():
	add_to_group("Bodies")
	add_to_group("IceBlock")

func set_static():
	set_mode(MODE_STATIC)

func set_rigid():
	set_mode(MODE_RIGID)

func floating(delta):
	var dist_to_float_line = global_position.y - floating_line_y
	if abs(dist_to_float_line) > 3:
		position.y += floating_speed * sign(-dist_to_float_line) * delta
