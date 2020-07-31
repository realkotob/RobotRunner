extends BreakableObjectBase

onready var area_node = $Area2D
onready var animation_player_node = $AnimationPlayer

export var instant_break : bool = false
export (int, 1, 10) var nb_shake = 3

var track_actor : bool = false

func _ready():
	var _err = area_node.connect("body_entered", self, "on_body_entered")
	awake_area_node = area_node


func _physics_process(_delta):
	if track_actor == true:
		actor_tracking()


func on_body_entered(body : Node):
	if body is ActorBase:
		track_actor = true


func find_actor_in_array(array: Array) -> Array:
	var actor_array : Array = []
	for body in array:
		if body is ActorBase:
			actor_array.append(body)
	return actor_array


func actor_tracking():
	var actors_array = find_actor_in_array(area_node.get_overlapping_bodies())
	
	if actors_array != []:
		for actors in actors_array:
			var extents = actors.get_extents()
			
			if actors.is_on_floor() and actors.global_position.y <= global_position.y - extents.y:
				if instant_break:
					destroy()
				else:
					animation_player_node.play("Shake")
	else:
		track_actor = false


func on_shake_finished():
	nb_shake -= 1
	if nb_shake <= 0:
		destroy()
