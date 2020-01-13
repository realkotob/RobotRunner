extends Area2D

signal camera_reached_checkpoint
export var cp_dir : Vector2

onready var game_camera_node = get_parent().get_child(0)

func _ready():
	var _err
	_err = connect("area_entered", self, "on_area_entered")


# When the camera reach this checkpoint, send it the direction it must take
func on_area_entered(area):
	if area == game_camera_node.get_node("CheckPointTriggerZone"):
		emit_signal("camera_reached_checkpoint", cp_dir)