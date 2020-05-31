extends StateBase
class_name ActorStateBase

onready var state_node = get_parent()

func update(_host : Node, _delta : float):
	pass

func enter_state(_host : Node):
	if owner.animated_sprite_node.get_sprite_frames().has_animation(name):
		owner.animated_sprite_node.play(name)

func exit_state(_host : Node):
	pass
