extends StateBase

class_name WorkStateBase

#####   WORK STATE   #####

# This node take charge of the behaviour of a employee when he is working

# When working, an employee get the work done variable increasing over time
# The employee stress is also increasing if he is working too long

export var work_done_cooldown : int
export var stress_increase_cooldown : int

signal work_done
signal stress_increase

onready var project_node := get_tree().get_root().get_node("Master/HUD/Project")
onready var attributes_node := get_parent().get_parent().get_node("Attributes")
onready var workTimer_node := find_node("WorkTimer")
onready var StressIncreaseTimer_node := find_node("StressIncreaseTimer")
onready var employee_node := get_node("../..")
onready var state_node = get_parent()

onready var target_position = attributes_node.get_work_position()

func update(_host, _delta):
	if employee_node.position != target_position:
		return "Move"

# Connect the signals
func _ready():
	var _err
	_err = connect("work_done", project_node ,"on_work_done")
	_err = connect("stress_increase", attributes_node ,"on_stress_increase")

	# Adapt the stress cooldown to the trait of the employee
	match attributes_node.get_trait():
		attributes_node.LAZY:
			stress_increase_cooldown = stress_increase_cooldown + ((stress_increase_cooldown as float /3) as int)
		attributes_node.NORMIE:
			pass
		attributes_node.ZEALOUS:
			stress_increase_cooldown = stress_increase_cooldown - ((stress_increase_cooldown as float /3) as int)

# Set the timers actives when entering the state, and send the signal work_state_entered
func enter_state(_host):
	workTimer_node.start()
	StressIncreaseTimer_node.start()

# At a interval of time based on the productivity, the work_done value is increased,
# Recalculate the interval each time the timer is finished
func on_worktimer_timeout():
	if state_node.get_state() == self:
		emit_signal("work_done")
		var prod = attributes_node.get_productivity()
		workTimer_node.set_wait_time(work_done_cooldown - prod)

# At a interval of time based on the character's trait, the stress value is increased,
# Recalculate the interval each time the timer is finished
func on_stress_increase_timer():
	if state_node.get_state() == self:
		emit_signal("stress_increase")
		StressIncreaseTimer_node.set_wait_time(stress_increase_cooldown)