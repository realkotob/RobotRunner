extends ActionBase

### ACTION STATE  ###

func _ready(): 
	interact_able_array = get_tree().get_nodes_in_group("Water")
