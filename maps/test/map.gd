extends Node2D

var players = {}

func createPlayer():
	var player = load("res://maps/test/models/player.tscn").instance()
	player.scale = Vector2(0.4, 0.4)
	
	return player

func addPlayer(id, player):
	$Players.add_child(player)
	players[id] = player

func removePlayer(id):
	if !players.has(id):
		return
	
	players[id].queue_free()
	players.erase(id)

func clear():
	for id in players:
		removePlayer(id)

func getPlayersCount():
	return players.size()