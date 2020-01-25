extends AnimatedSprite

const NORMAL = "fff"
const BLUE = Color(0, 0.2, 0.8, 0.3)

func change_color(in_water: bool):
	if in_water == true:
		set_modulate(BLUE)
	else:
		set_modulate(NORMAL)