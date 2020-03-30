extends MenuBase

onready var resume_label_node = get_node("HBoxContainer/V_OptContainer/Resume")

# Set the GUI layer to be at the origin of the screen
func _ready():
	resume_label_node.connect("resume", self, "on_resume")


func on_resume():
	queue_free()
