extends StateBase
class_name ActorStateBase

func update(_host : Node, _delta : float):
	pass

func enter_state(_host : Node):
	if owner.animated_sprite.get_sprite_frames().has_animation(name):
		owner.animated_sprite.play(name)

func exit_state(_host : Node):
	pass
