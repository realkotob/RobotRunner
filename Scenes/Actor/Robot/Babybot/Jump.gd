extends ActorStateBase
class_name JumpBase

#### JUMP STATE ####

func _ready():
	yield(owner, "ready")
	var _err = animated_sprite.connect("animation_finished", self, "on_animation_finished")


func update(_delta):
	if owner.is_on_floor():
		return "Idle"
	if owner.velocity.y > 0:
		return "Fall"


func enter_state():
	animated_sprite.play(self.name)
	
	owner.current_snap = Vector2.ZERO
	
	# Apply the jump force
	owner.set_velocity(Vector2(owner.get_velocity().x, owner.jump_force))


func on_animation_finished():
	if states_machine.get_state() == self:
		if animated_sprite.get_animation() == "Jump":
			if "MidAir" in animated_sprite.get_sprite_frames().get_animation_names():
				animated_sprite.play("MidAir")
