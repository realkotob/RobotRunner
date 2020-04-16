extends Label

export var increment_offset : int = 5

var current_value : int = 0
var aimed_value : int = 0

func _ready():
	var _err = SCORE.connect("xion_changed", self, "on_score_xion_changed")
	set_physics_process(false)


func _physics_process(_delta):
	if current_value < aimed_value:
		current_value += increment_offset
		if current_value > aimed_value:
			current_value = aimed_value
			
		text = current_value as String
	
	if current_value == aimed_value:
		set_physics_process(false)


# Called when the xion score change
func on_score_xion_changed(value: int):
	aimed_value = value
	set_physics_process(true)
