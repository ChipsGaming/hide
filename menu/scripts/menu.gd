extends Panel

signal start(map, players)

func _ready():
	get_tree().connect("server_disconnected", self, "onServerDisconnected")
	get_tree().connect("network_peer_connected", self, "onClientConnected")
	get_tree().connect("network_peer_disconnected", self, "onClientDisconnected")

func onServerDisconnected():
	get_tree().set_network_peer(null)
	$actions.enable()
	$status.log("Server disconnected")

func onClientConnected(id):
	if get_tree().is_network_server():
		for playerId in $players.getPlayers():
			rpc_id(id, "addPlayer", playerId)
		rpc("addPlayer", id)

func onClientDisconnected(id):
	if get_tree().is_network_server():
		rpc("removePlayer", id)

func onActionsError(message):
	$status.log(message)

func onHost(port):
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(port, 5)
	get_tree().set_network_peer(peer)
	
	$players.addPlayer(get_tree().get_network_unique_id())
	$actions.disable()
	$status.clear()

func onJoin(host, port):
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(host, port)
	get_tree().set_network_peer(peer)
	
	$actions.disable()
	$status.clear()

func onMapSelect(info):
	resetStartStatus()

func onPlayersUpgrade():
	resetStartStatus()

func onStart():
	emit_signal("start", $maps.getSelectedMap(), $players.getPlayers())

func resetStartStatus():
	if !get_tree().is_network_server():
		return
	var map = $maps.getSelectedMap()
	var playersCount = $players.getPlayersCount()
	
	$start.disabled = map == null || playersCount > map.maxPlayers || playersCount < map.minPlayers

sync func addPlayer(id):
	$players.addPlayer(id)

sync func removePlayer(id):
	$players.removePlayer(id)