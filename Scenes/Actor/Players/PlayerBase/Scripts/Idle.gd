extends PlayerStateBase

signal layer_change

### IDLE STATE ###

var SFX_node : Node
var inputs_node : Node

# Setup method
func _ready():
	yield(owner, "ready")
	SFX_node = owner.get_node("SFX")
	inputs_node = owner.get_node("Inputs")
	
	var _err
	_err = connect("layer_change", owner, "on_layer_change")
	_err = animation_node.connect("animation_finished", self, "on_animation_finished")


# Check if the character is falling, before it triggers fall state
func update(_host, _delta):
	if !owner.is_on_floor():
		return "Fall"

	# Chage state to move if the player is moving horizontaly
	var horiz_movement = owner.get_velocity().x
	if abs(horiz_movement) > 0.0 :
		state_node.set_state("Move")


# Triggers the Idle aniamtion when entering the state,
# If the character was falling before, triggers the landing animation before
func enter_state(host):
	if !owner.is_on_floor():
		host.set_state("Fall")
	
	var animations_array = animation_node.get_sprite_frames().get_animation_names()
	owner.current_snap = owner.snap_vector
	
	if host.previous_state != null && host.previous_state.name == "Fall" && "StartFalling" in animations_array:
		animation_node.play("Land")
	else:
		animation_node.play(self.name)


# Define the actions the player can do in this state
func _input(event):
	if !owner.active:
		return
	
	if state_node.get_current_state() == self:
		if event.is_action_pressed(inputs_node.get_input("Jump")):
			state_node.set_state("Jump")
		
		elif event.is_action_pressed(inputs_node.get_input("Teleport")):
			emit_signal("layer_change")
		
		elif event.is_action_pressed(inputs_node.get_input("Action")):
			state_node.set_state("Action")


# Triggers the idle animation when the slanding is over
func on_animation_finished():
	if state_node.get_current_state() == self:
		if animation_node.get_animation() == "Land":
				animation_node.play(self.name)
