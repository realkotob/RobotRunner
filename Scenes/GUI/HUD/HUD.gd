extends Control

onready var background_node = $Background

export var hidden : bool = true setget set_hidden, get_hidden
export var speed : int = 400

onready var HUD_width = background_node.get_size().y

func _ready():
	rect_position = Vector2(0, -HUD_width)
	set_visible(true)


func set_hidden(value: bool):
	if value != hidden:
		hidden = value
		set_physics_process(true)


func get_hidden() -> bool:
	return hidden


# Show/Hide the HUD on ui_select
func _input(_event):
	if Input.is_action_just_pressed("HUD_switch_state"):
		hidden = !hidden
		set_physics_process(true)


# Move the HUD until it reaches its new position
func _physics_process(delta):
	var actual_speed = speed * delta
	
	if !hidden && rect_position != Vector2.ZERO:
		move_to(Vector2.ZERO, actual_speed)
	elif hidden && rect_position != Vector2(0, -HUD_width):
		move_to(Vector2(0, -HUD_width), actual_speed)


# Move the element to the given position until it reaches it
func move_to(dest: Vector2, spd : float):
	rect_position += rect_position.direction_to(dest) * spd
		
	if rect_position.distance_to(dest) < spd:
		rect_position = dest
		set_physics_process(false)
