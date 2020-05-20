extends Resource

class_name ChapterBase

export var levels_scenes_array : Array

func load_levels():
	var levels_array : Array = []
	
	for scene in levels_scenes_array:
		var lvl = load(scene)
		levels_array.append(lvl)
	
	return levels_array
