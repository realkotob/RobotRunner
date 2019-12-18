extends PlayerStateBase

### ACTION STATE  ###

onready var hit_box = get_parent().get_parent().get_node("HitBox/CollisionShape2D")
onready var state_node = get_parent()

func _ready():
	var _err = animation_node.connect("animation_finished", self, "on_animation_finished")

func enter_state(_host):
	animation_node.play(self.name)
	hit_box.set_disabled(false)
	

func exit_state(_host):
	hit_box.set_disabled(true)

func on_animation_finished():
	if state_node.current_state == self:
		state_node.set_state("Idle")
