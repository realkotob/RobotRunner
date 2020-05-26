extends ActorStateBase

var animated_sprite_node : AnimatedSprite

func _ready():
	yield(owner, "ready")
	animated_sprite_node = owner.animated_sprite_node
	
	var _err = animated_sprite_node.connect("animation_finished", self, "on_animation_finished")


func enter_state(_host):
	if animated_sprite_node.get_sprite_frames().has_animation(name):
		animated_sprite_node.play(name)
	
	for body in $HitBox.get_overlapping_bodies():
		if body is IceBlock:
			body.destroy()


func on_animation_finished():
	if states_node.current_state == self:
		states_node.set_state(states_node.previous_state)
