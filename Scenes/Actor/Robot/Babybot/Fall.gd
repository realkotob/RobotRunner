extends ActorStateBase

#### FALL STATE ####

var animation_node : AnimatedSprite

func _ready():
	yield(owner, "ready")
	animation_node = owner.animated_sprite_node
	var _err = animation_node.connect("animation_finished", self, "on_animation_finished")
	
	
func update(_delta):
	if owner.is_on_floor():
		return "Idle"


func enter_state():
	.enter_state()
	owner.current_snap = Vector2.ZERO


# Triggers the fall animation when the start falling is over
func on_animation_finished():
	if states_machine.get_state() == self:
		if animated_sprite.get_animation() == "StartFalling":
				animated_sprite.play(self.name)
