extends RigidBody2D

class_name BlockBase

onready var animation_node = get_node("Sprite")
onready var collision_shape_node = get_node("CollisionShape2D")
onready var audio_node = get_node("AudioStreamPlayer")

# Connect signals
func _ready():
	animation_node.connect("frame_changed", self, "_on_frame_changed")
	animation_node.connect("animation_finished", self, "_on_animation_finished")

# When the block is destroyed, lauch the destroy animation
func destroy():
	animation_node.play()
	audio_node.play()

# When the destroy annimation is finished queue_free this block
func _on_animation_finished():
	queue_free()

# When the animtion is at its middle frame, disable its hitbox
func _on_frame_changed():
	if(animation_node.frame >= 1):
		collision_shape_node.call_deferred("set", "disabled", true)
