extends CollactableBase

onready var timer_node = $Timer
onready var animated_sprite_node = $AnimatedSprite

func _ready():
	var _err = timer_node.connect("timeout", self, "on_timer_timeout")
	_err = animated_sprite_node.connect("animation_finished", self, "on_animation_finished")


func on_timer_timeout():
	animated_sprite_node.play()
	timer_node.start()


func on_animation_finished():
	animated_sprite_node.set_frame(0)
	animated_sprite_node.stop()
