extends BlockBase

class_name EarthBlock

func is_class(value: String):
	return value == "EarthBlock" or .is_class(value)

func get_class() -> String:
	return "EarthBlock"
