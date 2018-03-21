extends Node2D

const STEP_SPEED = 40
const RUNNING_SPEED = 100

slave var slave_position
slave var slave_rotation
slave var slave_flashlight
sync var slave_energy

onready var legsEnergy = preload("res://lib/range/StepRange.gd").new(0, 100, 100, 10)
var currentAnimation = ""
var isMonster = false

func _ready():
	slave_position = position
	slave_rotation = rotation
	slave_flashlight = true
	slave_energy = legsEnergy.value
	$Body/Camera.current = is_network_master()
	
func _process(delta):
	if is_network_master():
		# Rotate
		$Body.rotate(
			$Body.get_angle_to(get_global_mouse_position()) * delta * 2
		)
		rset_unreliable("slave_rotation", $Body.rotation)
		
		# Move
		var newAnimation = "stay"
		var offset = Vector2()
		if Input.is_action_pressed("ui_up"):
			offset.y -= 1
		if Input.is_action_pressed("ui_down"):
			offset.y += 1
		if Input.is_action_pressed("ui_left"):
			offset.x -= 1
		if Input.is_action_pressed("ui_right"):
			offset.x += 1
		var speed = STEP_SPEED
		if Input.is_action_pressed("run") && offset.length() > 0:
			if legsEnergy.value > 20:
				speed = RUNNING_SPEED
			legsEnergy.addStep(-delta)
		else:
			legsEnergy.addStep(delta)
		rset_unreliable("slave_energy", legsEnergy.value)
		if offset.length() > 0:
			$Body.move_and_slide(offset.normalized() * speed)
			if speed == STEP_SPEED:
				newAnimation = "walk"
			else:
				newAnimation = "run"
		rset_unreliable("slave_position", $Body.position)
		
		if newAnimation != currentAnimation:
			rpc("changeAnimation", newAnimation)
	else:
		$Body.position = slave_position
		$Body.rotation = slave_rotation
		$Body/Flashlight.enabled = slave_flashlight && !isMonster
	
	if slave_energy <= 30:
		if !$Body/Dyspnea.is_playing():
			$Body/Dyspnea.play()
	else:
		$Body/Dyspnea.stop()

func _input(event):
	if is_network_master() && event.is_action_released("light") && !isMonster:
		$Body/Flashlight.enabled = !$Body/Flashlight.enabled
		rset("slave_flashlight", $Body/Flashlight.enabled)

sync func changeAnimation(newAnimation):
	currentAnimation = newAnimation
	
	$Body/Animation.play(currentAnimation)
	$Body/Walk.stop()
	$Body/Run.stop()
	if currentAnimation == "walk":
		$Body/Walk.play()
	elif currentAnimation == "run":
		$Body/Run.play()

sync func monster():
	isMonster = true
	$Body/Flashlight.enabled = false
	$Body/MonsterLight.enabled = true
	$Body/Sprite.set_modulate(Color(1, 0.3, 0.3, 1))