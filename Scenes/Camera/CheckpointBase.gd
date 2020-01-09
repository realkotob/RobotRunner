extends Area2D

signal camera_entered_into_checkpoint
export var cp_dir : int

onready var game_camera_node = get_parent().get_child(0)

func _ready():
	var _err
	_err = connect("area_entered", self, "on_camera_entered_into_checkpoint")

func on_camera_entered_into_checkpoint(area):
	if area == game_camera_node.get_node("CheckPointTriggerZone"):
		emit_signal("camera_entered_into_checkpoint")

#func on_checkpoint_reached():
#	print(cp_dir, " / ", game_camera_node.cam_direction)
#	game_camera_node.cam_direction = cp_dir