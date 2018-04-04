extends Area2D

signal anxiety
signal tranquility

export(int) var shyness = 10
export(int) var durability = 20

var fear = 0
var isInLight = false
var isAnxiety = false

onready var unreliableSynchronizer = preload("res://lib/network/UnreliableSynchronizer.gd").new(self, ["fear"])

func _process(delta):
	if is_network_master():
		if isInLight:
			if fear > 0:
				fear -= durability * delta
			else:
				fear = 0
		else:
			if fear < 100:
				fear += shyness * delta
			else:
				fear = 100
		
		unreliableSynchronizer.synchronize()
	
	if fear >= 80:
		if !$fear.is_playing():
			$fear.play()
			isAnxiety = true
			emit_signal("anxiety")
	elif fear <= 60:
		if $fear.is_playing():
			$fear.stop()
			isAnxiety = false
			emit_signal("tranquility")

func getFearLevel():
	return (fear - 60) / 40;

func onLightEnter(area):
	if is_network_master() && area.is_in_group("light"):
		isInLight = true

func onLightExit(area):
	if is_network_master() && area.is_in_group("light"):
		isInLight = false
		for overlappingArea in get_overlapping_areas():
			if overlappingArea.is_in_group("light") && overlappingArea != area:
				isInLight = true
				break
