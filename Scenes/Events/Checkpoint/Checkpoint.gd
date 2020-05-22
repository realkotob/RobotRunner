extends Event

export var active : bool = false

onready var animated_sprite_node = $AnimatedSprite

func _ready():
	animated_sprite_node.connect("animation_finished", self, "on_animation_finished")


func event():
	GAME.progression.checkpoint += 1
	trigger_animation()


func trigger_animation():
	animated_sprite_node.play("Trigger")
	$AnimationPlayer.play("LightUp")


func set_active(value : bool):
	active = value
	if active:
		trigger_animation()
		for area in triggers_area_array:
			area.get_node("CollisionShape2D").call_deferred("set_disabled", true)


func on_animation_finished():
	if animated_sprite_node.get_animation() == "Trigger":
		animated_sprite_node.play("Active")
