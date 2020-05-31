extends KinematicBody2D
class_name ActorBase

export var speed : float = 60.0

onready var animated_sprite_node = $AnimatedSprite
onready var bubble_scene = preload("res://Scenes/GUI/Bubble/Bubble.tscn")
onready var path_node = get_node_or_null("Path")

export var action_name_bubble : String = ""
export var breakable_block_type : String = ""

export var default_state : String = ""

export var jump_force : int = -500 

const GRAVITY : int = 30

var snap_vector = Vector2(0, 10)
var current_snap = snap_vector

var direction := Vector2.ZERO setget set_direction
var velocity := Vector2.ZERO setget set_velocity, get_velocity

signal velocity_changed


func set_direction(value : Vector2):
	direction = value.normalized()


func set_velocity(value: Vector2):
	if value != velocity:
		emit_signal("velocity_changed", value)
	velocity = value


func get_velocity() -> Vector2:
	return velocity


func _ready():
	var _err = connect("velocity_changed", self, "on_velocity_changed")
	$StatesMachine.default_state = default_state


func _physics_process(_delta):
	velocity.x = direction.x * speed
	velocity.y += GRAVITY
	velocity = move_and_slide_with_snap(velocity, current_snap, Vector2.UP, true, 4, deg2rad(46), false)


func tuto_bubble():
	var input = get_reel_input(action_name_bubble)
	
	if action_name_bubble == "" or input == "":
		return
	
	var bubble_node = bubble_scene.instance()
	bubble_node.button_name = input
	bubble_node.set_position(Vector2(6, -28))
	call_deferred("add_child", bubble_node)


func get_reel_input(action_name : String) -> String:
	var input_event_array = InputMap.get_action_list(action_name)
	
	if input_event_array == []:
		return ""
	else:
		return input_event_array[0].as_text()


func appear():
	$StatesMachine.set_state("Rise")

func set_state(state_name: String):
	$StatesMachine.set_state(state_name)

func overheat():
	$AnimationPlayer.play("Overheat", -1, 2.5)


func destroy():
	SFX.play_SFX(SFX.small_explosion, global_position)
	queue_free()


func jump():
	if is_on_floor():
		set_state("Jump")


# Flip the sprite accordingly to the directon facing the robot
func on_velocity_changed(new_velocity: Vector2):
	if new_velocity.x < 0:
		animated_sprite_node.set_flip_h(true)
		animated_sprite_node.offset.x *= -1
	elif new_velocity.x > 0:
		animated_sprite_node.set_flip_h(false)
		animated_sprite_node.offset.x = abs(animated_sprite_node.offset.x)

