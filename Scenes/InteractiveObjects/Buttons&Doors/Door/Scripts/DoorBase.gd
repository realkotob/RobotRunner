extends StaticBody2D

onready var animation_node = get_node("Animation")
onready var collision_node = get_node("CollisionShape2D")
onready var audio_node = get_node("AudioStreamPlayer")

func on_button_trigger():
	animation_node.play("default")
	collision_node.set_disabled(true)
	audio_node.play()