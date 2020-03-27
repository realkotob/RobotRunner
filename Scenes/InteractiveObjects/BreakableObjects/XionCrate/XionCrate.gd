extends BreakableObjectBase

class_name XionCrate

onready var sprites_group_node = $Sprites
onready var animation_player_node = $AnimationPlayer
onready var timer_node = $Timer
onready var base_anim_node = $Sprites/Base
onready var xion_explosion_node = $Sprites/XionExplosion
onready var flash_node = $Flash

var animated_sprite_node_array : Array


### TO BE LOADED IN A SINGLETON LATER ###
var xion_collactable = preload("res://Scenes/InteractiveObjects/Collactables/XionCollectable.tscn")

var actor_destroying : Node

export var hitpoint : int = 3

func _ready():
	var _err = timer_node.connect("timeout", self, "on_timer_timeout")
	_err = base_anim_node.connect("animation_finished", self, "on_sprite_animation_finished")
	_err = xion_explosion_node.connect("animation_finished", self, "on_explode_anim_finished")
	_err = xion_explosion_node.connect("frame_changed", self, "on_explode_anim_frame_changed")
	
	for child in sprites_group_node.get_children():
		if child.is_class("AnimatedSprite"):
			animated_sprite_node_array.append(child)


func get_class():
	return "XionCrate"

# Called by a character when its hitbox touches it
# Count the number of time the crate has been damaged
# If the hitpoints reaches 0 call the destroy method
func damage(actor_damaging: Node = null):
	hitpoint -= 1
	
	flash_node.play("Flash")
	
	if hitpoint == 0:
		destroy(actor_damaging)


# Function called to destroy an object
func destroy(actor: Node = null):
	timer_node.stop()
	
	# Hide every non-destruction related sprite
	hide_crate()
	
	# Play the explosion animation
	xion_explosion_node.set_visible(true)
	xion_explosion_node.play()
	
	actor_destroying = actor



# Called when the destruction happens, hide every non-destruction related sprite
func hide_crate():
	for sprite in animated_sprite_node_array:
		if sprite != xion_explosion_node:
			sprite.set_visible(false)


# Queue free this instance when the explosion animation is over
func on_explode_anim_finished():
	queue_free()


func on_explode_anim_frame_changed():
	if xion_explosion_node.get_frame() == 6:
		# Instanciate the xion collatable
		for _i in range(5):
			var xion_collactable_node = xion_collactable.instance()
			xion_collactable_node.position = global_position
			xion_collactable_node.aimed_character = actor_destroying
			owner.add_child(xion_collactable_node)


# Triggers every animation_sprite's animation
func start_sprite_anim():
	for anim in animated_sprite_node_array:
		anim.play()


# Triggers the vibration animation
func  start_vibrate_anim():
	animation_player_node.play("Vibrate", -1, rand_range(0.8, 1.2))


# Tiggers one of the two animations randomly and reset the timer to a random time
func on_timer_timeout():
	if randi() % 2 == 0:
		start_sprite_anim()
	else:
		start_vibrate_anim()
	
	timer_node.set_wait_time(rand_range(1.5, 3.0))


# Called when the sprite animation is over
# Reset every animated_sprite to its first frame 
func on_sprite_animation_finished():
	for anim in animated_sprite_node_array:
		anim.stop()
		anim.set_frame(0)
