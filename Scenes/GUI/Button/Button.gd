extends NinePatchRect

func set_text(text: String):
	if text.length() != 1:
		_set_size(Vector2(16 + 8 * text.length(), 16))
	$Label.set_text(text)
