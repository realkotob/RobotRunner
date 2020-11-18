extends Node2D
class_name LevelChunck

signal new_chunck_reached


#### ACCESSORS ####

func is_class(value: String):
	return value == "LevelChunck" or .is_class(value)

func get_class() -> String:
	return "LevelChunck"

#### BUILT-IN ####

func _ready():
	var _err = $Area2D.connect("body_entered", self, "on_body_entered")

#### LOGIC ####



#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####


func on_body_entered(body: PhysicsBody2D):
	if body is Player:
		emit_signal("new_chunck_reached")
		$Area2D.queue_free()
