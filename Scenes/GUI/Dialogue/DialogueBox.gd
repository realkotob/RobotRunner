extends NinePatchRect

onready var label_node = $RichTextLabel
onready var animation_player_node = $AnimationPlayer
onready var timer_node = $TypeInTimer
onready var reading_timer_node = $ReadingTimer

export var text_base_speed : float = 0.1

var text_head_index : int = 0
var entire_text : String = ""

func _ready():
	set_process(false)
	
	var _err = animation_player_node.connect("animation_finished", self, "on_animation_finished")
	_err = timer_node.connect("timeout", self, "on_timer_timeout")
	_err = reading_timer_node.connect("timeout", self, "on_reading_timer_timeout")
	
	animation_player_node.play("Open")


func on_animation_finished(anim_name: String):
	if anim_name == "Open":
		load_text()
		start_typing()
	if anim_name == "Close":
		queue_free()


# Start the progressive typing process
func start_typing():
	set_process(true)
	timer_node.set_wait_time(text_base_speed)
	timer_node.start()


func stop_typing():
	reading_timer_node.start()
	timer_node.stop()
	set_process(false)


# Load the dialogue at its current index, store it in entire_text, 
# And then increment the dialogue counter
func load_text():
	var dialogue_index = GAME.progression.dialogue
	var key = TRANSLATION.get_dialogue_key(dialogue_index)
	entire_text = TRANSLATION.get_current_translation().get_message(key)
	GAME.progression.dialogue += 1


func _process(_delta):
	if entire_text != "" && text_head_index != 0:
		write_text(text_head_index, 4)


func on_timer_timeout():
	text_head_index += 1
	if text_head_index > entire_text.length():
		text_head_index = entire_text.length()
		timer_node.stop()


func on_reading_timer_timeout():
	label_node.text = ""
	animation_player_node.play("Close")


# Progressively type in the text
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
	
	if current_text == entire_text:
		stop_typing()
