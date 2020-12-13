extends StateBase

var camera_debug_speed : float = 1000.0 
var speed_increase_amount : float = 100.0
var v_dir : int = 0
var h_dir : int = 0

#### ACCESSORS ####

func is_class(value: String):
	return value == "" or .is_class(value)

func get_class() -> String:
	return ""

#### BUILT-IN ####

func _physics_process(delta):
	if v_dir == 0 && h_dir == 0:
		return
	
	owner.move_vel(delta, camera_debug_speed * Vector2(h_dir, v_dir))


#### LOGIC ####

func enter_state(_host : Node):
	set_physics_process(true)

func exit_state(_host : Node):
	set_physics_process(false)

#### VIRTUALS ####



#### INPUTS ####

func _input(_event):
	if states_node.get_current_state() != self:
		return
	
	if Input.is_action_just_pressed("camera_speed_increase"):
		camera_debug_speed += speed_increase_amount
	
	if Input.is_action_just_pressed("camera_speed_decrease"):
		camera_debug_speed -= speed_increase_amount 
	
	if Input.is_action_just_pressed("camera_zoom_debug"):
		owner.start_zooming(Vector2.ONE)
	
	if Input.is_action_just_pressed("camera_dezoom_debug"):
		owner.start_zooming(Vector2(2.0, 2.0))
	
	
	var move_up = int(Input.is_action_pressed("jump_player1") or Input.is_action_pressed("jump_player2"))
	var move_down = int(Input.is_action_pressed("teleport_player1") or Input.is_action_pressed("teleport_player2"))
	var move_left = int(Input.is_action_pressed("move_left_player1") or Input.is_action_pressed("move_left_player2"))
	var move_right = int(Input.is_action_pressed("move_right_player1") or Input.is_action_pressed("move_right_player2"))
	
	v_dir = move_down - move_up
	h_dir = move_right - move_left

#### SIGNAL RESPONSES ####
