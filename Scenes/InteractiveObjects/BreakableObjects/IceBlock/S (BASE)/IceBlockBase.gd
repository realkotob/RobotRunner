extends BlockBase

class_name IceBlock

onready var animation_player_node = $AnimationPlayer

### ICEBLOCKS ###

var floating_line_y : float = 0.0
var floating_speed : int = 50
var is_floating : bool = false setget set_is_floating

var floating_force := Vector2(0, -150)
onready var base_gravity_scale = get_gravity_scale()

func is_class(value: String):
	return value == "IceBlock"

func get_class() -> String:
	return "IceBlock"


func _ready():
	set_physics_process(false)


# When the block is destroyed, lauch the destroy animation
func destroy(_actor_destroying: Node = null):
	awake_nearby_bodies()
	audio_node.play()
	set_mode(RigidBody2D.MODE_STATIC)
	collision_shape_node.set_disabled(true)
	$Particles2D.set_emitting(true)
	SFX.scatter_sprite(self, nb_debris, explosion_impulse)
	SFX.scatter_sprite(self, int(nb_debris / 6), explosion_impulse * 0.7)
	sprite_node.set_visible(false)
	animation_player_node.play("LightFadeOut")



func _physics_process(_delta):
	if floating_line_y != 0.0:
		if global_position.y >= floating_line_y:
			apply_floating(true)
		else:
			apply_floating(false)


func apply_floating(value: bool):
	var y_direction : int
	if value == true:
		y_direction = 1
	else:
		y_direction = -1

	if(get_applied_force()) != floating_force * y_direction:
		add_central_force(Vector2(0,0))
		add_central_force(floating_force * y_direction)


func set_is_floating(value: bool):
	is_floating = value
	apply_floating(true)
	set_physics_process(true)
	add_to_group("MovableBodies")
