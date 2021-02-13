extends ActorStateBase
class_name ActorJumpState

### JUMP STATE ###

var SFX_node : Node


func _ready():
	yield(owner, "ready")
	SFX_node = owner.get_node_or_null("SFX")
	
	var _err = animated_sprite.connect("animation_finished", self, "on_animation_finished")


func update(_delta):
	if owner.is_on_floor():
		return "Idle"
	elif owner.velocity.y > 0:
		return "Fall"


func enter_state():
	.enter_state()
	
	# Genreate the jump dust
	if owner.is_on_floor() && SFX_node != null:
		SFX_node.play_SFX("JumpDust", true, owner.global_position)
	
	if owner.get("current_snap") != null:
		owner.current_snap = Vector2.ZERO
	
	# Apply the jump force
	owner.velocity.y = owner.jump_force


func exit_state():
	if SFX_node != null:
		SFX_node.play_SFX("JumpDust", false)
		SFX_node.reset_SFX("JumpDust")


func on_animation_finished():
	if states_machine.get_state() == self:
		if animated_sprite.get_animation() == "Jump":
			if "MidAir" in animated_sprite.get_sprite_frames().get_animation_names():
				animated_sprite.play("MidAir")

