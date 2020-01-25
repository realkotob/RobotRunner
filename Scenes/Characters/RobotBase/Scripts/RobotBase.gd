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

# Get every children of this node
onready var children_array : Array = get_children()

# Give every reference they need to children nodes
func _ready():
	for child in children_array:
		if "character_node" in child:
			child.character_node = self
		
		if "attributes_node" in child:
			child.attributes_node = attributes_node
		
		if "physic_node" in child:
			child.attributes_node = physic_node
		
		if "direction_node" in child:
			child.direction_node = direction_node
		
		if "inputs_node" in child:
			child.inputs_node = inputs_node
		
		if "layer_change_node" in child:
			child.layer_change_node = layer_change_node
		
		if "states_node" in child:
			child.states_node = states_node
		
		if "animation_node" in child:
			child.animation_node = animation_node
		
		if "hit_box_node" in child:
			child.hit_box_node = hit_box_node
	
	states_node.setup()
	inputs_node.connect_direction(direction_node)