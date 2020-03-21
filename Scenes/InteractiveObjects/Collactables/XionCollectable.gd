extends CollactableBase

func _ready():
	var random_ang = deg2rad(randi() % 360 + 1)
	var dir = Vector2(cos(random_ang), sin(random_ang))
	
	var random_force = randi() % 100 + 100
	initial_velocity = dir * random_force
	velocity = initial_velocity
