extends LineEdit

#### ACCESSORS ####

func is_class(value: String):
	return value == "" or .is_class(value)

func get_class() -> String:
	return ""

#### BUILT-IN ####

func _ready():
	var _err
	_err = connect("text_changed", self, "_on_text_changed")

#### LOGIC ####



#### VIRTUALS ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
func _on_text_changed(new_text):
	var allowed_characters = "[A-Za-z_ ]"
	var old_caret_position = self.caret_position
	
	var word = ''
	var regex = RegEx.new()
	regex.compile(allowed_characters)
	for textchar in regex.search_all(new_text):
		word += textchar.get_string()
	self.set_text(word)
	caret_position = old_caret_position
