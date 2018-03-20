extends Control

signal select(info)

var currentMap = null
var maps = [
	{"name": "test", "minPlayers": 1, "maxPlayers": 4}
]

func _ready():
	for map in maps:
		$list.add_item(map.name)

func onSelect(index):
	currentMap =  maps[index]
	emit_signal("select", currentMap)

func getSelectedMap():
	if currentMap == null:
		return null
	
	return currentMap
