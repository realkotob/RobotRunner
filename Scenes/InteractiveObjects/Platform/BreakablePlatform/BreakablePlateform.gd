extends RigidBody2D

onready var area_node = $Area2D
onready var sprite_node = $Sprite
onready var animation_player_node = $AnimationPlayer

export (int, 1, 100) var nb_debris = 20

export var instant_break : bool = false
export (int, 1, 10) var nb_shake = 3

var destroyer : Node = null

func _ready():
	var _err = area_node.connect("body_entered", self, "on_body_entered")


func on_body_entered(body : Node):
	if body.is_class("Player"):
		destroyer = body
		if instant_break:
			destroy()
		else:
			animation_player_node.play("Shake")


func on_shake_finished():
	nb_shake -= 1
	if nb_shake <= 0:
		destroy()


func destroy():
	SFX.scatter_sprite(self, 20, 30)
	queue_free()
