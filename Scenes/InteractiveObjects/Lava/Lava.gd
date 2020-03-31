extends Area2D

func _ready():
	var _err = connect("body_entered", self, "on_body_entered")


func on_body_entered(body):
	if body.is_class("Player"):
		body.destroy()
