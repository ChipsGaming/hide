extends Light2D

const CONSUMPTION = 1
const RECOVERY = 5

var battery = 100

func _process(delta):
	if enabled:
		if battery > 0:
			battery -= CONSUMPTION * delta
		else:
			battery = 0
	else:
		if battery < 100:
			battery += RECOVERY * delta
		else:
			battery = 100
	
	if battery <= 0:
		disable()
	elif battery <= 20:
		energy = 0.3
	elif battery <= 40:
		energy = 0.6

func disable():
	enabled = false

func enable():
	enabled = true
