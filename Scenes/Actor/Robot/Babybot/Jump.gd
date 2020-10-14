extends ActorStateBase
class_name JumpBase

#### JUMP STATE ####

var animation_node : AnimatedSprite

func _ready():
	yield(owner, "ready")
	animation_node = owner.animated_sprite_node
	var _err = animation_node.connect("animation_finished", self, "on_animation_finished")


func update(_host, _delta):
	if owner.is_on_floor():
		return "Idle"
	if owner.velocity.y > 0:
		return "Fall"


func enter_state(_host):
	animation_node.play(self.name)
	
	owner.current_snap = Vector2.ZERO
	
	# Apply the jump force
	owner.set_velocity(Vector2(owner.get_velocity().x, owner.jump_force))


func on_animation_finished():
	if state_node.get_current_state() == self:
		if animation_node.get_animation() == "Jump":
			if "MidAir" in animation_node.get_sprite_frames().get_animation_names():
				animation_node.play("MidAir")
