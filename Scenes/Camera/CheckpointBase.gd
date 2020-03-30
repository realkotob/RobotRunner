extends Area2D

signal camera_reached_checkpoint
export var cp_dir : Vector2
export var is_enabled : bool = true
export var Camera_Zoom := Vector2.ONE

onready var game_camera_node = get_parent().get_child(0)
onready var checkpoint_area = get_node("CollisionShape2D")

signal cp_switch_state

func _ready():
	var _err
	_err = connect("area_entered", self, "on_area_entered")
	if(!is_enabled):
		checkpoint_area.disabled = true


# When the camera reach this checkpoint, send it the direction it must take
func on_area_entered(area):
	if area == game_camera_node.get_node("CheckPointTriggerZone"):
		emit_signal("camera_reached_checkpoint", cp_dir, Camera_Zoom)
		if len(get_signal_connection_list("cp_switch_state")) > 0:
			emit_signal("cp_switch_state")


func _on_CameraChekpoint4_cp_switch_state():
	is_enabled = true
	checkpoint_area.call_deferred("set", "disabled", false)
