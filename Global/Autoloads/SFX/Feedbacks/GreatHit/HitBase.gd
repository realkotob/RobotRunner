extends SFX_AnimationBase

func _ready():
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	scale.x = sign(rng.randf() - 0.5)
