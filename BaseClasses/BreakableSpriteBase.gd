extends Sprite

class_name BreakableSpriteBase

var fading_out : bool = false setget set_fading_out, get_fading_out
export var fade_speed : float = 0.04

func _physics_process(_delta):
	if get_fading_out() == true:
		fade_out()

# Fade_out procedure
func fade_out():
	if get_modulate().a > 0:
		modulate.a -= fade_speed
	else:
		set_fading_out(false)


func set_fading_out(value : bool):
	fading_out = value
	set_physics_process(value) # Triggers the physic process (May be needed to be placed elsewhere later)


func get_fading_out() -> bool:
	return fading_out
