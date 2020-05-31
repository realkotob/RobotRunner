extends ActorBase
class_name BabyBot

onready var bubble_scene = preload("res://Scenes/GUI/Bubble/Bubble.tscn")
export var action_name_bubble : String = ""

export var breakable_type_array : PoolStringArray = []

func tuto_bubble():
	var input = get_reel_input(action_name_bubble)
	
	if action_name_bubble == "" or input == "":
		return
	
	var bubble_node = bubble_scene.instance()
	bubble_node.button_name = input
	bubble_node.set_position(Vector2(6, -28))
	call_deferred("add_child", bubble_node)
