extends ActorBase
class_name BabyBot

onready var bubble_scene = preload("res://Scenes/GUI/Bubble/Bubble.tscn")
export var action_name_bubble : String = ""

onready var animation_player_node = $AnimationPlayer

export var breakable_type_array : PoolStringArray = []

func _ready():
	var _err = animation_player_node.connect("animation_finished", self, "on_animation_finished")

func tuto_bubble():
	var input = get_reel_input(action_name_bubble)
	
	if action_name_bubble == "" or input == "":
		return
	
	var bubble_node = bubble_scene.instance()
	bubble_node.button_name = input
	bubble_node.set_position(Vector2(6, -28))
	call_deferred("add_child", bubble_node)


func on_animation_finished(anim_name: String):
	if anim_name == "Overheat":
		destroy()
