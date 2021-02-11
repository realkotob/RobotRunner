extends ActorStateBase

#### RISE STATE ####

func _ready():
	yield(owner, "ready")
	var _err = owner.animated_sprite_node.connect("animation_finished", self, "on_animation_finished")


func on_animation_finished():
	if states_machine.current_state == self:
		states_machine.set_state("Move")
