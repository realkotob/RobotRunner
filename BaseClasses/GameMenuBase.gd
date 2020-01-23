extends Node2D

class_name MenuBase

#Give mainscene path, so it can be changed later (or loaded?)
onready var strMainScene = "res://Scenes/MainScene/Main.tscn"

onready var opt_container = get_node("HBoxContainer/V_OptContainer")
onready var options_array = opt_container.get_children()

var opt_index : int = 0 #Get the index where the player aim
var prev_opt_index : int = 0 #Get the index where the player aimed before changing

func _physics_process(_delta):
	print(options_array[1])
	highlight_menuopt()

func _unhandled_input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("ui_accept"):
			match(opt_index):
				0: #Player Selection -> New Game
					var _err = get_tree().change_scene(strMainScene)
				1: #Player Selection -> Scores
					#options_array[opt_index].set_self_modulate(Color(1,0,0,1))
					pass
				2: #Player Selection -> Options
					#options_array[opt_index].set_self_modulate(Color(1,0,0,1))
					pass
				3: #Player Selection -> Leave
					get_tree().quit()

		elif Input.is_action_just_pressed("ui_up"):
			prev_opt_index = opt_index #Get current index and give its value to prev_opt_index
			if(opt_index == 3): # If player is selecting "Leave" Label (Quit) -> Directly go to "Play" Label (New Game)
				opt_index = 0 #Go to Play Label (New Game)
			elif(opt_index>0): 
				opt_index -= 1 

		elif Input.is_action_just_pressed("ui_down"):
			prev_opt_index = opt_index
			if(opt_index == 0): # If player is selecting "Play" Label (New Game) -> Directly go to "Leave" Label (Quit)
				opt_index = 3 #Go to Leave Label (Quit)
			elif(opt_index<options_array.size()-1):
				opt_index += 1


func highlight_menuopt():
	#GOAL : Change the color of menu option according if it is selected by a player or no
	options_array[prev_opt_index].set_self_modulate(Color(1,1,1,1)) #1,1,1,1 WHITE COLOR = Not selected
	options_array[opt_index].set_self_modulate(Color(0,0.5,1,1)) #0,0.5,1,1 CYAN COLOR = SELECTED