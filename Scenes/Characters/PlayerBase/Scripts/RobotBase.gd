extends KinematicBody2D

class_name Player

# Store all the children references
onready var inputs_node = get_node("Inputs")
onready var animation_node = get_node("Animation")
onready var action_hitbox_node = get_node("ActionHitBox")
onready var SFX_node = get_node("SFX")
onready var anim_player_node = get_node("AnimationPlayer")

export (int, 0, 200) var push = 2
export var speed : int = 400 setget set_speed, get_speed
export var jump_force : int = -500 setget set_jump_force, get_jump_force

const GRAVITY : int = 30
const MAX_SPEED = 500

var snap_vector = Vector2(0, 10)
var current_snap = snap_vector

var velocity : Vector2 setget set_velocity, get_velocity
var dirLeft : int = 0 
var dirRight : int = 0

var teleport_node : Area2D = null
var level_node : Node

#### ACCESSORS ####

func is_class(value: String):
	return value == "Player"

func get_class() -> String:
	return "Player"

func set_speed(value : int):
	speed = value

func get_speed() -> int:
	return speed

func set_velocity(value : Vector2):
	velocity = value

func get_velocity() -> Vector2:
	return velocity

func set_jump_force(value : int):
	jump_force = value

func get_jump_force() -> int:
	return jump_force

func set_state(value : String):
	$States.set_state(value)

func get_state() -> String:
	return $States.get_state_name()

func get_extents() -> Vector2:
	return $CollisionShape2D.get_shape().get_extents()


func _ready():
	var _err = anim_player_node.connect("animation_finished", self, "on_animation_finished")
	add_to_group("Players")


#### PHYSIC BEHAVIOUR ####

func _physics_process(delta):
	var dir = get_move_direction()
	
	# Compute velocity
	velocity.x = dir * speed
	
	# Flip the character in the right direction
	if abs(velocity.x) > 0.0:
		var is_looking_left = get_move_direction() == -1
		animation_node.set_flip_h(is_looking_left)
		flip_hit_box()
	
	velocity.y += GRAVITY
	
	# Jump corner correction
	if get_state() == "Jump":
		# Make a movement test to check collisions preemptively
		var corner_col = move_and_collide(velocity * delta, true, true, true)
		if corner_col != null:
			var col_normal = corner_col.get_normal()
			if col_normal.x < 0.2 && col_normal.x > -0.2:
				corner_correct(20, delta)
	
	# Apply movement
	velocity = move_and_slide_with_snap(velocity, current_snap, Vector2.UP, true, 4, deg2rad(46), false)
	
	# Apply force to bodies it hit
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("MovableBodies"):
			collision.collider.apply_central_impulse(-collision.normal * push)


func corner_correct(amount : int, delta: float):
	for i in range(1, amount + 1):
		for j in [1, -1]:
			var movement = Vector2(i * j, velocity.y * delta)
			if !move_and_collide(movement, true, true, true):
				global_position += movement
				return


#### INPUT RESPONSES ####

func _input(event):
	if event.is_action_pressed(inputs_node.input_map["MoveLeft"]):
		dirLeft = 1
	
	elif event.is_action_released(inputs_node.input_map["MoveLeft"]):
		dirLeft = 0
	
	elif event.is_action_pressed(inputs_node.input_map["MoveRight"]):
		dirRight = 1
	
	elif event.is_action_released(inputs_node.input_map["MoveRight"]):
		dirRight = 0


#### BEHAVIOUR RELATED FUNCTIONS ####

# Returns the direction of the robot
func get_move_direction() -> int:
	return dirRight - dirLeft


# Returns the direction of the robot
func get_face_direction() -> int:
	if animation_node.is_flipped_h():
		return -1
	else:
		return 1


# Flip the hit box shape
func flip_hit_box():
	var hit_box_shape_x_pos = action_hitbox_node.get_child(0).position.x
	action_hitbox_node.get_child(0).position.x = abs(hit_box_shape_x_pos) * get_face_direction()


# Triggers the overheat animation
# Called by the cloud when a player enters it
func overheat():
	anim_player_node.play("Overheat")


# Triggers the fadeOut animation
# Called by the greatdoor when a player exit the level
func fade_out():
	anim_player_node.play("FadeOut")


# Stops the overheat animation
func stop_overheat():
	var anim : String = anim_player_node.get_current_animation()
	if anim == "Overheat":
		anim_player_node.play("Default")


# Called when the robot is destroyed, triggers the death animation, the gameover,
# and destroy this instance
func destroy():
	SFX.play_SFX(SFX.normal_explosion, global_position)
	GAME.gameover()
	queue_free()


#### SIGNALS RESPONSES ####

# Triggers the explosion and the destruction of the robot
func on_animation_finished(animation: String):
	if animation == "Overheat":
		destroy()
	if animation == "Fadeout":
		queue_free()


func on_xion_received():
	anim_player_node.play("MagentaFlash")


# If the player is on a teleport point and enter layer change, teleport him to the assigned teleport destiation
func on_layer_change():
	if teleport_node != null:
		teleport_node.teleport_layer(self)
		$LayerChangeAudio.play()