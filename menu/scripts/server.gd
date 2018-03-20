extends Control

signal submit(port)
signal error(message)

func onSubmit():
	var port = $port.get_text()
	if port == "":
		emit_signal("error", "Port not set")
		return
	
	emit_signal("submit", port)

func disable():
	$port.editable = false
	$submit.disabled = true

func enable():
	$port.editable = true
	$submit.disabled = false