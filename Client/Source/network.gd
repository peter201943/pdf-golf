extends Node

"""briefly describe why this is here""" # FIXME (documentation missing)

var player_name = "player 1"

signal connection_failed()
signal connection_succeeded()
signal game_ended()
signal game_error(what)

var player_scene = load("res://Source/Player.tscn") # FIXME (fragile link; make external)
var map = "base" # map_name

var players = {}


func _ready():
	"""briefly describe why this is here""" # FIXME (documentation missing)
	get_tree().connect("network_peer_connected",    self, "player_connected")
	get_tree().connect("network_peer_disconnected", self, "player_disconnected")
	get_tree().connect("connected_to_server",       self, "_connected_ok")
	get_tree().connect("connection_failed",         self, "_connection_failed")
	get_tree().connect("server_disconnected",       self, "_server_disconnected")


func _connected_ok():
	"""briefly describe why this is here""" # FIXME (documentation missing)
	emit_signal("connection_succeeded")
	rpc_id(1, "register_player", player_name)


func _connection_failed():
	"""briefly describe why this is here""" # FIXME (documentation missing)
	get_tree().set_network_peer(null)
	emit_signal("connection_failed")


func _server_disconnected():
	"""briefly describe why this is here""" # FIXME (documentation missing)
	emit_signal("game_error", "Server disconnected")
	end_game()


func end_game():
	"""briefly describe why this is here""" # FIXME (documentation missing)
	if has_node("/root/" + map):
		get_node("/root/" + map).queue_free()
	emit_signal("game_ended")
	players = {}


func join_game(ip, port, new_player_name):
	"""briefly describe why this is here""" # FIXME (documentation missing)
	player_name = new_player_name
	var client = NetworkedMultiplayerENet.new()
	client.create_client(ip, port)
	get_tree().set_network_peer(client)


remote func load_map(map_name):
	"""briefly describe why this is here""" # FIXME (documentation missing)
	map = map_name
	var map_temp = "res://Source/Maps/" + map + ".tscn" # FIXME (fragile link; make external)
	var world = load(map_temp).instance()
	var root = get_tree().get_root()
	root.call_deferred('add_child', world)
	print("\nMap: " + map)


remote func add_player(id, last_transform, player_name): # FIXME REFACTOR (long method; low cohesion)
	"""briefly describe why this is here""" # FIXME (documentation missing)
	yield(get_tree().create_timer(1.0), "timeout")
	var root = get_tree().get_root()
	var world = root.get_node(map)
	
	var player = player_scene.instance()
	
	player.set_name(str(id))
	player.transform = last_transform
	player.set_network_master(id)
	player.set_player_name(player_name)
	
	players[id] = player_name
	
	world.get_node("Players").add_child(player)
	
	if id == get_tree().get_network_unique_id():
		root.get_node("Main").hide()


func player_connected(id):
	"""briefly describe why this is here""" # FIXME (documentation missing)
	print("THIS player (" + player_name + ") just joined THEIR server as player #" + str(id))


func player_disconnected(id):
	"""briefly describe why this is here""" # FIXME (documentation missing)
	var root = get_tree().get_root()
	var world = root.get_node(map)
	world.get_node("Players/" + str(id)).queue_free()  # FIXME (fragile link; make external)
	print("WE (" + player_name + ") have left THEIR game (player #" + str(id) + ")")
