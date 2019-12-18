extends PlayerStateBase

class_name MoveBase

### MOVE STATE ###

signal layer_change

onready var robot_node = get_parent().get_parent()
onready var states_node = get_parent()
onready var layerchange_node = get_node("../../LayerChange")
onready var attributes_node = get_node("../../Attributes")

func _ready():
	var _err = connect("layer_change", layerchange_node, "on_layer_change")

func update(_host, _delta):
	if !robot_node.is_on_floor():
		return "Fall"
	elif attributes_node.velocity.x == 0:
		return "Idle"

func on_JumpPressed():
	states_node.set_state("Jump")

func on_LayerUpPressed():
	emit_signal("layer_change", true)

func on_LayerDownPressed():
	emit_signal("layer_change", false)

func on_ActionPressed():
	states_node.set_state("Action")

func enter_state(_host):
	animation_node.play(self.name)
	if !robot_node.is_on_floor():
		states_node.set_state("Jump")