extends Node2D
class_name WorldMapCharacter

onready var sprite := $Sprite

var texture : Texture = null setget set_texture

#### ACCESSORS ####

func is_class(value: String): return value == "WorldMapCharacter" or .is_class(value)
func get_class() -> String: return "WorldMapCharacter"


#### BUILT-IN ####

func set_texture(value: Texture):
	sprite.set_texture(value)


#### VIRTUALS ####



#### LOGIC ####



#### INPUTS ####



#### SIGNAL RESPONSES ####
