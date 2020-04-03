extends Area2D

#### LAVA MAIN NODE ####

# To instanciate a lave zone:
# 1) Instanciate this scene
# 2) Instanciate the scene LavaShader & a CollisionShape as children of it
# 3) Instanciate the LavaLight as a child of the LavaShader
# 4) Set the size of the texture, of the shape and of the light as you will

func _ready():
	var _err = connect("body_entered", self, "on_body_entered")


# Destroy the body entering the lava
func on_body_entered(body):
	if body.is_class("Player"):
		body.destroy()
