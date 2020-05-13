extends TextureRect

onready var glitch_cool_down = $GlitchCoolDown
onready var glitch_timer_node = $GlitchDuration
onready var sub_glitch_timer_node = $SubGlitchDuration

var glitch : bool = false


func _ready():
	var _err = glitch_timer_node.connect("timeout", self, "on_glitch_duration_timeout")
	_err = sub_glitch_timer_node.connect("timeout", self, "on_sub_glitch_duration_timeout")
	_err = glitch_cool_down.connect("timeout", self, "on_cooldown_timeout")


func on_glitch_duration_timeout():
	glitch_timer_node.stop()
	sub_glitch_timer_node.stop()
	var shader_material = get_material()
	shader_material.set_shader_param("apply", false)
	
	glitch_cool_down.set_wait_time(rand_range(3.5, 5.0))
	glitch_cool_down.start()


func on_sub_glitch_duration_timeout():
	generate_glitch()


func on_cooldown_timeout():
	glitch_timer_node.set_wait_time(rand_range(0.3, 0.7))
	glitch_timer_node.start()
	
	generate_glitch()



func generate_glitch():
	var shader_material = get_material()
	
	var rng_sign = randi() % 2 - 1
	
	shader_material.set_shader_param("apply", true)
	shader_material.set_shader_param("displace_amount", int(rand_range(30.0, 60.0) * rng_sign))
	shader_material.set_shader_param("aberation_amount", rand_range(-10.0, 10.0))
	
	sub_glitch_timer_node.set_wait_time(rand_range(0.05, 0.1))
	sub_glitch_timer_node.start()
