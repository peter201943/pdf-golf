extends Node


var player_scene = load("res://Source/Player.tscn")

const DEFAULT_PORT = 5000
const MAX_PEERS = 50


var player_name = 'server'
var players = {}
var map = "psx_demo"
var last_transform


func _ready():
	get_tree().connect("network_peer_connected", self, "player_connected")
	get_tree().connect("network_peer_disconnected", self, "player_disconnected")
	host_game()


remote func register_player(player_name):
	var sender = get_tree().get_rpc_sender_id()
	players[sender] = player_name
	load_player(sender)


func player_connected(id):
	print("Player: " + str(id) + " connected")


func load_player(id):
	rpc_id(id, "load_map", map)
	var root = get_tree().get_root()
	var world = root.get_node(map)
	for player in world.get_node("Players").get_children():
		rpc_id(id, 'add_player', int(player.name), player.transform, players[int(player.name)])
	add_player(id)
	rpc('add_player', id, last_transform, players[id])


func player_disconnected(id):
	print("Player: " + str(id) + " disconnected")
	remove_player(id)
	players.erase(id)


func remove_player(id):
	var root = get_tree().get_root()
	var world = root.get_node(map)
	world.get_node("Players/" + str(id)).queue_free()
	print("player: " + str(id) + " left the game")


func host_game():
	if OS.get_cmdline_args().size() > 0:
		map = OS.get_cmdline_args()[0]
		map = map.to_lower()
	var host = NetworkedMultiplayerENet.new()
	host.create_server(DEFAULT_PORT, MAX_PEERS)
	get_tree().set_network_peer(host)
	
	load_map()
	display_info()
	load_map()


func display_info():
	print("Server running...\n")
	for ip in IP.get_local_addresses():
		if str(ip).split(".")[0] == "192":
			print("Server ip: " + ip)
		print("Server ip: " + ip) # DELETEME
	print(" ") #DELETEME
	print("Server port: " + str(DEFAULT_PORT))
	print("Server max players: " + str(MAX_PEERS))
	print("Map: " + map)


func load_map():
	var map_temp = "res://Source/Maps/" + map + ".tscn"
	var world = load(map_temp).instance()
	var root = get_tree().get_root()
	root.call_deferred('add_child', world)
	print("\nMap Loaded")


func add_player(id):
	var root = get_tree().get_root()
	var world = root.get_node(map)
	
	randomize()
	var spawn_index = randi() % 10
	var spawn_point = world.get_node("SpawnPoints/" + str(spawn_index))
	
	var player = player_scene.instance()
	
	player.set_name(str(id))	
	player.transform = spawn_point.transform
	player.set_network_master(id)
	
	world.get_node("Players").add_child(player)
	last_transform = spawn_point.transform
