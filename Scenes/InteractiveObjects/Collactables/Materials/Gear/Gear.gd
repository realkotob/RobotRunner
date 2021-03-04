extends Collectable
class_name Gear

#### ACCESSORS ####

func is_class(value: String): return value == "Gear" or .is_class(value)
func get_class() -> String: return "Gear"


#### BUILT-IN ####

func _ready() -> void:
	var _err = $RayCast.connect("target_found", self, "_on_raycast_target_found")
	
	
	if get_state_name() == "Collect" or default_state == "Collect":
		$AnimationPlayer.stop()
	else:
		$AnimationPlayer.play("Floating")

#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_follow_area_body_entered(body: PhysicsBody2D):
	if body is Player && get_state_name() != "Follow":
		$RayCast.search_for_target(body)

func _on_raycast_target_found(target: Node2D):
	follow(target)
