extends Node2D

var players = {}

func startGame():
	$Background.play()
	if get_tree().is_network_server():
		$Timer.connect("timeout", self, "onMonsterSpawn")
#		$Timer.start()

func onMonsterSpawn():
	var monster = players.values()[rand_range(0, ceil(players.size() - 1))]
	#monster.rpc("monster")

func createPlayer():
	var player = load("res://maps/test/models/player/model.tscn").instance()
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