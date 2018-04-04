extends KinematicBody2D

onready var synchronizer = preload("res://lib/network/UnreliableSynchronizer.gd").new(self, ["position", "rotation"])

func _ready():
	$camera.current = is_network_master()
	$anim.set_current_animation("stay")

func _process(delta):
	if is_network_master():
		rotate(
			get_angle_to(get_global_mouse_position()) * delta * 2
		)
		move_and_slide($skills/move.getDirection() * $skills/move.getSpeed())
		
		if $skills/fear.isAnxiety:
			$skills/move.currentStepSpeed = $skills/move.step_speed / (1 + $skills/fear.getFearLevel())
			$skills/move.currentRunningSpeed = $skills/move.running_speed / (1 + $skills/fear.getFearLevel())
		else:
			$skills/move.currentStepSpeed = $skills/move.step_speed
			$skills/move.currentRunningSpeed = $skills/move.running_speed
		
		synchronizer.synchronize()
	
	$anim.set_current_animation($skills/move.getState())

func onFearStart():
	$skills/move.currentStepSpeed = $skills/move.step_speed / (1 + $skills/fear.getFearLevel())
	$skills/move.currentRunningSpeed = $skills/move.running_speed / (1 + $skills/fear.getFearLevel())

func onFearEnd():
	$skills/move.currentStepSpeed = $skills/move.step_speed
	$skills/move.currentRunningSpeed = $skills/move.running_speed