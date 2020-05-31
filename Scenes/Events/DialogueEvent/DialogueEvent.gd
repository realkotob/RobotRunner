extends LevelEvent
class_name DialogueEvent

export var dialogue_index : int = -1
export var cut_scene : bool = false

func event():
	DIALOGUE.instanciate_dialogue_box(dialogue_index, cut_scene)
	if target_name != "" && method_name != "":
		method_call()
	queue_free()