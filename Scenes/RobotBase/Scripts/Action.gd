extends PlayerStateBase

### ACTION STATE  ###

export var animation_offset : Vector2

var hit_box_node : Area2D
var state_node : Node

func setup():
	var _err = animation_node.connect("animation_finished", self, "on_animation_finished")


# When the actor enters action state: set active the hit box, and play the right animation
func enter_state(_host):
	animation_node.play(self.name)
	animation_node.set_offset(animation_offset)
	hit_box_node.get_child(0).set_disabled(false)


# When the actor exits action state: set unactive the hit box
func exit_state(_host):
	animation_node.set_offset(Vector2(0, 0))
	hit_box_node.get_child(0).set_disabled(true)

# When the animation is off, set the actor's state to Idle
func on_animation_finished():
	if state_node.current_state == self:
		state_node.set_state("Idle")
