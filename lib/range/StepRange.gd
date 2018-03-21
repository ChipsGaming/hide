extends "Range.gd"

var step

func _init(min_value = 0, max_value = 100, value = 0, step = 1).(min_value, max_value, value):
	self.step = step

func addStep(factor = 1):
	add(step * factor)