extends Node2D

# Handle the motion of both players' camera as well as communication with the
# SplitScreen shader to achieve the dynamic split screen effet
# 
# Cameras are place on the segment joining the two players, either in the middle 
# if players are close enough or at a fixed distance if they are not.
# In the first case, both cameras being at the same location, only the view of 
# the first one is used for the entire screen thus allowing the players to play 
# on a unsplit screen.
# In the second case, the screen is split in two with a line perpendicular to the
# segement joining the two players.
# 
# The points of customization are:
#   max_separation: the distance between players at which the view starts to split
#   split_line_thickness: the thickness of the split line in pixels
#   split_line_color: color of the split line
#   adaptive_split_line_thickness: if true, the split line thickness will vary 
#       depending on the distance between players. If false, the thickness will
#       be constant and equal to split_line_thickness

export(float) var max_separation = 500.0
export(float) var split_line_thickness = 3.0
export(Color, RGBA) var split_line_color = Color.black
export(bool) var adaptive_split_line_thickness = true

onready var player1 : Node = null
onready var player2 : Node = null
onready var camera1: Camera2D = $ViewportContainer/Viewport1/Camera1
onready var camera2: Camera2D = $ViewportContainer2/Viewport2/Camera2
onready var viewport1 : Viewport = $ViewportContainer/Viewport1
onready var viewport2 : Viewport = $ViewportContainer2/Viewport2
onready var view: TextureRect = $View

func _ready():
	set_process(false)

func setup():
	var _err = get_viewport().connect("size_changed", self, "_on_size_changed")
	
	camera1.set_custom_viewport(viewport1)
	camera2.set_custom_viewport(viewport2)
	
	camera1.set_follow_target(player1)
	camera2.set_follow_target(player2)
	
	camera1.set_state("Follow")
	camera2.set_state("Follow")
	
	
#	viewport2.set_world_2d(viewport1.get_world_2d())
	
	_on_size_changed()
	_update_splitscreen()
	
	view.material.set_shader_param('viewport1', viewport1.get_texture())
	view.material.set_shader_param('viewport2', viewport2.get_texture())
	
	set_process(true)


func _process(_delta):
	_update_splitscreen()


func _update_splitscreen():
	var player1_position = camera1.global_position - player1.global_position
	var player2_position = camera2.global_position - player2.global_position
	
	# Update the splitting line between camera
	var thickness
	if adaptive_split_line_thickness:
		var distance = _compute_separation_distance()
		thickness = lerp(0, split_line_thickness, (distance - max_separation) / max_separation)
		thickness = clamp(thickness, 0, split_line_thickness)
	else:
		thickness = split_line_thickness
	
	# Feed the shaders
	view.material.set_shader_param('split_active', _get_split_state())
	view.material.set_shader_param('player1_position', player1_position)
	view.material.set_shader_param('player2_position', player2_position)
	view.material.set_shader_param('split_line_thickness', thickness)
	view.material.set_shader_param('split_line_color', split_line_color)


# Split screen is active if players are too far apart from each other.
# Only the horizontal components (x, z) are used for distance computation
func _get_split_state():
	var separation_distance = _compute_separation_distance()
	return separation_distance > max_separation


# Update the shader if the screen size has changed
func _on_size_changed():
	var screen_size = get_viewport().get_visible_rect().size
	
#	viewport1.size = screen_size
#	viewport2.size = screen_size
	view.rect_size = screen_size
	
	view.material.set_shader_param('viewport_size', screen_size)


# Compute the difference in distance between two entity
func _compute_separation_distance():
	return player2.global_position.distance_to(player1.global_position)


