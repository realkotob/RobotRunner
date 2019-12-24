extends PlayerStateBase

class_name ActionBase

### ACTION STATE  ###

var direction_node : Node
var interact_node : Node = null
var interact_able_array : Array

export var animation_offset : Vector2

var hit_box_node : Area2D
var state_node : Node

func setup():
	var _err = animation_node.connect("animation_finished", self, "on_animation_finished")

# When the actor enters action state: set active the hit box, and play the right animation, applying it the defind offset
func enter_state(_host):
	var face_dir = direction_node.get_face_direction()
	
	animation_node.play(self.name)
	animation_node.set_offset(animation_offset * face_dir)
	
	
	hit_box_node.get_child(0).set_disabled(false)

# When the actor exits action state: set unactive the hit box and triggers the interaction if necesary
func exit_state(_host):
	var hit_box_shape = hit_box_node.get_child(0)
	
	animation_node.set_offset(Vector2(0, 0))
	hit_box_shape.set_disabled(true)
	
	if interact_node in interact_able_array:
		interact_node.interact(hit_box_node.global_position)

# When the animation is off, set the actor's state to Idle
func on_animation_finished():
	if state_node.current_state == self:
		state_node.set_state("Idle")
