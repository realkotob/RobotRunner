extends InteractAreaBase
class_name Liquid
tool

const DEFAULT_POOL_SIZE := Vector2(512, 184)

export (float, 0.0, 999.0) var empty_part = 48.0 setget set_empty_part, get_empty_part

onready var collision_shape = get_node_or_null("CollisionShape2D")
onready var particules_node = get_node_or_null("Particles2D")
onready var liquid_shader = $LiquidShader
onready var light : Light2D = get_node_or_null("LiquidShader/Light")

export var pool_size := DEFAULT_POOL_SIZE setget set_pool_size, get_pool_size
var is_ready : bool = false

#### ACCESSORS ####

func is_class(value: String): return value == "Liquid" or .is_class(value)
func get_class() -> String: return "Liquid"

func set_pool_size(value: Vector2): 
	if pool_size != value && value.x > 0 && value.y > 0:
		pool_size = value
		if !is_ready:
			yield(self, "ready")
		update_pool_size()

func get_pool_size() -> Vector2: return pool_size

func set_empty_part(value: float):
	empty_part = value
	if !is_ready:
		yield(self, "ready")
	update_pool_size()

func get_empty_part() -> float: return empty_part

#### BUILT-IN ####

func _ready():
	update_pool_size()
	is_ready = true


#### VIRTUALS ####


#### LOGIC ####

func update_pool_size():
	if particules_node != null:
		particules_node.set_position(Vector2(0, -pool_size.y / 2))
	
	var sprite_size := Vector2(pool_size.x, pool_size.y + empty_part)
	
	set_scale(Vector2.ONE)
	liquid_shader.set_scale(Vector2.ONE)
	liquid_shader.set_region(true)
	liquid_shader.set_region_rect(Rect2(Vector2.ZERO, sprite_size))
	
	var shape_ext = pool_size / 2 
	collision_shape.get_shape().set_extents(shape_ext)
	collision_shape.set_position(Vector2(0, empty_part / 2))
	
	if light != null:
		var current_scale = get_pool_size() / DEFAULT_POOL_SIZE
		var float_scale = (current_scale.x + current_scale.y) /2
		light.set_texture_scale(float_scale)


#### INPUTS ####


#### SIGNAL RESPONSES ####

func on_body_entered(_body):
	pass
