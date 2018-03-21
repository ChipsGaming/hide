extends Light2D

onready var batteryEnergy = preload("res://lib/range/StepRange.gd").new(0, 100, 100, 2)

func _process(delta):
	if enabled:
		batteryEnergy.addStep(-delta)
	else:
		batteryEnergy.addStep(2 * delta)
	
	if batteryEnergy.value <= 0:
		disable()
	elif batteryEnergy.value <= 20:
		energy = 0.3
	elif batteryEnergy.value <= 40:
		energy = 0.6

func disable():
	enabled = false

func enable():
	enabled = true
