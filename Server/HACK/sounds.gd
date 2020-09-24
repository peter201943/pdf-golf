extends Node


"""
Plays sounds on certain events
Holds sound data (see exported interface)

FOR THE LOVE OF GOD REFACTOR THIS INTO SOMETHING BETTER!!!
(SOOOOO much duplicated code, my god)

help: https://godotengine.org/qa/8135/choosing-a-random-word-from-an-array
"""


# Prevent Irritating Errors
var ready: bool = false
var queue: Array = []


# Where we play hurt from (AND DIED)
export var hurt_player_path: NodePath = "hurt"
onready var hurt: AudioStreamPlayer3D = get_node(hurt_player_path)

# Where we play health from (AND RESPAWNED)
export var heal_player_path: NodePath = "heal"
onready var heal: AudioStreamPlayer3D = get_node(heal_player_path)

# Where we play score from (AND WON)
export var score_player_path: NodePath = "score"
onready var score: AudioStreamPlayer3D = get_node(score_player_path)

# Where we play loss from (AND LOST)
export var loss_player_path: NodePath = "loss"
onready var loss: AudioStreamPlayer3D = get_node(loss_player_path)


"""
What we play on incremental events
"""

# Hurt Event
export(Array, Resource) var hurt_sounds:    Array
onready var hurts: int = hurt_sounds.size() # for random picking

# Heal Event
export(Array, Resource) var heal_sounds:    Array
onready var heals: int = heal_sounds.size() # for random picking

# Score Event
export(Array, Resource) var score_sounds:   Array
onready var scores: int = score_sounds.size() # for random picking

# Loss Event
export(Array, Resource) var loss_sounds:    Array
onready var losses: int = loss_sounds.size() # for random picking

# Death Event
export(Array, Resource) var death_sounds:   Array
onready var deaths: int = death_sounds.size() # for random picking

# Respawn Event
export(Array, Resource) var respawn_sounds: Array
onready var respawns: int = respawn_sounds.size() # for random picking

# Win Event
export(Array, Resource) var win_sounds:     Array
onready var wins: int = win_sounds.size() # for random picking

# Counting Event
export(Array, Resource) var start_sounds:   Array
onready var starts: int = start_sounds.size() # for random picking




func _ready():
	"""
	Prevent This from doing anything until it is loaded
	(why isnt this a thing in godot?!?!?!)
	Play back any recorded commands
	"""
	ready = true
	for item in queue:
		if item[0] == "_on_health_died": _on_health_died()
		if item[0] == "_on_health_healed": _on_health_healed(item[1])
		if item[0] == "_on_health_hurt": _on_health_hurt(item[1])
		if item[0] == "_on_health_respawned": _on_health_respawned()
		if item[0] == "_on_score_counting": _on_score_counting()
		if item[0] == "_on_score_lost": _on_score_lost(item[1])
		if item[0] == "_on_score_scored": _on_score_scored(item[1])
		if item[0] == "_on_score_won": _on_score_won()
	queue.clear()




"""
Health Related Sound Effect Events
"""

func _on_health_died():
	if not ready:
		queue += [["_on_health_died"]]
		return
	if hurt.playing:
		hurt.stop()
	hurt.stream = death_sounds[randi() % deaths]
	hurt.play()


func _on_health_healed(amount):
	if not ready:
		queue += [["_on_health_healed"], amount]
		return
	if heal.playing:
		heal.stop()
	heal.stream = heal_sounds[randi() % heals]
	heal.play()


func _on_health_hurt(amount):
	if not ready:
		queue += [["_on_health_hurt"], amount]
		return
	if hurt.playing:
		hurt.stop()
	hurt.stream = hurt_sounds[randi() % hurts]
	hurt.play()


func _on_health_respawned():
	if not ready:
		queue += [["_on_health_respawned"]]
		return
	if heal.playing:
		heal.stop()
	heal.stream = respawn_sounds[randi() % respawns]
	heal.play()


"""
Score Related Sound Effects
"""

func _on_score_counting():
	if not ready:
		queue += [["_on_score_counting"]]
		return
	if score.playing:
		score.stop()
	score.stream = start_sounds[randi() % starts]
	score.play()


func _on_score_lost(amount):
	if not ready:
		queue += [["_on_score_lost"], amount]
		return
	if loss.playing:
		loss.stop()
	loss.stream = loss_sounds[randi() % losses]
	loss.play()


func _on_score_scored(amount):
	if not ready:
		queue += [["_on_score_scored"], amount]
		return
	if score.playing:
		score.stop()
	score.stream = score_sounds[randi() % scores]
	score.play()


func _on_score_won():
	if not ready:
		queue += [["_on_score_won"]]
		return
	if loss.playing:
		loss.stop()
	loss.stream = win_sounds[randi() % wins]
	loss.play()

