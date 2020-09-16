# tool # FIXME (add tool mode)
extends Node


"""
SERVER network
""" # FIXME (documentation missing)
# FIXME (rename this script from `Server/Source/network.gd` to `server.gd`)


# What we instantiate per player
var player_scene = load("res://Source/Player.tscn") # FIXME (non external variable for fragile link!)

# Which port we serve from
const DEFAULT_PORT = 5000

# Total players who can exist
const MAX_PEERS = 50

# ??? # FIXME (documentation missing)
var player_name = 'server' # DELETEME (UNUSED)

# handle players without names
var no_name_count: int

# ??? # FIXME (documentation missing)
var players = {}

# the name of the map to load
export(String, "psx_demo") var map_name = "psx_demo"

# where we spawn the next player
var next_spawn_transform: Transform


func _ready():
	"""
	Connects Player Signals, resets global variables, Hosts the Game
	"""
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "player_connected")
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "player_disconnected")
	no_name_count = 0
	host_game() # FIXME (tool-mode needs this to be controlled independently of start-up)


remote func register_player(other_player_name):
	"""
	A request from a player to join this server's session
	"""
	
	# get their id
	var sender = get_tree().get_rpc_sender_id()
	
	# add their id and name to our list
	if other_player_name == "":
		no_name_count += 1
		other_player_name = "No-Name-" + str(no_name_count)
	players[sender] = other_player_name
	
	# load them
	load_player(sender)


func player_connected(id):
	"""log a successful connection"""
	print("I (SERVER) connected THEM (PLAYER #" + str(id) + ")")


func load_player(id):
	"""
	Load a connecting player onto everyone's instance of the game
	"""
	
	# Tell the player to load the current map
	rpc_id(id, "load_map", map_name)
	
	# refresh map variables
	var root = get_tree().get_root()
	var world = root.get_node(map_name)
	
	# tell EACH CURRENT PLAYER to add the new player to THEIR instance of the game
	for player in world.get_node("Players").get_children(): # FIXME (fragile link; make external)
		rpc_id(id, 'add_player', int(player.name), player.transform, players[int(player.name)])
	
	# WE add the new player to OUR instance of the game
	add_player(id)
	
	# tell the NEW PLAYER to add themselves to THEIR instance of the game
	rpc('add_player', id, next_spawn_transform, players[id])


func player_disconnected(id):
	"""briefly describe why this is here""" # FIXME (documentation missing)
	print("Player: " + str(id) + " disconnected")
	remove_player(id)
	players.erase(id)


func remove_player(id):
	"""
	Destroys the instance of a player from the map
	"""
	
	# Refresh map variables
	var root = get_tree().get_root()
	var world = root.get_node(map_name)
	
	# Delete the player node
	for player in world.get_node("Players/").get_children(): # FIXME (fragile link; make external)
		if player.name == str(id):
			player.queue_free()
	
	print("player: " + str(id) + " left the game")


func host_game():
	"""briefly describe why this is here""" # FIXME (documentation missing)
	
	# Instantiate the ENET daemon
	var host = NetworkedMultiplayerENet.new()
	host.create_server(DEFAULT_PORT, MAX_PEERS)
	get_tree().set_network_peer(host)
	
	# Load Map twice?
	load_map()
	display_info()
	load_map()


func display_info():
	"""
	Display basic info about the server, what IP Addresses are available
	"""
	print("Server Debug Info\n----------")
	for ip in IP.get_local_addresses():
		if str(ip).split(".")[0] == "192":
			print("IPv6 Local:    " + ip)
		elif str(ip).split(".")[0] == "127":
			print("IPv4 Loopback: " + ip)
		elif str(ip).split(":")[0] == "fe80":
			print("IPv6 Local:    " + ip)
		elif str(ip) == "::1":
			print("IPv6 Loopback: " + ip)
		elif str(ip).split(".").size() > 1 :
			print("IPv4 Other:    " + ip)
		elif str(ip).split(":").size() > 1 :
			print("IPv6 Other:    " + ip)
		else:
			print("IPv? Other:    " + ip)
	print("----------")
	print("Port: " + str(DEFAULT_PORT))
	print("Max Players: " + str(MAX_PEERS))
	print("Map: " + map_name)


func load_map(): # FIXME (add `map_name: str = ""` as parameter (and not as global))
	"""
	Locates the map inside source files and loads it
	"""
	# find the map file-path
	var map_temp = "res://Source/Maps/" + map_name + ".tscn"  # FIXME (fragile link; make external variable)
	# instantiate the map
	var world = load(map_temp).instance()
	# set the root
	var root = get_tree().get_root()
	# set the new map as the current map
	root.call_deferred('add_child', world)	
	print("\nMap Loaded")


func add_player(id):
	"""
	Adds a new player to the current game
	- instantiates a model
	- spawns the model randomly
	"""
	
	# Refresh map properties
	var root = get_tree().get_root() # FIXME (make permanent variable)
	var world = root.get_node(map_name) # FIXME (make permanent variable)
	
	# set the spawn point for this player
	randomize()
	var spawn_index = randi() % 10
	var spawn_point = world.get_node("SpawnPoints/" + str(spawn_index)) # FIXME (fragile link; make external)
	next_spawn_transform = spawn_point.transform
	
	# Make a new character for each connecting player
	print("SERVER adding player...") # DELETEME (temp debug)
	var player = player_scene.instance()
	
	# set networking properties of player
	player.set_name(str(id))
	player.transform = spawn_point.transform
	player.set_network_master(id)
	world.get_node("Players").add_child(player)  # FIXME (fragile link; make external)
	print("SERVER adding player... done") # DELETEME (temp debug)
	
