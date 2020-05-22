extends AutoloadBase

onready var dialogue_box_scene = preload("res://Scenes/GUI/Dialogue/DialogueBox.tscn")
onready var translations_path_array = ProjectSettings.get_setting("locale/translations")

var current_translation : Translation setget set_current_translation, get_current_translation

var default_locale : String = "en"

#### ACCESSORS ####

func set_current_translation(value: Translation):
	current_translation = value


func get_current_translation():
	return current_translation


func set_current_translation_by_locale(locale: String):
	TranslationServer.set_locale(locale)
	current_translation = get_translation_by_locale(locale)


func get_translation_by_locale(locale: String) -> Translation:
	for path in translations_path_array:
		var trans = load(path)
		if trans.get_locale() == locale:
			return trans
	return null


func get_dialogue_key(index: int) -> String:
	var scene_name = get_tree().get_current_scene().get_name()
	scene_name = scene_name.to_upper()
	var key : String = "DIAL_" + scene_name + "_" + String(index)
	print_notification(key)
	return key


#### BUILT-IN ####

func _ready():
	# debug = true
	TranslationServer.set_locale(default_locale)
	set_current_translation_by_locale(default_locale)


#### LOGIC ####


func instanciate_dialogue_box(index : int):
	var box_node = dialogue_box_scene.instance()
	box_node.dialogue_key = get_dialogue_key(index)
	var GUI_node = get_tree().get_current_scene().find_node("GUI")
	GUI_node.call_deferred("add_child", box_node)
