extends Control

signal upgrade

var players = []

func addPlayer(id):
	players.append(id)
	upgrade()

func removePlayer(id):
	players.erase(id)
	upgrade()

func getPlayersCount():
	return players.size()

func getPlayers():
	return players

func upgrade():
	$list.clear()
	for playerId in players:
		$list.add_item(String(playerId))
	
	emit_signal("upgrade")