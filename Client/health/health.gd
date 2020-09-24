extends Node


"""
Keeps Count of Health
Emits Helath-Related Signals

Once Health is Drained below zero, health must be re-instantiated
"""


# when we gain health
signal heal

# when we lose health
signal hurt

# when we lose too much health
signal die

# when we first start-up
signal respawn


# Total Health we can Have
export(int, 0, 200) var max_life

# Current Health we have
var life: int setget change_life

# whether we can change health
var alive: bool


func _ready():
	"""
	Reset the variables
	"""
	life = max_life
	alive = true
	emit_signal("respawn")


func change_life(value: int):
	"""
	Add or Remove Life
	"""
	
	# Cannot do much when you're already dead
	if not alive:
		return
	
	if value < 0:
		emit_signal("hurt")
		
	if value > 0:
		emit_signal("heal")
	
	life += value
	
	# check if we died
	if life <= 0:
		alive = false
		emit_signal("die")








