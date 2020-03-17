extends Node2D

onready var timer_node : Timer = get_node("Timer")
onready var label_node : Label = get_node("Label")
onready var sprite_node : Label = get_node("Sprite")
onready var game_node = get_tree().get_root().get_node("Game")

var camera_node : Camera2D
var player_node : Node

var screen_width : float = ProjectSettings.get("display/window/size/width")
var screen_height : float = ProjectSettings.get("display/window/size/height")

signal gameover

export var margin : int = 45

func _ready():
	var _err
	_err = connect("gameover", game_node, "on_gameover")
	_err = timer_node.connect("timeout", self, "on_timer_timeout")
	_err = camera_node.connect("player_inside_screen", self, "on_player_inside_screen")
	timer_node.start()


func _physics_process(_delta):
	if player_node != null:
		adjust_position()
		label_node.text = String((timer_node.get_time_left() + 1) as int)


# Adapt the position of the countdown to the player's position, and clamp it to the screen frame
func adjust_position():
		var player_rel_pos = player_node.global_position - camera_node.global_position
		
		position.x = clamp(player_rel_pos.x + screen_width / 2, margin, screen_width - margin)
		position.y = clamp(player_rel_pos.y + screen_height / 2, margin, screen_height - margin)
		
		# Set to rotation so the tip always point towards the player 
		sprite_node.set_rotation(player_rel_pos.angle() + deg2rad(180))


# Emit the signal triggering the game over
func on_timer_timeout():
	emit_signal("gameover")


# Destroy this instance if the player get back inside the screen
func on_player_inside_screen(player):
	if player == player_node:
		queue_free()
