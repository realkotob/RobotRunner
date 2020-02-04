extends PlayerStateBase

class_name ActionBase

### ACTION STATE  ###

var direction_node : Node
var interact_node : Node = null
var interact_able_array : Array
var character_node : KinematicBody2D

export var animation_offset : Vector2

var hit_box_node : Area2D
var state_node : Node
var hit_box_shape : Node
var face_dir : int

onready var audio_node = get_node("AudioStreamPlayer")

func setup():
	var _err = animation_node.connect("animation_finished", self, "on_animation_finished")
	hit_box_shape = hit_box_node.get_child(0)

func update(_host, _delta):
	offset_animation()

# When the actor enters action state: set active the hit box, and play the right animation, applying it the defind offset
func enter_state(_host):
	# Play the animation
	offset_animation()
	animation_node.play(self.name)
	audio_node.play()
	
	hit_box_shape.set_disabled(false)

# When the actor exits action state: set unactive the hit box and triggers the interaction if necesary
func exit_state(_host):
	hit_box_shape.set_disabled(true)
	animation_node.set_offset(Vector2(0, 0))
	
	if interact_node in interact_able_array:
		interact_node.interact(hit_box_shape.global_position)

# When the animation is off, set the actor's state to Idle
func on_animation_finished():
	if state_node.current_state == self:
		if character_node.is_on_floor():
			state_node.set_state("Idle")
		else:
			state_node.set_state("Fall")


func offset_animation():
	face_dir = direction_node.get_face_direction()
	
	# Apply the offset to the animation, and orient it the right way, depending of the direction the character is facing
	var current_anim_offset = animation_offset
	current_anim_offset.x *= face_dir
	if animation_node.get_offset() != current_anim_offset:
		animation_node.set_offset(current_anim_offset)


func on_LeftPressed():
	if character_node.is_on_floor():
		state_node.set_state("Move")


func on_RightPressed():
	if character_node.is_on_floor():
		state_node.set_state("Move")
