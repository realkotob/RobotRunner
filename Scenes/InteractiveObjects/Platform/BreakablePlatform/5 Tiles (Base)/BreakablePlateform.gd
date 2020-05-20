extends BreakableObjectBase

onready var area_node = $Area2D
onready var animation_player_node = $AnimationPlayer

export var instant_break : bool = false
export (int, 1, 10) var nb_shake = 3

var track_player : bool = false

func _ready():
	var _err = area_node.connect("body_entered", self, "on_body_entered")
	awake_area_node = area_node


func _physics_process(_delta):
	if track_player == true:
		player_tracking()


func on_body_entered(body : Node):
	if body is Player:
		track_player = true


func find_player_in_array(array: Array) -> Array:
	var player_array : Array = []
	for body in array:
		if body is Player:
			player_array.append(body)
	return player_array


func player_tracking():
	var players_array = find_player_in_array(area_node.get_overlapping_bodies())
	
	if players_array != []:
		for player in players_array:
			var extents = player.get_extents()
			
			if player.global_position.y <= global_position.y - extents.y:
				if instant_break:
					destroy()
				else:
					animation_player_node.play("Shake")
	else:
		track_player = false


func on_shake_finished():
	nb_shake -= 1
	if nb_shake <= 0:
		destroy()
