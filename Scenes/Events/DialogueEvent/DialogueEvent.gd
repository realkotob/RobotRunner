extends Event

export var dialogue_index : int = -1

func event():
	DIALOGUE.instanciate_dialogue_box(dialogue_index)
	queue_free()
