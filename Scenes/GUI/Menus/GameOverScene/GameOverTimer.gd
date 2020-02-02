extends Timer

signal start_timer

func on_ready():
	var _err = connect("start_timer", get_parent(), "on_timer_started")
	_err = connect("timeout", get_parent(), "on_timer_timeout")

func start_timer():
	start()
