extends BlockBase

class_name IceBlock

### ICEBLOCKS ###

var floating_line_y : float = 0.0
var floating_speed : int = 50
var is_floating : bool = false setget set_is_floating

var floating_force := Vector2(0, -150)
onready var base_gravity_scale = get_gravity_scale()

func _physics_process(_delta):
	if floating_line_y != 0.0:
		if global_position.y >= floating_line_y:
			apply_floating(true)
		else:
			apply_floating(false)


func apply_floating(value: bool):
	var y_direction : int
	if value == true:
		y_direction = 1
	else:
		y_direction = -1

	if(get_applied_force()) != floating_force * y_direction:
		add_central_force(Vector2(0,0))
		add_central_force(floating_force * y_direction)


func is_class(value: String):
	return value == "IceBlock"


func set_is_floating(value: bool):
	is_floating = value
	apply_floating(true)
	add_to_group("MovableBodies")
