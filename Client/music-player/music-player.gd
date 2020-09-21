tool
extends Node


"""
# Music Player

## About
Play a Shuffled Selection of Music in Game

## Help
- NOTE! The inspector does not automatically refresh. You need to click on something else to update the info displayed
- https://godotengine.org/qa/6099/list-of-export-hints
	- amazing resource, keep it!
- https://godotengine.org/qa/570/how-to-play-audio-whilst-changing-scene
- https://godotengine.org/qa/20556/how-to-play-music-across-multiple-scenes-2d
"""


# Control starting/stopping of music
export var playing: bool = false setget play

# Where we emit music from
var player: AudioStreamPlayer
export var player_path: NodePath

# Control Shuffling of music
export var shuffled: bool = false setget shuffle

# Where we load our music from
export(String, DIR) var music_folder = "res://music/" setget load_folder

# Where we currently are in the playlist # NOTE max size of 255 is arbitrary
export(int, 0, 255) var current_song: int = 0 setget change_song

# What the queue of music currently is
export(Array, Resource) var playlist: Array
var playlist_size: int = 0


func _ready():
	"""
	Reset Random (for shuffling)
	"""
	
	# No Identical Shuffles
	randomize()
	
	# prevent unloaded player
	_check_player()


func play(value: bool) -> void:
	"""
	Allow an Editor to test playback and behavior of music player
	"""
	
	# prevent unloaded player
	_check_player()
	
	playing = value
	
	if playing:
		player.play()
	
	if not playing:
		player.stop()


func shuffle(_value: bool) -> void:
	"""
	Allow an Editor to Re-Shuffle the Tracks
	"""
	
	# Note, we do not ever set shuffle to true, since it has no state
	
	# prevent unloaded player
	_check_player()
	
	# Shuffle the playlist
	self.playlist.shuffle()
	

func load_folder(value: String) -> void:
	"""
	Allow anyone to load a different folder of music
	"""
	
	# prevent unloaded player
	_check_player()
	
	# Does NOT Trigger the Setter
	music_folder = value
	
	# on get new folder location, refresh the playlist
	playlist.clear()
	for file_name in _find_files(music_folder):
		
		# Set some info about the stream each time
		var temp:AudioStreamOGGVorbis = load(file_name)
		temp.loop = false
		temp.resource_name = file_name
		playlist += [temp]

	# reset the playlist size
	playlist_size = playlist.size()


func change_song(value: int) -> void:
	"""
	Primary measn of changing tracks is by incrementing the currently playing song index
	This triggers a load of the next track
	If at end of list, move back to front
	Also handle out of range values
	"""
	
	# prevent unloaded player
	_check_player()
	
	# Do not accept out of bound values
	# If found, reset to first song
	if value < 0 or value > playlist_size - 1:
		value = 0
	
	# Does NOT Trigger the Setter
	current_song = value

	# Show What's Next
	print("Now Playing: " + str(playlist[current_song].resource_name) + "[" + str(current_song) + "]")
	
	# Load the Song
	player.stream = playlist[current_song]
	
	# Resume Previous State
	if playing:
		player.play()


func _on_AudioStreamPlayer_finished():
	"""
	When player finishes, load the next song
	"""
	# prevent unloaded player
	_check_player()
	# Trigger the Setter
	self.current_song += 1


func _find_files(path: String) -> Array:
	"""
	Find all of the files in a folder and Returns them as full names
	SPECIFICALLY only for MUSIC (ignores `.import`'s')
	(shamelessy stolen from https://godotengine.org/qa/5175/how-to-get-all-the-files-inside-a-folder?show=80274#a80274)
	"""
	
	# prevent unloaded player
	_check_player()
	
	# Setup Reading the Dir
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin(true)
	
	# Read through the Dir
	var file = dir.get_next()
	while file != '':
		if not file.ends_with("import"):
			files += [path + "/" + file]
		file = dir.get_next()
	return files


func _check_player() -> void:
	"""
	Check if the player is loaded
	and handle it if it is not
	"""
	if not player:
		player = get_node(player_path)




