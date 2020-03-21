extends CollactableBase

onready var timer_node = $Timer

signal xion_received

func _ready():
	var _err = connect("xion_received", aimed_character, "on_xion_received")
	_err = timer_node.connect("timeout", self, "on_timeout")
	
	# Genererate a random angle value between 0 and 359
	var random_ang = deg2rad(randi() % 360)
	var dir = Vector2(cos(random_ang), sin(random_ang))
	
	# Gennerate a random force value beteen 100 and 200
	var random_force = randi() % 100 + 100
	initial_velocity = dir * random_force
	velocity = initial_velocity


func on_timeout():
	initial_impulse = false


func contact_with_player():
	emit_signal("xion_received")
	queue_free()
