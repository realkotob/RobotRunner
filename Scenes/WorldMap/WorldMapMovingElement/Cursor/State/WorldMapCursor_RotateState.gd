extends StateBase
class_name WorldMapCursor_RotateState


#### ACCESSORS ####

func is_class(value: String): return value == "WorldMapCursor_RotateState" or .is_class(value)
func get_class() -> String: return "WorldMapCursor_RotateState"


#### BUILT-IN ####

func _ready() -> void:
	var __ = owner.connect("rotation_animation_finished", self, "_on_rotation_animation_finished")

#### VIRTUALS ####


func enter_state():
	if states_machine.previous_state.name == "Idle":
		yield(owner, "idle_animation_finished")
	
	trigger_quarter_turn_rotation()


#### LOGIC ####

func trigger_quarter_turn_rotation():
	var tween = $Tween
	
	var current_rot = owner.sprite_container.get_rotation_degrees()
	
	tween.interpolate_property(owner.sprite_container, "rotation_degrees",
		current_rot, current_rot + 90, 0.4,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	
	tween.start()
	
	yield(tween, "tween_all_completed")
	owner.emit_signal("rotation_animation_finished")


#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_rotation_animation_finished():
	if is_current_state():
		states_machine.set_state(states_machine.previous_state)
