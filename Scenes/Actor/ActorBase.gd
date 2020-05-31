extends KinematicBody2D
class_name ActorBase

export var speed : float = 60.0

onready var animated_sprite_node = $AnimatedSprite
onready var path_node = get_node_or_null("Path")
onready var action_hitbox_node = get_node_or_null("ActionHitBox")

export var default_state : String = ""

export var jump_force : int = -500 
export (int, 0, 200) var push = 2

const GRAVITY : int = 30

var snap_vector = Vector2(0, 10)
var current_snap = snap_vector

var direction : int = 0 setget set_direction, get_direction
var velocity := Vector2.ZERO setget set_velocity, get_velocity

signal velocity_changed


#### ACCESORS ####

func set_direction(value : int):
	value = int(sign(value))
	if value != 0 and value != direction:
		flip(value)
	direction = value

func get_direction() -> int:
	return direction

func set_speed(value : float):
	speed = value

func get_speed() -> float:
	return speed

func set_velocity(value: Vector2):
	if value != velocity:
		emit_signal("velocity_changed", value)
	velocity = value

func get_velocity() -> Vector2:
	return velocity

func set_state(value : String):
	$StatesMachine.set_state(value)

func get_state() -> String:
	return $StatesMachine.get_state_name()

# Returns the direction of the robot
func get_face_direction() -> int:
	if animated_sprite_node.is_flipped_h():
		return -1
	else:
		return 1


#### BUILT-IN FUNCTIONS ####

func _ready():
	$StatesMachine.default_state = default_state


#### PHYSIC BEHAVIOUR ####

func _physics_process(delta):
	var dir = get_direction()
	
	# Compute velocity
	velocity.x = dir * speed
	
	velocity.y += GRAVITY
	
	# Jump corner correction
	if has_method("corner_correct") && get_state() == "Jump":
		# Make a movement test to check collisions preemptively
		var corner_col = move_and_collide(velocity * delta, true, true, true)
		if corner_col != null:
			var col_normal = corner_col.get_normal()
			if col_normal.x < 0.2 && col_normal.x > -0.2:
				call("corner_correct", 20, delta)
	
	# Apply movement
	velocity = move_and_slide_with_snap(velocity, current_snap, Vector2.UP, true, 4, deg2rad(46), false)
	
	# Apply force to bodies it hit
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("MovableBodies"):
			collision.collider.apply_central_impulse(-collision.normal * push)


#### LOGIC ####

func get_reel_input(action_name : String) -> String:
	var input_event_array = InputMap.get_action_list(action_name)
	
	if input_event_array == []:
		return ""
	else:
		return input_event_array[0].as_text()


func appear():
	$StatesMachine.set_state("Rise")

func overheat():
	$AnimationPlayer.play("Overheat", -1, 2.5)


func destroy():
	SFX.play_SFX(SFX.small_explosion, global_position)
	queue_free()


func jump():
	if is_on_floor():
		set_state("Jump")


# Flip the actor accordingly to the direction it is facing
func flip(dir: int):
	var is_looking_left : bool = (dir == -1)
	
	# Flip the sprite
	animated_sprite_node.set_flip_h(is_looking_left)
	
	# Flip the offset
	if is_looking_left:
		animated_sprite_node.offset.x = -abs(animated_sprite_node.offset.x)
	else:
		animated_sprite_node.offset.x = abs(animated_sprite_node.offset.x)
	
	# Flip the hitbox
	if action_hitbox_node != null:
		var hit_box_shape_x_pos = action_hitbox_node.get_child(0).position.x
		action_hitbox_node.get_child(0).position.x = abs(hit_box_shape_x_pos) * dir

