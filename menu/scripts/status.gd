extends Control

func log(message):
	$log.set_text(message)

func clear():
	$log.set_text("")