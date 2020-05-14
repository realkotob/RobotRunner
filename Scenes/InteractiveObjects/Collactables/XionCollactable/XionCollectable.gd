extends CollactableBase

onready var timer_node = $Timer

signal xion_received

func _ready():
	var _err = connect("xion_received", aimed_character_weakref.get_ref(), "on_xion_received")
	_err = timer_node.connect("timeout", self, "on_timeout")
	
	# Genererate a random angle value between 0 and 359
	var random_ang = deg2rad(randi() % 360)
	var dir = Vector2(cos(random_ang), sin(random_ang))
	
	# Gennerate a random force value beteen 100 and 200
	var random_force = randi() % 100 + 200
	initial_velocity = dir * random_force
	velocity = initial_velocity


func on_timeout():
	initial_impulse = false


func on_body_entered(body : PhysicsBody2D):
	if !body:
		return
	
	if body.is_class("Player"):
		emit_signal("xion_received")
		SCORE.set_xion(SCORE.get_xion() + 50)
		set_physics_process(false)
		$CollisionShape2D.call_deferred("set_disabled", true)
		$CollectSound.play()
		$TravellingSound.stop()
		$Light2D.set_visible(false)
		
		for child in get_children():
			if child is Particles2D:
				child.set_emitting(false)
