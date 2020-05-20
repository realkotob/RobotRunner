extends Node

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
	return "DIAL_" + String(index)


#### LOGIC ####

func _ready():
	TranslationServer.set_locale(default_locale)
	set_current_translation_by_locale(default_locale)



