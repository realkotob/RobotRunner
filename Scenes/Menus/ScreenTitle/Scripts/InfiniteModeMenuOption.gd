extends MenuOptionsBase
class_name InfiniteModeMenuOption

#### ACCESSORS ####

func is_class(value: String): return value == "InfiniteModeMenuOption" or .is_class(value)
func get_class() -> String: return "InfiniteModeMenuOption"


#### BUILT-IN ####


func _ready() -> void:
	var _err = $SeedField/LineEdit.connect("submit", self, "_on_seed_field_submit")
	_err = $SeedField/LineEdit.connect("canceled", self, "_on_seed_field_canceled")


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####

func _on_seed_field_submit(seed_value: int):
	EVENTS.emit_signal("seed_change_query", seed_value)
	emit_signal("option_chose", self)
	$SeedField.set_visible(false)


func _on_seed_field_canceled():
	grab_focus()
	$SeedField.set_visible(false)
