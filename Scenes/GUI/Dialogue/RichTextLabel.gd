tool
extends RichTextLabel


func on_box_resized():
	var box_height = get_parent().get_rect().size.y
	var self_height = get_rect().size.y
	
	rect_position.y = box_height / 2 - self_height / 2
