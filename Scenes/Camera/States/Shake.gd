extends CameraState

onready var timer_node = $Timer

var origin_position : Vector2 = Vector2.ZERO
var random_position : Vector2 = Vector2.ZERO
var random_rotation : float = 0.0
var magnitude : float = 0.0
var duration : float = 0.0

var limit_left : int
var limit_right : int
var limit_top : int
var limit_bottom : int

func _ready():
	var _err = timer_node.connect("timeout", self, "on_timer_timeout")


func enter_state():
	origin_position = owner.get_global_position()
	random_position = origin_position
	timer_node.set_wait_time(duration)
	timer_node.start()


func exit_state():
	timer_node.stop()
	move_to(origin_position)
	origin_position = Vector2.ZERO
	random_position = Vector2.ZERO
	owner.rotation_degrees = 0.0


# Give a new random destination position each time a new one is given
func update(_delta):
	if magnitude == 0.0 or duration == 0.0:
		return states_machine.previous_state
	
	if random_position == Vector2.ZERO or move_to(random_position):
		random_position = origin_position + Vector2(rand_range(-3.0, 3.0), rand_range(-3.0, 3.0)) * magnitude
	
	if random_rotation == 0.0 or rotate_to(random_rotation):
		random_rotation = rand_range(-0.2, 0.2) * magnitude


# Move to the current destination, return true when it's arrived, false otherwise
func move_to(dest_pos : Vector2):
	owner.global_position = owner.global_position.linear_interpolate(dest_pos, clamp(0.2 * magnitude, 0.01, 1.0))
	return owner.global_position.distance_to(dest_pos) < 2.0



func rotate_to(dest_rot : float):
	owner.rotation_degrees = lerp(owner.rotation_degrees, dest_rot, clamp(0.2 * magnitude, 0.01, 1.0))
	return abs(owner.rotation_degrees - dest_rot) < 1.0


func on_timer_timeout():
	states_machine.set_state(states_machine.previous_state)


func get_limits():
	limit_left = owner.limit_left
	limit_right = owner.limit_right
	limit_top = owner.limit_top
	limit_bottom = owner.limit_bottom


func reset_limts():
	owner.limit_left = limit_left
	owner.limit_right = limit_right
	owner.limit_top = limit_top
	owner.limit_bottom = limit_bottom


func disable_limits():
	owner.limit_left = -1000000
	owner.limit_right = 1000000
	owner.limit_top = -1000000
	owner.limit_bottom = 1000000


