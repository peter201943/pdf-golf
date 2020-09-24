extends Node


"""
Keeps Count of Health
Emits Helath-Related Signals

Once Health is Drained below zero, health must be re-instantiated
"""


# when we gain health
signal healed(amount)

# when we lose health
signal hurt(amount)

# when we lose too much health
signal died

# when we first start-up
signal respawned


# Total Health we can Have
export(int, 0, 200) var max_life

# Current Health we have
var life: int setget change_life

# whether we can change health
var alive: bool

# UI
export var display_node: NodePath = "count"
onready var display: Label = get_node(display_node)


func _ready():
	"""
	Reset the variables
	"""
	life = max_life
	alive = true
	emit_signal("respawned")
	display.text = str(life)


func change_life(value: int):
	"""
	Add or Remove Life
	"""
	
	# Cannot do much when you're already dead
	if not alive:
		return
	
	# signal effects if hurt
	if value < 0:
		emit_signal("hurt", value)
	
	# signal effects if heal
	if value > 0:
		emit_signal("healed", value)
	
	# update counters
	life += value
	display.text = str(life)
	
	# check if we died
	if life <= 0:
		alive = false
		emit_signal("died")








