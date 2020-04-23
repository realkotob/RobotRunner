extends BreakableObjectBase

onready var area_node = $Area2D
onready var animation_player_node = $AnimationPlayer

export var instant_break : bool = false
export (int, 1, 10) var nb_shake = 3

func _ready():
	var _err = area_node.connect("body_entered", self, "on_body_entered")
	awake_area_node = area_node


func on_body_entered(body : Node):
	if body.is_class("Player"):
		if instant_break:
			destroy()
		else:
			animation_player_node.play("Shake")


func on_shake_finished():
	nb_shake -= 1
	if nb_shake <= 0:
		destroy()
