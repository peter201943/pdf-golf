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

var scoring: bool


func _ready():
	"""
	Reset the Variables
	"""
	score = max_score
	scoring = true
	emit_signal("counting")


func change_score(value: int):
	"""
	Add or Remove Score
	"""
	
	# hard to score once you've already won
	if not scoring:
		return
	
	if value < 0:
		emit_signal("lost")
		
	if value > 0:
		emit_signal("scored")
	
	score += value
	
	# check if we won
	if score >= max_score:
		scoring = false
		emit_signal("won")








