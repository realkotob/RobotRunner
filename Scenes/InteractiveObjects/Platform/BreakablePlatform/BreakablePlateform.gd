extends RigidBody2D

onready var area_node = $Area2D
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
	queue_free()
