extends Liquid
class_name Lava
tool

#### LAVA MAIN NODE ####

#### ACCESSORS ####

func is_class(value: String):
	return value == "Lava" or .is_class(value)

func get_class() -> String:
	return "Lava"


#### BUILT-IN ####



#### SIGNAL RESPONSES ####

# Destroy the body entering the lava
func on_body_entered(body):
	if body.has_method("destroy"):
		body.destroy()
