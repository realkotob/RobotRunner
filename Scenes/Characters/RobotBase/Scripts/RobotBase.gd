extends KinematicBody2D

class_name Player

# Store all the children references
onready var attributes_node = get_node("Attributes")
onready var physic_node = get_node("Physic")
onready var direction_node = get_node("Direction")
onready var inputs_node = get_node("Inputs")
onready var layer_change_node = get_node("LayerChange")
onready var states_node = get_node("States")
onready var animation_node = get_node("Animation")
onready var hit_box_node = get_node("HitBox")
onready var SFX_node = get_node("SFX")
onready var anim_player_node = get_node("AnimationPlayer")

var level_node : Node

# Get every children of this node
onready var children_array : Array = get_children()

# Class accesors
func is_class(value: String):
	return value == "Player"

func get_class() -> String:
	return "Player"


func _ready():
	var _err = anim_player_node.connect("animation_finished", self, "on_animation_finished")
	add_to_group("Players")

# Give every reference they need to children nodes, and then call heir setup method if it possesses it
func setup():
	for child in children_array:
		if "character_node" in child:
			child.character_node = self
		
		if "attributes_node" in child:
			child.attributes_node = attributes_node
		
		if "physic_node" in child:
			child.physic_node = physic_node
		
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
		
		if "SFX_node" in child:
			child.SFX_node = SFX_node
		
		if child.has_method("setup"):
			child.setup()


func on_xion_received():
	anim_player_node.play("MagentaFlash")


func set_state(value : String):
	states_node.set_state(value)


# Triggers the overheat animation
# Called by the cloud when a player enters it
func overheat():
	anim_player_node.play("Overheat")

# Triggers the fadeOut animation
# Called by the greatdoor when a player exit the level
func fade_out():
	anim_player_node.play("FadeOut")


# Stops the overheat animation
func stop_overheat():
	var anim : String = anim_player_node.get_current_animation()
	if anim == "Overheat":
		anim_player_node.play("Default")


# Triggers the explosion and the destruction of the robot
func on_animation_finished(animation: String):
	if animation == "Overheat":
		destroy()
	if animation == "Fadeout":
		queue_free()


func destroy():
	var explosion = SFX.normal_explosion.instance()
	explosion.set_global_position(global_position)
	SFX.add_child(explosion)
	explosion.play_animation()
	GAME.gameover()
	queue_free()
