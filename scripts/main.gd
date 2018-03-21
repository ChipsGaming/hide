extends Node2D

var countPlayers = null
var readyPlayers = 0

func onStart(map, players):
	countPlayers = players.size()
	rpc("prepareGame", map, players)

sync func prepareGame(map, players):
	$menu.hide()
	get_tree().set_pause(true)
	
	var mapInstance = load("res://maps/" + map.name + "/map.tscn").instance()
	mapInstance.set_name("map")
	mapInstance.set_network_master(1)
	mapInstance.position = Vector2(200, 200)
	add_child(mapInstance)
	
	for id in players:
		var playerInstance = mapInstance.createPlayer()
		playerInstance.set_network_master(id)
		playerInstance.set_name(String(id))
		mapInstance.addPlayer(id, playerInstance)
	
	rpc("readyPlayer")

master func readyPlayer():
	readyPlayers += 1
	
	if readyPlayers == countPlayers:
		rpc("startGame")

sync func startGame():
	get_tree().set_pause(false)
	get_node("map").startGame()