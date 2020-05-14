extends CollactableBase

onready var timer_node = $Timer
onready var animated_sprite_node = $AnimatedSprite
onready var trigger_area_node = $TriggerArea

func _ready():
	var _err = timer_node.connect("timeout", self, "on_timer_timeout")
	_err = animated_sprite_node.connect("animation_finished", self, "on_animation_finished")
	_err = trigger_area_node.connect("body_entered", self, "on_trigger_area_body_entered")

func on_timer_timeout():
	animated_sprite_node.play()
	timer_node.start()


func on_animation_finished():
	animated_sprite_node.set_frame(0)
	animated_sprite_node.stop()


func on_trigger_area_body_entered(body: PhysicsBody2D):
	if body is Player:
		aimed_character_weakref = weakref(body)


func collect():
	call_deferred("set_monitoring", false)
	animated_sprite_node.set_visible(false)
	$CollectSound.play()
	$TravellingSound.stop()
	SCORE.set_materials(SCORE.get_materials() + 1)
