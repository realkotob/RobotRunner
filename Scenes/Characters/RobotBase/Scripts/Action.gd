extends PlayerStateBase

class_name ActionBase

### ACTION STATE  ###

var direction_node : Node
var interact_able_array : Array
var character_node : KinematicBody2D
var inputs_node : Node

export var animation_offset : Vector2
export var breakable_type_array : PoolStringArray
export var interactables : PoolStringArray

var bodies_in_hitbox : Array

var hit_box_node : Area2D
var hit_box_shape : Node
var face_dir : int

var has_touch : bool = false

onready var audio_node = get_node("AudioStreamPlayer")

# Setup, called by the parent when it is ready
func setup():
	var _err = animation_node.connect("animation_finished", self, "on_animation_finished")
	hit_box_shape = hit_box_node.get_child(0)


# Aplly the offset of the animation every thick
func update(_host, _delta):
	offset_animation()
	
	# Destroy a block if it is in the hitbox area, and if his type correspond to the current robot breakable type
	bodies_in_hitbox = hit_box_node.get_overlapping_bodies()
	if has_touch == false:
		for body in bodies_in_hitbox:
			if body.get_class() in breakable_type_array:
				body.damage()
				# Keep track if at least one block has been touched
				has_touch = true


# When the actor enters action state: set active the hit box, and play the right animation, applying it the defined offset
func enter_state(_host):
	# Play the animation
	offset_animation()
	animation_node.play(self.name)
	
	# Play the audio
	audio_node.play()
	
	# Set the hitbox active
	hit_box_shape.set_disabled(false)


# When the actor exits action state: set unactive the hit box and triggers the interaction if necesary
func exit_state(_host):
	animation_node.set_offset(Vector2(0, 0))
	
	# Get every area in the hitbox area
	var interact_areas = hit_box_node.get_overlapping_areas()
	
	# Check if one on the areas in the hitbox area is an interative one, and interact with it if it is
	# Also verify if no block were broke in this use of the action state
	for area in interact_areas:
		if area.get_class() in interactables && has_touch == false:
			area.interact(hit_box_shape.global_position)
	
	# Reset the was broke bool, for the next use of the action state
	has_touch = false
	
	# Set the hitbox inactive
	hit_box_shape.set_disabled(true)


# When the animation is off, set the actor's state to Idle
func on_animation_finished():
	if state_node.current_state == self:
		if character_node.is_on_floor():
			state_node.set_state("Idle")
		else:
			state_node.set_state("Fall")


# Apply the offset to the animation, and orient it the right way, depending of the direction the character is facing
func offset_animation():
	face_dir = direction_node.get_face_direction()
	var current_anim_offset = animation_offset
	current_anim_offset.x *= face_dir
	if animation_node.get_offset() != current_anim_offset:
		animation_node.set_offset(current_anim_offset)


# Define the actions the player can do in this state
func _input(event):
	if state_node.get_current_state() == self:
		
		if event.is_action_pressed(inputs_node.input_map["MoveLeft"]) or event.is_action_pressed(inputs_node.input_map["MoveRight"]):
			if character_node.is_on_floor():
				state_node.set_state("Move")
		
		elif event.is_action_pressed(inputs_node.input_map["Jump"]):
			if character_node.is_on_floor():
				state_node.set_state("Jump")
