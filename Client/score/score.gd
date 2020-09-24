extends Node


"""
Keeps Count of Score
Emits Helath-Related Signals

Once Health is Drained below zero, health must be re-instantiated
"""


# when we score points
signal scored

# when we lose points
signal lost

# when we win the game
signal won

# when we awaken
signal counting


# Total Score we can Have
export(int, 0, 200) var max_score

# Current Health we have
var score: int setget change_score

# whether we can change score
var scoring: bool

# UI
export var display_node: NodePath = "count"
onready var display: Label = get_node(display_node)


func _ready():
	"""
	Reset the Variables
	"""
	score = max_score
	scoring = true
	emit_signal("counting")
	display.text = str(score)


func change_score(value: int):
	"""
	Add or Remove Score
	"""
	
	# hard to score once you've already won
	if not scoring:
		return
	
	# signal effects if lose
	if value < 0:
		emit_signal("lost")
	
	# signal effects if score
	if value > 0:
		emit_signal("scored")
	
	# update counters
	score += value
	display.text = str(score)
	
	# check if we won
	if score >= max_score:
		scoring = false
		emit_signal("won")








