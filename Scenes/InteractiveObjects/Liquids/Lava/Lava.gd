extends Area2D

class_name LavaZone

#### LAVA MAIN NODE ####

## USE: CHANGE THE SIZE OF THE POOL BY CHANGING THE SCALE OF THIS NODE ##
## PLEASE DO NOT USE CHANGE CHILDREN TO CHANGE THE SIZE ##

func _ready():
	var _err = connect("body_entered", self, "on_body_entered")


# Destroy the body entering the lava
func on_body_entered(body):
	if body.has_method("destroy"):
		body.destroy()
