extends PlayerStateBase

### JUMP STATE ###

onready var character_node = get_parent().get_parent()
onready var attributes_node = get_parent().get_parent().get_node("Attributes")
onready var states_node = get_parent()

func update(_host, _delta):
	if character_node.is_on_floor():
		return "Idle"
	elif attributes_node.velocity.y > 0:
		return "Fall"

func enter_state(_host):
	animation_node.play(self.name)
	attributes_node.velocity.y = attributes_node.jump_force

func on_ActionPressed():
	states_node.set_state("Action")