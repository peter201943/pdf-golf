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
onready var player: AudioStreamPlayer = get_node("AudioStreamPlayer")

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
	randomize()


func play(value: bool) -> void:
	"""
	Allow an Editor to test playback and behavior of music player
	"""
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
	# Shuffle the playlist
	playlist.shuffle()
	

func load_folder(value: String) -> void:
	"""
	Allow anyone to load a different folder of music
	"""
	
	# DEBUG
	print("load folder called")
	
	# Does NOT trigger Setter
	music_folder = value
	
	# on get new folder location, refresh the playlist
	playlist.clear()
	
	# reset the playlist size
	playlist_size = playlist.size()


func change_song(value: int) -> void:
	"""
	Primary measn of changing tracks is by incrementing the currently playing song index
	This triggers a load of the next track
	If at end of list, move back to front
	Also handle out of range values
	"""
	
	# Do not accept out of bound values
	# If found, reset to first song
	if value < 0 or value > playlist_size:
		value = 0
	
	# Does NOT Trigger Setter
	current_song = value

	# Load the Song
	player.stream = load(playlist[current_song])
	player.stream.loop = false


func _on_AudioStreamPlayer_finished():
	"""
	When player finishes, load the next song
	"""
	# Trigger Setter
	self.current_song += 1
