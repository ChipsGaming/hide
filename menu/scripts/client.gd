extends Control

signal submit(host, port)
signal error(message)

func onSubmit():
	var host = $host.get_text()
	if host == "":
		emit_signal("error", "Host not set")
		return
	if !host.is_valid_ip_address():
		emit_signal("error", "Invalid host address")
		return
	var port = $port.get_text()
	if port == "":
		emit_signal("error", "Port not set")
		return
	
	emit_signal("submit", host, port)

func disable():
	$host.editable = false
	$port.editable = false
	$submit.disabled = true

func enable():
	$host.editable = true
	$port.editable = true
	$submit.disabled = false