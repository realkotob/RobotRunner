extends RayCast2D

class_name RayCastBase

# Abstract class for a basic raycast, Searching for a specific target until it find it
# the signal target_found usually connected by it's parent is emitted whenever
# the first body found by the raycast is the target

signal target_found

export var oneshot : bool = false
var cast_target : Node = null 

func _ready():
	set_activate(false)


# Activate the ray cast, until it find a specific target
func search_for_target(target : Node, once: bool = false):
	if cast_target == null:
		return
	cast_target = target
	oneshot = once
	set_activate(true)


func set_activate(value: bool):
	set_enabled(value)
	set_physics_process(value)
	cast_target = null


func _physics_process(_delta):
	if cast_target == null:
		set_activate(false)
		return
	
	var dir = global_position.direction_to(cast_target.global_position)
	var dist = global_position.distance_to(cast_target.global_position)
	var relative_target_pos = dir * dist
		
	set_cast_to(relative_target_pos)
	var collider = get_collider()
		
	if collider == cast_target:
		var collision_point = get_collision_point()
		emit_signal("target_found", cast_target, collision_point)
	
	if oneshot:
		queue_free()
	else:
		set_activate(false)
