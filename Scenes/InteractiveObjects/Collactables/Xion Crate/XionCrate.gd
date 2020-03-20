extends StaticBody2D

onready var animation_player_node = $AnimationPlayer
onready var timer_node = $Timer
onready var base_anim_node = $Base

var animated_sprite_node_array : Array

func _ready():
	var _err = timer_node.connect("timeout", self, "on_timer_timeout")
	_err = base_anim_node.connect("animation_finished", self, "on_sprite_animation_finished")
	
	for child in get_children():
		if child.is_class("AnimatedSprite"):
			animated_sprite_node_array.append(child)


# Triggers every animation_sprite's animation
func start_sprite_anim():
	for anim in animated_sprite_node_array:
		anim.play()


# Triggers the vibration animation
func  start_vibrate_anim():
	animation_player_node.play("Vibrate", -1, rand_range(0.8, 1.2))


# Tiggers an animation and reset the timer to a random time
func on_timer_timeout():
	var rng = randi() % 2
	
	if rng == 0:
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
