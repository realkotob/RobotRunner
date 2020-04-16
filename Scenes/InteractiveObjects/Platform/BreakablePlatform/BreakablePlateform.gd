extends RigidBody2D

onready var area_node = $Area2D
onready var sprite_node = $Sprite

export (int, 1, 100) var nb_debris = 20

export var instant_break : bool = false

var destroyer : Node = null

func _ready():
	var _err = area_node.connect("body_entered", self, "on_body_entered")


func on_body_entered(body : Node):
	if body.is_class("Player"):
		body.set_state("Shock")
		destroyer = body
		destroy()


func destroy():
	destroyer.set_state("Idle")
	SFX.scatter_sprite(self, 20, 30)
	queue_free()

