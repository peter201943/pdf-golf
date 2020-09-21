tool
extends Node


"""
# Music Player

## About
Play a Shuffled Selection of Music in Game

## Help
- https://godotengine.org/qa/6099/list-of-export-hints
	- amazing resource, keep it!
- https://godotengine.org/qa/570/how-to-play-audio-whilst-changing-scene
"""


# Control starting/stopping of music
export var playing: bool = false setget play

# Where we emit music from
var player: AudioStreamPlayer

# Control Shuffling of music
export var shuffled: bool = false setget shuffle

# Where we load our music from
export(String, DIR) var music_folder = "res://music/" setget load_folder

# Where we currently are in the playlist
export(int, 0, 255) var current_song: int = 0

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
	# load_folder(music_folder) # ATTN (do we need this step? This will have already been loaded, and we do not want to reset this)
	
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
	# shuffled = true # ATTN (do we want to reshuffle each time? maybe this is better left manually controlled)


func _on_AudioStreamPlayer_finished():
	"""
	When player finishes, load the next song
	If at end of list, move back to front
	"""
	pass # Replace with function body.
