extends NinePatchRect

export var button_name : String = ""

var margin = Vector2(8, 8)

onready var button_node = $Button
onready var animation_player_node = $AnimationPlayer
onready var tween_node = $Tween

func _ready():
	appear()
	yield($Timer, "timeout")
	disappear()


func appear():
	button_node.set_modulate(Color.transparent)
	
	if button_name != "":
		button_node.set_text(button_name)
	
	# Fade in the bubble
	animation_player_node.play_backwards("Fade")
	
	# Resize the box dynamicly based on the button size
	tween_node.interpolate_property(self, "rect_size",
		Vector2(24, 24), button_node.get_size() + margin, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween_node.start()
	
	yield(tween_node, "tween_all_completed")
	
	button_node.get_node("AnimationPlayer").play_backwards("Fade")




func disappear():
	animation_player_node.play("Fade", -1, 3)
	
	yield(animation_player_node, "animation_finished")
	queue_free()
