extends RigidBody2D

func _ready():
	add_to_group("IceBlock")

func set_static():
	set_mode(MODE_STATIC)

func set_rigid():
	set_mode(MODE_RIGID)