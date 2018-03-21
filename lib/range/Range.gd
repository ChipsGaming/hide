extends Reference

var value
var min_value
var max_value

func _init(min_value = 0, max_value = 100, value = 0):
	self.min_value = min_value
	self.max_value = max_value
	self.value = value

func add(d):
	value += d
	if value > max_value:
		value = max_value
	elif value < min_value:
		value = min_value