extends ActorStateBase
class_name BabyBotHiddenState

#### ACCESSORS ####

func is_class(value: String): return value == "BabyBotHiddenState" or .is_class(value)
func get_class() -> String: return "BabyBotHiddenState"


#### VIRTUALS ####

func enter_state():
	owner.set_visible(false)


func exit_state():
	owner.set_visible(true)
