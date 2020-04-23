extends Area2D

class_name TriggerArea
const CLASS = "TriggerArea"

export var all_players : bool = false

var passed_players : Array = []

var triggered : bool = false setget set_triggered, is_triggered

signal area_triggered

func get_class() -> String:
	return CLASS


func is_class(value : String) -> bool:
	return value == CLASS


func _ready():
	var _err = connect("body_entered", self, "on_body_entered")


# When the tiggers is set to true, send the signal to the event node 
# (Should be a parent of this node)
func set_triggered(value: bool):
	triggered = value
	$CollisionShape2D.call_deferred("set_disabled", value)
	if triggered:
		emit_signal("area_triggered")

func is_triggered() -> bool:
	return triggered


# Detect a player entering the area
# If only one player is needed, send the triggered signal
# If all the players are needed, wait until all the player are in the area to send the signal
func on_body_entered(body : PhysicsBody2D):
	if body == null:
		return
	
	if body.is_class("Player"):
		if all_players == false:
			set_triggered(true)
		else:
			if !(body in passed_players):
				passed_players.append(body)
			if len(passed_players) >= 2:
				set_triggered(true)
