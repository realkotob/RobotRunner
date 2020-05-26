extends StateBase

class_name PlayerStateBase

onready var animation_node : AnimatedSprite
onready var state_node : Node

func _ready():
	yield(owner, "ready")
	animation_node = owner.get_node("Animation")
	state_node = get_parent()

# Play the animation with a name corresponding to the current state
func enter_state(_host):
	if animation_node != null:
		animation_node.play(self.name)
