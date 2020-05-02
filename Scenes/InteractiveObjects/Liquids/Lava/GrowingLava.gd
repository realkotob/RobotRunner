extends LavaZone

class_name GrowingLava

onready var lava_shader_node = $LavaShader
onready var collision_shape_node = $CollisionShape2D
onready var light_node = $LavaShader/LavaLight
onready var shader : Material = lava_shader_node.get_material()

export (int, 0, 1000) var speed = 20
export var is_growing : bool = false setget set_is_growing

func _physics_process(delta):
	if is_growing:
		growing(delta)


func set_is_growing(value : bool):
	is_growing = value


# Make the lava grow
#func growing(delta):
#	var reel_speed = speed * delta
#	var lava_region_rect_size = lava_shader_node.get_region_rect().size
#
#	lava_region_rect_size.y += reel_speed
#	lava_shader_node.set_region_rect(Rect2(Vector2(0, 18), Vector2(lava_region_rect_size)))
#
#	var shape_extend = collision_shape_node.get_shape().get_extents()
#	shape_extend.y += reel_speed / 2
#	collision_shape_node.get_shape().set_extents(shape_extend)
#
#	light_node.position.y -= reel_speed

func growing(delta):
	scale.y += (speed * delta) / 100
