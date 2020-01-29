extends Sprite

onready var timer_node : Timer = get_node("Timer")
onready var label_node : Label = get_node("Label")
onready var main_node = get_tree().get_root().get_node("Main")

var camera_node : Camera2D
var player_node : Node

var screen_width : float = ProjectSettings.get("display/window/size/width")
var screen_height : float = ProjectSettings.get("display/window/size/height")

signal gameover

export var margin := Vector2(40, 10)
onready var text_margin : Vector2 = label_node.rect_position


func _ready():
	var _err
	_err = connect("gameover", main_node, "on_gameover")
	_err = timer_node.connect("timeout", self, "on_timer_timeout")
	_err = camera_node.connect("player_inside_screen", self, "on_player_inside_screen")
	timer_node.start()


func _physics_process(_delta):
	if player_node != null:
		
		# Adapt the position of the countdown to the player's position
		var player_pos = player_node.position
		var current_offset := Vector2(0,0)
		var current_text_offset := Vector2(0,0)
		
		if is_player_left_from_screen() or is_player_right_from_screen():
			if is_player_right_from_screen():
				current_offset.x = -margin.x
				current_text_offset.x = text_margin.x * 3.7
			else:
				current_offset.x = margin.x
				current_text_offset.x = text_margin.x
				
			position.x = (is_player_right_from_screen() as int) * screen_width + current_offset.x
			label_node.rect_position.x = current_text_offset.x
			position.y = player_pos.y - margin.y
			set_flip_h(is_player_right_from_screen()) 
			
		elif is_player_below_screen() or is_player_above_screen():
			if is_player_below_screen():
				current_offset.y = -margin.y
				current_text_offset.y = text_margin.y * 3.7
				label_node.set_rotation(1.5708)
			else:
				current_offset.y = margin.y
				current_text_offset.y = text_margin.y
				label_node.set_rotation(-1.5708)
			
			position.y = (is_player_below_screen() as int) * screen_height + current_offset.y
			label_node.rect_position.x = current_text_offset.x
			position.x = player_pos.x + margin.x
		
		label_node.text = String((timer_node.get_time_left() + 1) as int)


# Check if the player is outside the screen from left side
func is_player_left_from_screen():
	return  player_node.position.x < camera_node.position.x - (screen_width / 2)


# Check if the player is outside the screen from right side
func is_player_right_from_screen():
	return  player_node.position.x > camera_node.position.x + (screen_width / 2)

# Check if the player is below screen
func is_player_below_screen():
	return  player_node.position.y > camera_node.position.y - (screen_height / 2)

# Check if the player is below screen
func is_player_above_screen():
	return  player_node.position.y < camera_node.position.y + (screen_height / 2)


func on_timer_timeout():
	emit_signal("gameover")


func on_player_inside_screen(player):
	if player == player_node:
		queue_free()