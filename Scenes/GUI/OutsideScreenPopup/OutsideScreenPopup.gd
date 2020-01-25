extends TextureRect

onready var timer_node : Timer = get_node("Timer")
onready var label_node : Label = get_node("Label")
onready var main_node = get_tree().get_root().get_node("Main")

var camera_node : Camera2D
var player_node : Node

signal gameover

var offset := Vector2(8, 20)


func _ready():
	var _err
	_err = connect("gameover", main_node, "on_gameover")
	_err = timer_node.connect("timeout", self, "on_timer_timeout")
	_err = camera_node.connect("player_inside_screen", self, "on_player_inside_screen")
	timer_node.start()


func _physics_process(_delta):
	if player_node != null:
		rect_position.y = player_node.position.y - offset.y
		label_node.text = String((timer_node.get_time_left() + 1) as int)


func on_timer_timeout():
	emit_signal("gameover")


func on_player_inside_screen(player):
	if player == player_node:
		queue_free()