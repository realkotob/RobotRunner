extends Camera2D

onready var state_machine_node = $StateMachine
onready var stop_state_node = $StateMachine/Stop
onready var follow_state_node = $StateMachine/Follow
onready var moveto_state_node = $StateMachine/MoveTo
onready var shake_state_node = $StateMachine/Shake

export var camera_speed : float = 3.0
export var x_zoom_enabled : bool = true
export var y_zoom_enabled : bool = true
export var default_state : String = "Follow"

var destination_zoom := Vector2.ONE
var zoom_speed : float = 0.02
var current_zoom_speed : float = zoom_speed

var instruction_stack : Array = []

func _ready():
	state_machine_node.setup()
	set_state("Follow")


func _physics_process(_delta):
	if zoom != destination_zoom:
		_zoom_to(destination_zoom)
	else:
		current_zoom_speed = zoom_speed


# Add an instruction in the stack
func stack_instruction(instruction: Array):
	instruction_stack.append(instruction)
	
	var current_state = state_machine_node.get_state_name()
	if current_state == "Follow" or current_state == "Stop":
		execute_next_instruction()


# Unstack the next instruction and execute it
func execute_next_instruction():
	if len(instruction_stack) == 0:
		return
	
	var instruction = instruction_stack.pop_front()
	var intruction_funcref := funcref(self, instruction.pop_front())
	intruction_funcref.call_funcv(instruction)


# Give the camera the order to move at the given position, and set it's state to move_to
func move_to(dest: Vector2, average_w_players : bool = false, move_speed : float = -1.0, duration : float = 0.0):
	moveto_state_node.destination = dest
	moveto_state_node.average_w_players = average_w_players
	
	if move_speed != -1.0:
		moveto_state_node.current_speed = move_speed
		
	moveto_state_node.wait_time = duration
	state_machine_node.set_state("MoveTo")


func set_state(state_name: String):
	state_machine_node.set_state(state_name)


func set_destination_zoom(dest_zoom : Vector2):
	destination_zoom = dest_zoom


# Progressively zoom/dezoom
func _zoom_to(dest_zoom: Vector2):
	zoom = zoom.linear_interpolate(dest_zoom, current_zoom_speed)


# Set the average_pos variable to be at the average of every players position
func compute_average_pos(players_array: Array) -> Vector2:
	var average_pos = Vector2.ZERO
	for player in players_array:
		average_pos += player.global_position

	average_pos /= len(players_array)
	
	return average_pos


func shake(magnitude: float, duration: float):
	shake_state_node.magnitude = magnitude
	shake_state_node.duration = duration
	set_state("Shake")
