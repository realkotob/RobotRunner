extends NinePatchRect

onready var label_node = $RichTextLabel
onready var animation_player_node = $AnimationPlayer
onready var timer_node = $TypeInTimer
onready var reading_timer_node = $ReadingTimer

export var text_base_speed : float = 0.1

var text_head_index : int = 0
var entire_text : String = ""
var paragraphs_array : Array = []
var paragraph : String = ""

func _ready():
	set_process(false)
	
	var _err = animation_player_node.connect("animation_finished", self, "on_animation_finished")
	_err = timer_node.connect("timeout", self, "on_timer_timeout")
	_err = reading_timer_node.connect("timeout", self, "on_reading_timer_timeout")
	
	animation_player_node.play("Open")


func _process(_delta):
	if paragraph != "":
		write_text(text_head_index, 4)


# Start the progressive typing process
func start_typing():
	label_node.text = ""
	text_head_index = 0
	paragraph = paragraphs_array.pop_front()
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
	split_in_paragraphs(entire_text)



# Split the given text in printable paragraphs
func split_in_paragraphs(text : String):
	while text.length() > 0:
		var last_return = 0
		var current_return = 0
		
		while current_return < 250 && current_return != -1:
			last_return = current_return
			current_return = text.findn("\n", last_return + 1)
		
		if last_return == -1 or last_return == 0:
			last_return = text.length()
		
		paragraphs_array.append(text.substr(0, last_return))
		text.erase(0, last_return +1)
	
	# print_paragraphs_array()


# Debug purpose
func print_paragraphs_array():
	var i : int = 1
	for par in paragraphs_array:
		print(String(i) + ") " + par)
		i += 1


# Progressively type in the text
func write_text(text_head : int, speed_modifier : float = 1.0):
	var text_speed = text_base_speed * (1.0 / speed_modifier)
	timer_node.set_wait_time(text_speed)
	
	var current_text : String = ""
	
	var i = 0
	for c in paragraph:
		if i < text_head:
			current_text += c
		i += 1
	
	label_node.text = current_text
	
	if current_text == paragraph:
		stop_typing()



func on_timer_timeout():
	text_head_index += 1
	if text_head_index > paragraph.length():
		text_head_index = paragraph.length()
		timer_node.stop()


func on_reading_timer_timeout():
	if len(paragraphs_array) == 0:
		label_node.text = ""
		animation_player_node.play("Close")
	else:
		start_typing()


func on_animation_finished(anim_name: String):
	if anim_name == "Open":
		load_text()
		start_typing()
	if anim_name == "Close":
		queue_free()
