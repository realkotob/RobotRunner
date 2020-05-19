extends NinePatchRect

onready var label_node = $RichTextLabel
onready var animation_player_node = $AnimationPlayer
onready var timer_node = $Timer

export var text_base_speed : float = 0.1

var text_head_index : int = 0
var entire_text : String = ""

func _ready():
	set_process(false)
	
	var _err = animation_player_node.connect("animation_finished", self, "on_animation_finished")
	_err = timer_node.connect("timeout", self, "on_timer_timeout")
	animation_player_node.play("Open")


func on_animation_finished(anim_name: String):
	if anim_name == "Open":
		load_text(TRANSLATION.get_dialogue_key(0))
		set_process(true)
		timer_node.set_wait_time(text_base_speed)
		timer_node.start()


func load_text(key : String):
	entire_text = TRANSLATION.get_current_translation().get_message(key)


func _process(_delta):
	if entire_text != "" && text_head_index != 0:
		write_text(text_head_index, 4)


func on_timer_timeout():
	text_head_index += 1
	if text_head_index > entire_text.length():
		text_head_index = entire_text.length()
		timer_node.stop()


func write_text(text_head : int, speed_modifier : float = 1.0):
	var text_speed = text_base_speed * (1.0 / speed_modifier)
	timer_node.set_wait_time(text_speed)
	var current_text : String = ""
	var i = 0
	for c in entire_text:
		if i < text_head:
			current_text += c
		i += 1
	
	label_node.text = current_text
