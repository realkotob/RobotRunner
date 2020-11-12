extends Area2D
class_name CollactableBase

var aimed_character_weakref : WeakRef = null

export var speed : int = 350
export var initial_impulse : bool = true

var initial_velocity := Vector2.ZERO
var velocity := Vector2.ZERO

#### ACCESSORS ####

func is_class(value: String):
	return value == "CollactableBase" or .is_class(value)

func get_class() -> String:
	return "CollactableBase"


#### BUILT-IN ####

func _ready():
	$TravellingSound.play()
	var _err = $CollectSound.connect("finished", self, "on_collect_audio_finished")
	_err = connect("body_entered", self, "on_body_entered")


func _physics_process(delta):
	if aimed_character_weakref == null:
		return
	
	var aimed_character = aimed_character_weakref.get_ref()
	
	# Move toward the aimed player
	if aimed_character != null:
		var char_pos = aimed_character.get_global_position()
		
		if initial_impulse == false:
			var direction = position.direction_to(aimed_character.position)
			var dist_to_char = position.distance_to(char_pos)
			var current_speed = clamp(speed + dist_to_char * 2, speed, speed * 10)
			velocity = direction * current_speed
		else :
			velocity = initial_velocity
		
		var futur_pos = position + (velocity * delta)
		
		if futur_pos.distance_to(char_pos) > position.distance_to(char_pos):
			futur_pos = char_pos
		
		position = futur_pos
	
	# If the aimed player is dead, destroy this instance
	else:
		queue_free()


#### LOGIC ####

func collect():
	call_deferred("set_monitoring", false)
	$CollectSound.play()
	$TravellingSound.stop()


#### SIGNAL RESPONSES ####

func on_collect_audio_finished():
	queue_free()

func on_body_entered(body : PhysicsBody2D):
	if body is Player:
		collect()
