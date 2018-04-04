extends Light2D

export(int) var charge = 2
export(int) var discharge = 4

onready var reliableSynchronizer = preload("res://lib/network/ReliableSynchronizer.gd").new(self, ["enabled"])
onready var unreliableSynchronizer = preload("res://lib/network/UnreliableSynchronizer.gd").new(self, ["energy"])
onready var battery = preload("res://lib/range/Range.gd").new(0, 100, 100)

func _process(delta):
	if is_network_master():
		if enabled:
			battery.add(discharge * -delta)
		else:
			battery.add(charge * delta)
		
		if battery.value <= 0:
			set_enabled(false)
		
		reliableSynchronizer.synchronize()
		unreliableSynchronizer.synchronize()
	
	if battery.value <= 20:
		set_energy(0.3)
	elif battery.value <= 40:
		set_energy(0.6)
	else:
		set_energy(1)

sync func toggle():
	enabled = !enabled
	$switch.play()

sync func disable():
	enabled = false
	$switch.play()

sync func enable():
	enabled = true
	$switch.play()

func _input(event):
	if is_network_master():
		if event.is_action_released("light"):
			rpc("toggle")