extends Light2D


onready var tween_node = $Tween
onready var area_node = $Area2D

var default_texture_scale = texture_scale

var monitoring_overlaps : bool = false setget set_monitoring_overlaps, is_monitoring_overlaps

func _ready():
	texture_scale = 0.0
	area_node.connect("body_entered", self, "on_body_entered")
	area_node.connect("area_entered", self, "on_area_entered")


func set_monitoring_overlaps(value: bool):
	monitoring_overlaps = value
	set_physics_process(value)


func is_monitoring_overlaps() -> bool:
	return monitoring_overlaps


func on_body_entered(body):
	if body.name == "HiddenWalls":
		appear()


func on_area_entered(area):
	if area.name == "XionCloud":
		appear()


func appear():
	set_monitoring_overlaps(true)
	set_enabled(true)
	tween_node.interpolate_property(self, "texture_scale",
		texture_scale, default_texture_scale, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween_node.start()


func disappear():
	tween_node.interpolate_property(self, "texture_scale",
		texture_scale, 0.0, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween_node.start()
	
	yield(tween_node, "tween_all_completed")
	if !is_inside_element():
		set_monitoring_overlaps(false)
		set_enabled(false)


func find_element(element_array: Array, element_name : String):
	var found = false
	for element in element_array:
		if element.name == element_name:
			found = true
	return found


func is_inside_element() -> bool:
	return find_element(area_node.get_overlapping_bodies(), "HiddenWalls") or \
		   find_element(area_node.get_overlapping_areas(), "XionCloud")

func _physics_process(_delta):
	if is_monitoring_overlaps():
		if !is_inside_element():
			disappear()
