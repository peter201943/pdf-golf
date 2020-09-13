# tool # FIXME (add tool mode)
extends Node


"""
CLIENT network
""" # FIXME (documentation missing)
# FIXME (rename this script from `Client/Source/network.gd` to `client.gd`)


# FIXME (documentation missing)
var player_name = "player 1"

 # FIXME (documentation missing)
signal connection_failed()

 # FIXME (documentation missing)
signal connection_succeeded()

 # FIXME (documentation missing)
signal game_ended()

 # FIXME (documentation missing)
signal game_error(what)

# FIXME (documentation missing)
var player_scene = load("res://Source/Player.tscn") # FIXME (fragile link; make external)
var map = "base" # map_name

# FIXME (documentation missing)
var players = {}


func _ready():
	"""
	attach network signals to local methods
	"""
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected",    self, "player_connected")
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "player_disconnected")
	# warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server",       self, "_connected_ok")
	# warning-ignore:return_value_discarded
	get_tree().connect("connection_failed",         self, "_connection_failed")
	# warning-ignore:return_value_discarded
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
	# FIXME (this function only exists in CLIENT player)
	
	# Reset the map
	if has_node("/root/" + map):
		get_node("/root/" + map).queue_free()
		
	# Alert any game objects to stop
	emit_signal("game_ended")
	
	# Reset `players` list
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


remote func add_player(id, last_transform, other_player_name): # FIXME REFACTOR (long method; low cohesion)
	"""
	Allow a server to add a new PUPPET player to OUR game
	"""
	
	# Spawn timer (don't let millions spawn in instantly)
	yield(get_tree().create_timer(1.0), "timeout")
	
	# Refresh map properties
	var root = get_tree().get_root() # FIXME (make permanent variable)
	var world = root.get_node(map) # FIXME (make permanent variable)
	
	# Instantiate a player
	print("CLIENT adding player...") # DELETEME (temp debug)
	var player = player_scene.instance()
	
	# set networking properties of player
	player.set_name(str(id))
	player.transform = last_transform
	player.set_network_master(id)
	world.get_node("Players").add_child(player) # TEMP (See if this works)
	
	# NOTE: the player MUST be instantiated BEFORE you can call this line!
	# (member will not exist until `_ready()` is called)
	player.display_name.text = other_player_name
	
	# Add player to players list
	players[id] = other_player_name
	print("CLIENT adding player... done") # DELETEME (temp debug)
	
	# ???
	if id == get_tree().get_network_unique_id():
		print("HIDING MAIN!")
		root.get_node("Main").hide()


func player_connected(id):
	"""briefly describe why this is here""" # FIXME (documentation missing)
	print("THIS CLIENT (" + player_name + ") just joined THEIR SERVER as player #" + str(id))


func player_disconnected(id):
	"""briefly describe why this is here""" # FIXME (documentation missing)
	var root = get_tree().get_root()
	var world = root.get_node(map)
	world.get_node("Players/" + str(id)).queue_free()  # FIXME (fragile link; make external)
	print("WE (" + player_name + ") have left THEIR game (player #" + str(id) + ")")
