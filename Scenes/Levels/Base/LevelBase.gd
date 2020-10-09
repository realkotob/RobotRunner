extends Node2D

class_name Level

const CLASS : String = "Level"

onready var xion_cloud_node = get_node_or_null("XionCloud")

var players_array : Array
var player_in_danger : bool = false
var players_exited : int = 0

signal level_finished

func is_class(value: String) -> bool:
	return value == CLASS

func get_class() -> String:
	return CLASS


func _ready():
	var _err = connect("level_finished", GAME, "on_level_finished")
	GAME.last_level_path = filename
	update_current_level_index()
	
	set_starting_points()
	instanciate_players()
	
	MUSIC.play()


func _process(_delta):
	MUSIC.adapt_music(xion_cloud_node, players_array, player_in_danger)


# Called by GAME when a player exited the level
# Update the players array, and the player_exited counter
func on_player_exited(player : PhysicsBody2D):
	players_exited += 1
	
	var player_index = players_array.find(player)
	if player_index != -1:
		players_array.remove(player_index)
	
	if players_exited == 2:
		emit_signal("level_finished")


func on_player_in_danger():
	player_in_danger = true


func on_player_out_of_danger():
	player_in_danger = false


# Load the last checkpoint visited and set the position accordingly,
# Also disable every uneeded checkpoint
func set_starting_points():
	var current_checkpoint = GAME.progression.checkpoint
	
	if current_checkpoint <= 0:
		return
	
	var checkpoint_array = get_node("Events/Checkpoints").get_children()
	var starting_point_array = get_tree().get_nodes_in_group("StartingPoint")
	
	# Place the starting position based on the last checkpoint visited
	var new_starting_point1 = checkpoint_array[current_checkpoint - 1].get_node("NewStartingPoint1")
	var new_starting_point2 = checkpoint_array[current_checkpoint - 1].get_node("NewStartingPoint2")
	
	starting_point_array[0].set_global_position(new_starting_point1.global_position)
	starting_point_array[1].set_global_position(new_starting_point2.global_position)
	
	# Set active every checkpoint before the current one (And also the current one)
	for i in range(current_checkpoint):
		checkpoint_array[i].set_active(true)


# Intanciate the players inside the level
#### TO BE REFACTO -- NEED TO BE DYNAMIC ####
func instanciate_players():
	# Get the players starting positions
	var player1_start_node = get_node_or_null("StartingPointP1")
	var player2_start_node = get_node_or_null("StartingPointP2")

	# Add the players scene to the level scene a the position of the start position
	if player1_start_node != null:
		var player1_start_pos = player1_start_node.get_global_position()
		var player1_node = GAME.player1.instance()
		player1_node.global_position = player1_start_pos
		player1_node.level_node = self
		add_child(player1_node)
		players_array.append(player1_node)
	
	if player2_start_node != null:
		var player2_start_pos = player2_start_node.get_global_position()
		var player2_node = GAME.player2.instance()
		player2_node.global_position = player2_start_pos
		player2_node.level_node = self
		add_child(player2_node)
		players_array.append(player2_node)



func update_current_level_index():
	var i = 0
	for level in GAME.level_array:
		if name in level._bundled["names"]:
			break
		i += 1
	
	GAME.progression.level = i
