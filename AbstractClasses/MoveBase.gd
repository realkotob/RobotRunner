extends PlayerStateBase

class_name MoveBase

### MOVE STATE ###

signal layer_change

var SFX_node : Node
var inputs_node : Node

func _ready():
	yield(owner, "ready")
	SFX_node = owner.get_node("SFX")
	inputs_node = owner.get_node("Inputs")
	var _err = connect("layer_change", owner, "on_layer_change")


func update(_host, _delta):
	if !owner.is_on_floor():
		return "Fall"
	elif owner.velocity.x == 0:
		return "Idle"


func enter_state(_host):
	if !owner.is_on_floor():
		state_node.set_state("Jump")
	
	owner.current_snap = owner.snap_vector
	animation_node.play(self.name)
	SFX_node.play_SFX("MoveDust", true)


func exit_state(_host):
	SFX_node.play_SFX("MoveDust", false)


# Define the actions the player can do in this state
func _input(event):
	if state_node.get_current_state() == self:
		if event.is_action_pressed(inputs_node.get_input("Jump")):
			state_node.set_state("Jump")
		
		elif event.is_action_pressed(inputs_node.get_input("Teleport")):
			emit_signal("layer_change")
		
		elif event.is_action_pressed(inputs_node.get_input("Action")):
			state_node.set_state("Action")

