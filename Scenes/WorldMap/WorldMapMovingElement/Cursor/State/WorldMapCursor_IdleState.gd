extends StateBase
class_name WorldMapCursor_IdleState

onready var variation_timer_node = $VariationTimer

export var lerp_duration : float = 0.4 

signal lerp_finished


#### ACCESSORS ####

func is_class(value: String): return value == "WorldMapCursor_IdleState" or .is_class(value)
func get_class() -> String: return "WorldMapCursor_IdleState"


#### BUILT-IN ####

func _ready() -> void:
	var __ = owner.connect("idle_animation_finished", self, "_on_idle_animation_finished")
	__ = variation_timer_node.connect("timeout", self, "_on_variation_timer_timeout")


#### VIRTUALS ####


func enter_state():
	trigger_idle_animation()
	variation_timer_node.start()


func exit_state():
	variation_timer_node.stop()

#### LOGIC ####

func trigger_idle_animation():
	lerp_arrow_offset(Vector2(-13, 0), lerp_duration)
	yield(self, "lerp_finished")

	lerp_arrow_offset(Vector2(-20, 0), lerp_duration)
	yield(self, "lerp_finished")
	
	owner.emit_signal("idle_animation_finished")


func lerp_arrow_offset(to: Vector2, duration: float):
	var tween = $Tween

	for child in owner.sprite_container.get_children():
		tween.interpolate_property(child, "offset",
			child.get_offset(), to, duration,
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	
	tween.start()

	yield(tween, "tween_all_completed")
	emit_signal("lerp_finished")


#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_idle_animation_finished():
	if states_machine.get_state() == self:
		trigger_idle_animation()

func _on_variation_timer_timeout():
	if states_machine.get_state() == self:
		states_machine.set_state("Rotate")
