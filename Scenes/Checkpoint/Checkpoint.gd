extends Area2D


func _ready():
	var _err = connect("body_entered", self, "on_body_entered")


func on_body_entered(body : Node):
	if body.is_class("Player"):
		GAME.progression.checkpoint += 1
		var collision_shape_node = $CollisionShape2D
		collision_shape_node.call_deferred("set_disabled", true)
