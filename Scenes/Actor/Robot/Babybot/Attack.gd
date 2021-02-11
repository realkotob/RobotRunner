extends ActorStateBase

#### ATTACK STATE ####

onready var hitbox_node = owner.get_node("HitBox")
var animated_sprite_node : AnimatedSprite

func _ready():
	yield(owner, "ready")
	animated_sprite_node = owner.animated_sprite_node
	
	var _err = animated_sprite_node.connect("animation_finished", self, "on_animation_finished")


func enter_state():
	owner.set_direction(0)
	
	if animated_sprite_node.get_sprite_frames().has_animation(name):
		animated_sprite_node.play(name)
	
	for body in hitbox_node.get_overlapping_bodies():
		if body.get_class() in owner.breakable_type_array:
			body.destroy()


func on_animation_finished():
	if states_machine.current_state == self:
		states_machine.set_state(states_machine.previous_state)
