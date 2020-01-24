extends PlayerStateBase

class_name ActionBase

### ACTION STATE  ###

var direction_node : Node
var interact_node : Node = null
var interact_able_array : Array

export var animation_offset : Vector2

var hit_box_node : Area2D
var state_node : Node
var hit_box_shape : Node

onready var audio_node = get_node("AudioStreamPlayer")

func setup():
	var _err = animation_node.connect("animation_finished", self, "on_animation_finished")
	hit_box_shape = hit_box_node.get_child(0)

# When the actor enters action state: set active the hit box, and play the right animation, applying it the defind offset
func enter_state(_host):
	var face_dir = direction_node.get_face_direction()
	
	# Play the animation
	animation_node.play(self.name)
	audio_node.play()
	
	# Apply the offset to the animation, and orient it the right way, depending of the direction the character is facing
	var current_anim_offset = animation_offset
	current_anim_offset.x *= face_dir
	animation_node.set_offset(current_anim_offset)
	
	hit_box_shape.set_disabled(false)

# When the actor exits action state: set unactive the hit box and triggers the interaction if necesary
func exit_state(_host):
	animation_node.set_offset(Vector2(0, 0))
	hit_box_shape.set_disabled(true)
	
	if interact_node in interact_able_array:
		interact_node.interact(hit_box_shape.global_position)

# When the animation is off, set the actor's state to Idle
func on_animation_finished():
	if state_node.current_state == self:
		state_node.set_state("Idle")
		animation_node.set_offset(Vector2(0, 0))

func on_LeftPressed():
	state_node.set_state("Move")

func on_RightPressed():
	state_node.set_state("Move")
