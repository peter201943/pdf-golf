extends Node


"""
""" # FIXME (docs missing)


# Where we play hurt from (AND DIED)
export var hurt_player_path: NodePath = "hurt"
onready var hurt = get_node(hurt_player_path)

# Where we play health from (AND RESPAWNED)
export var heal_player_path: NodePath = "heal"
onready var heal = get_node(heal_player_path)

# Where we play score from (AND WON)
export var score_player_path: NodePath = "score"
onready var score = get_node(score_player_path)

# Where we play loss from (AND LOST)
export var loss_player_path: NodePath = "loss"
onready var loss = get_node(loss_player_path)

# What we play on incremental events
export(Array, Resource) var hurt_sounds:    Array
export(Array, Resource) var heal_sounds:    Array
export(Array, Resource) var score_sounds:   Array
export(Array, Resource) var loss_sounds:    Array

# What we play on big life events
export(Array, Resource) var death_sounds:   Array
export(Array, Resource) var respawn_sounds: Array

# What we play on big score events
export(Array, Resource) var win_sounds:     Array
export(Array, Resource) var start_sounds:   Array






