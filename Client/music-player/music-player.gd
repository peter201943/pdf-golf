tool
extends Node


"""
Play a Shuffled Selection of Music in Game
- https://godotengine.org/qa/6099/list-of-export-hints
	- amazing resource, keep it!
"""


# Control starting/stopping of music
export var playing: bool = false setget play

# Where we emit music from
var player: AudioStreamPlayer

# Control Shuffling of music
export var shuffled: bool = false setget shuffle

# Where we load our music from
export(String, DIR) var music_folder = "res://music/" setget load_folder

# What the queue of music currently is
export(Array, Resource) var playlist: Array


func _ready():
	"""
	Get the Player, Tracks
	Shuffle the Music
	"""
	
	# Get the Player
	player = get_node("AudioStreamPlayer")
	
	# Get the Tracks (Load from Filesystem)
	
	# Shuffle the Tracks
	shuffled = true


func play(value: bool) -> void:
	"""
	Allow an Editor to test playback and behavior of music player
	"""
	playing = value

	# if true # FIXME (incomplete)
	# if false # FIXME (incomplete)


func shuffle(value: bool) -> void:
	"""
	Allow an Editor to Re-Shuffle the Tracks
	"""
	
	# Note, we do not ever set shuffle to true, since it has no state
	pass
	
	# if true # FIXME (incomplete)
	# if false # FIXME (incomplete)
	

func load_folder(value: String) -> void:
	"""
	Allow anyone to load a different folder of music
	"""
	
	# DEBUG
	print("load folder called")
	
	music_folder = value
	
	# on get new folder location, refresh the playlist
	playlist.clear()
	#for music_file in load(music_folder):
		#playlist.append(load(music_file))
	
	# var what_is_this = load_folder(music_folder) # ATTN: This will crash the game!!!
	
	# reshuffle the playlist
	shuffled = true





