extends Area2D

class_name CollactableBase

var aimed_character_weakref : WeakRef = null

export var speed : int = 300

var initial_velocity := Vector2.ZERO
var velocity := Vector2.ZERO

var initial_impulse : bool = true

func _ready():
	$TravellingSound.play()
	var _err = $CollectSound.connect("finished", self, "on_collect_audio_finished")
	_err = connect("body_entered", self, "on_body_entered")


func _physics_process(delta):
	var aimed_character = aimed_character_weakref.get_ref()
	
	# Move toward the aimed player
	if aimed_character != null:
		if initial_impulse == false:
			var direction = position.direction_to(aimed_character.position)
			velocity = direction * speed
		else :
			velocity = initial_velocity
		
		position += velocity * delta
	
	# If the aimed player is dead, destroy this instance
	else:
		queue_free()


func on_body_entered(body : PhysicsBody2D):
	if !body:
		return
	
	if body.is_class("Player"):
		$CollectSound.play()
		$TravellingSound.stop()


func on_collect_audio_finished():
	queue_free()
