extends Timer

func on_ready():
	var _err = connect("timeout", get_parent(), "on_timer_timeout")

