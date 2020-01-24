extends MenuBase

onready var resume_label_node = get_node("HBoxContainer/V_OptContainer/Resume")

func _ready():
	resume_label_node.connect("resume", self, "on_resume")

func on_resume():
	queue_free()