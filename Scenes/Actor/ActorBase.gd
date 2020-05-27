extends KinematicBody2D
class_name ActorBase

export var speed : float = 60.0

onready var animated_sprite_node = $AnimatedSprite
onready var bubble_scene = preload("res://Scenes/GUI/Bubble/Bubble.tscn")
onready var path_node = get_node_or_null("Path")

export var action_name_bubble : String = ""

signal velocity_changed

var velocity := Vector2.ZERO setget set_velocity, get_velocity

func set_velocity(value: Vector2):
	if value != velocity:
		emit_signal("velocity_changed", value)
	velocity = value

func get_velocity() -> Vector2:
	return velocity


func _ready():
	set_visible(false)
	var _err = connect("velocity_changed", self, "on_velocity_changed")


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
	set_visible(true)
	$StatesMachine.set_state("Rise")

func move():
	$StatesMachine.set_state("Move")


func attack():
	$StatesMachine.set_state("Attack")


func overheat():
	$AnimationPlayer.play("Overheat", -1, 2.5)


func destroy():
	SFX.play_SFX(SFX.small_explosion, global_position)
	queue_free()


func on_velocity_changed(new_velocity: Vector2):
	if new_velocity.x < 0:
		animated_sprite_node.set_flip_h(true)
		animated_sprite_node.offset.x *= -1
	elif new_velocity.x > 0:
		animated_sprite_node.set_flip_h(false)
		animated_sprite_node.offset.x = abs(animated_sprite_node.offset.x)

