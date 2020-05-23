tool
extends RichTextLabel

var right_margin : int = 20


func _ready():
	rect_clip_content = false


func on_box_resized():
	var box_size = get_parent().get_rect().size
	var self_height = get_rect().size.y

	rect_position.y = box_size.y / 2 - self_height / 2

	var pos_x = rect_position.x
	rect_size.x = box_size.x - pos_x - right_margin

