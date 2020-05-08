extends StateBase

class_name PlayerStateBase

var animation_node : AnimatedSprite
var state_node : Node

func setup():
	pass

# Play the animation with a name corresponding to the current state
func enter_state(_host):
	if animation_node != null:
		animation_node.play(self.name)
