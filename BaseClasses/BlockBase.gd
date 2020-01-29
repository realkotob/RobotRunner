extends RigidBody2D

class_name BlockBase

onready var animation_node = get_node("Sprite")
onready var collision_shape_node = get_node("CollisionShape2D")
onready var audio_node = get_node("AudioStreamPlayer")
onready var timer_node = get_node("Timer")

# Connect signals
func _ready():
	add_to_group("InteractivesObjects")
	animation_node.connect("frame_changed", self, "_on_frame_changed")
	animation_node.connect("animation_finished", self, "_on_animation_finished")
	timer_node.connect("timeout", self, "on_timeout")

# When the block is destroyed, lauch the destroy animation
func destroy():
	animation_node.play()
	audio_node.play()

# When the destroy annimation is finished start the countdown
func _on_animation_finished():
	timer_node.start()

# When the countdown is over, destroy the block
func on_timeout():
	queue_free()

# When the animtion is at its middle frame, disable its hitbox
func _on_frame_changed():
	if(animation_node.frame >= 1):
		collision_shape_node.call_deferred("set", "disabled", true)
		set_mode(MODE_STATIC)
