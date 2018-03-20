extends Node2D

const STEP_SPEED = 40
const RUNNING_SPEED = 100
const CONSUMPTION = 10

slave var slave_position
slave var slave_rotation
slave var slave_flashlight
slave var slave_animation

var walkEnergy = 100
var currentAnimation = ""

func _ready():
	slave_position = position
	slave_rotation = rotation
	slave_flashlight = true
	slave_animation = "stay"
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
			if walkEnergy > 20:
				speed = RUNNING_SPEED
			if walkEnergy > 0:
				walkEnergy -= CONSUMPTION * delta
			else:
				walkEnergy = 0
		else:
			if walkEnergy < 100:
				walkEnergy += CONSUMPTION * delta
			else:
				walkEnergy = 100
		if offset.length() > 0:
			$Body.move_and_slide(offset.normalized() * speed)
			if speed == STEP_SPEED:
				newAnimation = "walk"
			else:
				newAnimation = "run"
		rset_unreliable("slave_position", $Body.position)
		
		if newAnimation != currentAnimation:
			currentAnimation = newAnimation
			$Body/Animation.play(currentAnimation)
			rset_unreliable("slave_animation", currentAnimation)
	else:
		$Body.position = slave_position
		$Body.rotation = slave_rotation
		$Body/Flashlight.enabled = slave_flashlight
		if currentAnimation != slave_animation:
			currentAnimation = slave_animation
			$Body/Animation.play(currentAnimation)

func _input(event):
	if is_network_master() && event.is_action_released("light"):
		$Body/Flashlight.enabled = !$Body/Flashlight.enabled
		rset("slave_flashlight", $Body/Flashlight.enabled)