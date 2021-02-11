extends StateBase
class_name CameraState

onready var debug_layer = get_node_or_null("DebugLayer")

var camera : GameCamera
var screen_size : Vector2

#### ACCESSORS ####

func is_class(value: String): return value == "CameraState" or .is_class(value)
func get_class() -> String: return "CameraState"


#### BUILT-IN ####

func _ready():
	yield(owner, "ready")
	camera = owner
	screen_size = get_viewport().get_size() / 2

#### VIRTUALS ####


func enter_state():
	if camera.is_debug():
		set_debug_panel_visible(true)


func exit_state():
	if camera.is_debug():
		set_debug_panel_visible(false)


#### LOGIC ####

func set_debug_panel_visible(value: bool):
	if debug_layer != null:
		for child in debug_layer.get_children():
			child.set_visible(value)

#### INPUTS ####



#### SIGNAL RESPONSES ####
