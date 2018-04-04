extends Node2D

export(int) var step_speed = 40
export(int) var running_speed = 100

var direction = Vector2()
var speed = 0
var energy = 100
var state = "stay"
onready var currentStepSpeed = step_speed
onready var currentRunningSpeed = running_speed
onready var unreliableSynchronizer = preload("res://lib/network/UnreliableSynchronizer.gd").new(self, ["state", "energy"])

func _process(delta):
	if is_network_master():
		direction = Vector2()
		if Input.is_action_pressed("ui_up"):
			direction.y -= 1
		if Input.is_action_pressed("ui_down"):
			direction.y += 1
		if Input.is_action_pressed("ui_left"):
			direction.x -= 1
		if Input.is_action_pressed("ui_right"):
			direction.x += 1
		
		speed = 0
		state = "stay"
		var energyDelta = 0
		if energy < 100:
			energyDelta = 5 * delta
		if direction.length() > 0:
			speed = currentStepSpeed
			state = "walk"
			if Input.is_action_pressed("run"):
				if energy > 20:
					speed = currentRunningSpeed
					state = "run"
				energyDelta = -5 * delta
		energy += energyDelta
		if energy < 0:
			energy = 0
		
		unreliableSynchronizer.synchronize()
	
	if energy <= 30:
		if !$dyspnea.is_playing():
			$dyspnea.play()
	elif energy >= 50:
		$dyspnea.stop()
	
	if state == "stay" && ($walk.is_playing() || $run.is_playing()):
		$walk.stop()
		$run.stop()
	elif state == "walk" && !$walk.is_playing():
		$walk.play()
		$run.stop()
	elif state == "run" && !$run.is_playing():
		$walk.stop()
		$run.play()

func getDirection():
	return direction.normalized()

func getSpeed():
	return speed

func getState():
	return state