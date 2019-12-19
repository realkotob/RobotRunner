extends KinematicBody2D


# Store all the children references
onready var attributes_node = get_node("Attributes")
onready var physic_node = get_node("Physic")
onready var direction_node = get_node("Direction")
onready var inputs_node = get_node("Inputs")
onready var layer_change_node = get_node("LayerChange")
onready var states_node = get_node("States")
onready var animation_node = get_node("Animation")
onready var hit_box_node = get_node("HitBox")

# Give every reference they need to children nodes
func _ready():
	setup_physic_node()
	setup_inputs_node()
	setup_layer_change_node()
	setup_states_node()


# Give to the physic node, every node references it needs
func setup_physic_node():
	physic_node.attributes_node = attributes_node
	physic_node.character_node = self
	physic_node.direction_node = direction_node
	physic_node.animation_node = animation_node
	physic_node.hit_box_node = hit_box_node


# Give to the inputs node, every node references it needs
func setup_inputs_node():
	inputs_node.connect_direction(direction_node)


# Give to the layer change node, every node references it needs
func setup_layer_change_node():
	layer_change_node.character_node = self


# Give to the layer change node, every node references it needs
func setup_states_node():
	states_node.inputs_node = inputs_node
	states_node.attributes_node = attributes_node
	states_node.character_node = self
	states_node.layer_change_node = layer_change_node
	states_node.hit_box_node = hit_box_node
	states_node.animation_node = animation_node
	states_node.setup()