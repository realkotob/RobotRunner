extends RobotFallState
class_name BabyBotFallState

var animation_node : AnimatedSprite

#### ACCESSORS ####

func is_class(value: String): return value == "BabyBotJumpState" or .is_class(value)
func get_class() -> String: return "BabyBotJumpState"


#### BUILT-IN ####

func _ready():
	yield(owner, "ready")
	animation_node = owner.animated_sprite_node
	var _err = animation_node.connect("animation_finished", self, "on_animation_finished")


#### VIRTUALS ####

func update_state(_delta):
	if owner.is_on_floor():
		return "Idle"


func enter_state():
	.enter_state()
	owner.current_snap = Vector2.ZERO


#### SIGNAL RESPONSES #### 
