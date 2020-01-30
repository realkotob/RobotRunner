extends StateBase

class_name PlayerStateBase

var animation_node : AnimatedSprite

func setup():
	pass

# Play the animation with a name corresponding to the current state
func enter_state(_host):
	if animation_node != null:
		animation_node.play(self.name)

func on_UpPressed():
	pass

func on_UpReleased():
	pass

func on_DownPressed():
	pass

func on_DownReleased():
	pass

func on_LeftPressed():
	pass

func on_LeftReleased():
	pass

func on_RightPressed():
	pass

func on_RightReleased():
	pass

func on_ActionPressed():
	pass

func on_ActionReleased():
	pass

func on_JumpPressed():
	pass

func on_JumpReleased():
	pass

func on_TeleportPressed():
	pass

func on_TeleportReleased():
	pass
