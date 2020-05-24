extends Event

export var dialogue_index : int = -1
export var cut_scene : bool = false

func event():
	DIALOGUE.instanciate_dialogue_box(dialogue_index, cut_scene)
	queue_free()
