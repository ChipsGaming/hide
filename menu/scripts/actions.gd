extends Control

signal join(host, port)
signal host(port)
signal error(message)

func onClientSubmit(host, port):
	emit_signal("join", host, int(port))

func onClientError(message):
	emit_signal("error", message)

func onServerSubmit(port):
	emit_signal("host", int(port))

func onServerError(message):
	emit_signal("error", message)

func disable():
	$client.disable()
	$server.disable()

func enable():
	$client.enable()
	$server.enable()