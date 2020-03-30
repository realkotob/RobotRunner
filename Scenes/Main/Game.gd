extends Node2D

const level1 = preload("res://Scenes/Levels/Level1/Level1.tscn")
const debug_level = preload("res://Scenes/Levels/Debug/LevelDebug.tscn")

var player1 = preload("res://Scenes/Characters/RobotIce/RobotIce.tscn")
var player2 = preload("res://Scenes/Characters/RobotHammer/RobotHammer.tscn")

var current_level = level1

# Generate the current level
func goto_current_level():
	var _err = get_tree().change_scene_to(current_level)


# Change scene to go to the gameover scene
func gameover():
	var _err = get_tree().change_scene_to(MENUS.game_over_scene)
