extends ActorStateBase
class_name BabyBotRiseState

#### ACCESSORS ####

func is_class(value: String): return value == "BabyBotJumpState" or .is_class(value)
func get_class() -> String: return "BabyBotJumpState"

#### BUILT-IN ####

func _ready():
	yield(owner, "ready")
	var _err = owner.animated_sprite_node.connect("animation_finished", self, "on_animation_finished")


func on_animation_finished():
	if states_machine.current_state == self:
		states_machine.set_state("Move")
