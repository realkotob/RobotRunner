extends ActorStateBase
class_name ActorActionState

### ACTION STATE  ###

var interact_able_array : Array

export var breakable_type_array : PoolStringArray
export var interactables : PoolStringArray

var action_hitbox_node : Area2D
var hit_box_shape : Node

var has_damaged : bool = false

onready var audio_node = get_node_or_null("AudioStreamPlayer")

# Setup, called by the parent when it is ready
func _ready():
	yield(owner, "ready")
	
	action_hitbox_node = owner.get_node("ActionHitBox")
	var _err = animated_sprite.connect("animation_finished", self, "on_animation_finished")
	hit_box_shape = action_hitbox_node.get_node("CollisionShape2D")


func update(_delta):
	if !has_damaged:
		damage()


# When the actor enters action state: set active the hit box, and play the right animation
func enter_state():
	if not owner is Player:
		owner.set_direction(0)
	
	# Play the animation
	animated_sprite.play(self.name)
	
	# Play the audio
	if audio_node != null:
		audio_node.play()
	
	# Set the hitbox active
	hit_box_shape.set_disabled(false)


# When the actor exits action state: set unactive the hit box and triggers the interaction if necesary
func exit_state():
	interact()
	
	# Reset the was broke bool, for the next use of the action state
	has_damaged = false
	
	# Set the hitbox inactive
	hit_box_shape.set_disabled(true)


# Damage a block if it is in the hitbox area, and if his type correspond to the current robot breakable type
func damage():
	var bodies_in_hitbox = action_hitbox_node.get_overlapping_bodies()
	for body in bodies_in_hitbox:
		if body.get_class() in owner.breakable_type_array:
			var average_pos = (body.global_position + action_hitbox_node.global_position) / 2
			damage_body(body, average_pos)
			has_damaged = true


func interact():
	# Check if the actor has already has damaged something 
	# (meaning it can't interact this time)
	if has_damaged: return
	
	# Get every area in the hitbox area
	var interact_areas = action_hitbox_node.get_overlapping_areas()
	
	# Check if one on the areas in the hitbox area is an interative one, and interact with it if it is
	# Also verify if no block were broke in this use of the action state
	for area in interact_areas:
		if area.get_class() in interactables:
			area.interact(hit_box_shape.global_position)



# If the raycast found no obstacle in its way, damage the targeted body
func damage_body(body : PhysicsBody2D, impact_pos: Vector2):
	body.damage(owner)
	EVENTS.emit_signal("play_SFX", "great_hit", impact_pos)
	has_damaged = true


# When the animation is off, set the actor's state to Idle
func on_animation_finished():
	if states_machine.current_state == self:
		if owner.is_on_floor():
			states_machine.set_state("Idle")
		else:
			states_machine.set_state("Fall")
